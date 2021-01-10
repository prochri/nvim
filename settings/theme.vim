autocmd! VimEnter * ++nested colorscheme gruvbox
set background=dark
let g:gruvbox_italic = 1
let g:gruvbox_undercurl = 1
let g:gruvbox_contrast_light = 'medium'

" settings for builtin lsp
hi! link LspDiagnosticsSignError GruvboxRedSign
hi! link LspDiagnosticsSignWarning GruvboxOrangeSign
hi! link LspDiagnosticsSignInformation GruvboxYellowSign
hi! link LspDiagnosticsSignHint GruvboxBlueSign
hi! link LspDiagnosticsFloatingError GruvboxRed
hi! link LspDiagnosticsFloatingWarning GruvboxOrange
hi! link LspDiagnosticsFloatingInfo GruvboxYellow
hi! link LspDiagnosticsFloatingHint GruvboxBlue
hi! link LspDiagnosticsDefaultError GruvboxRed
hi! link LspDiagnosticsDefaultWarning GruvboxOrange
hi! link LspDiagnosticsDefaultInfo GruvboxYellow
hi! link LspDiagnosticsDefaultHint GruvboxBlue
hi! link LspDiagnosticsSelectedText GruvboxRed
hi! link LspDiagnosticsCodeLens GruvboxGray

" error = '  '
" warn = '  '
