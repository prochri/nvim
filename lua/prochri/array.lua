--- lua ls does not support proper generic classes yet :'(

local M = {}

---@deprecated
---@generic T
---@param arr T[]
---@return Array<T>
M.from = function(arr)
  vim.validate("arr", arr, "table")
  setmetatable(arr, M)
  return arr
end

---@deprecated
---@generic T
---@param self Array<T>
---@return T[]
function M.as(self)
  return self
end

---@generic T
---@generic R
---@param arr T[]
---@param mapper fun(value: T): R
---@return R[]
function M.map(arr, mapper)
  vim.validate("mapper", mapper, "callable")
  local retarr = M.from({})
  for _, v in ipairs(arr) do
    table.insert(retarr, mapper(v))
  end
  return retarr
end

---@generic T
---@generic R
---@param arr T[]
---@param f fun(value: T): any
function M.forEach(arr, f)
  vim.validate("f", f, "callable")
  vim.validate("arr", arr, "table")
  for _, v in ipairs(arr) do
    f(v)
  end
end

return M
