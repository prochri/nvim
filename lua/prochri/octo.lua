local old_octo_graqphql = require("octo.gh.graphql")
local old_octo_telescope = require("octo.pickers.telescope.provider")

local gh = require("octo.gh")
local utils = require("octo.utils")

local entry_maker = require("octo.pickers.telescope.entry_maker")

local actions = require("telescope.actions")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")

-- TODO: make this flexible
local repository_users_query = [[
query($endCursor: String) {
  repository(owner: "%s", name: "%s") {
    id
    assignableUsers(first: 100, after: $endCursor, query: "%s") {
      nodes {
        id
        name
        login
      }
    }
  }
}
]]

local function escape_char(string)
  local escaped, _ = string.gsub(string, '["\\]', {
    ['"'] = '\\"',
    ["\\"] = "\\\\",
  })
  return escaped
end

local mygraphql = function(query, ...)
  if query ~= "repository_users_query" then
    return old_octo_graqphql(query, ...)
  end

  local opts = { escape = true }
  for _, v in ipairs({ ... }) do
    if type(v) == "table" then
      opts = vim.tbl_deep_extend("force", opts, v)
      break
    end
  end
  local escaped = {}
  for _, v in ipairs({ ... }) do
    if type(v) == "string" and opts.escape then
      local encoded = escape_char(v)
      table.insert(escaped, encoded)
    else
      table.insert(escaped, v)
    end
  end
  return string.format(repository_users_query, unpack(escaped))
end

local dropdown_opts = require("telescope.themes").get_dropdown({
  layout_config = {
    width = 0.4,
    height = 15,
  },
  prompt_title = false,
  results_title = false,
  previewer = false,
})

---@diagnostic disable-next-line: duplicate-set-field
function old_octo_telescope.select_user(cb)
  print("select_user")
  local opts = vim.deepcopy(dropdown_opts)
  opts.layout_config = {
    width = 0.4,
    height = 15,
  }
  local repo = utils.get_remote_name()
  local owner, name = utils.split_repo(repo)
  print(repo)

  --local queue = {}
  local function get_user_requester()
    return function(prompt)
      local query = mygraphql("repository_users_query", owner, name, prompt)
      local output = gh.run({
        args = { "api", "graphql", "--paginate", "-f", string.format("query=%s", query) },
        mode = "sync",
      })
      if output then
        local users = {}
        local responses = utils.get_pages(output)
        for _, resp in ipairs(responses) do
          for _, user in ipairs(resp.data.repository.assignableUsers.nodes) do
            if not user.teams then
              -- regular user
              if not vim.tbl_contains(vim.tbl_keys(users), user.login) then
                users[user.login] = {
                  id = user.id,
                  login = user.login,
                }
              end
            end
          end
        end

        local results = {}
        -- process orgs with teams
        for _, user in pairs(users) do
          table.insert(results, user)
        end
        return results
      else
        return {}
      end
    end
  end

  pickers
    .new(opts, {
      finder = finders.new_dynamic({
        entry_maker = entry_maker.gen_from_user(),
        fn = get_user_requester(),
      }),
      sorter = sorters.get_fuzzy_file(opts),
      attach_mappings = function()
        actions.select_default:replace(function(prompt_bufnr)
          local selected_user = action_state.get_selected_entry(prompt_bufnr)
          actions._close(prompt_bufnr, true)
          if not selected_user.teams then
            -- user
            cb(selected_user.value)
          else
            -- organization, pick a team
            pickers
              .new(opts, {
                prompt_title = false,
                results_title = false,
                preview_title = false,
                finder = finders.new_table({
                  results = selected_user.teams,
                  entry_maker = entry_maker.gen_from_team(),
                }),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function()
                  actions.select_default:replace(function(prompt_bufnr)
                    local selected_team = action_state.get_selected_entry(prompt_bufnr)
                    actions.close(prompt_bufnr)
                    cb(selected_team.team.id)
                  end)
                  return true
                end,
              })
              :find()
          end
        end)
        return true
      end,
    })
    :find()
end
old_octo_telescope.picker.users = old_octo_telescope.select_user
