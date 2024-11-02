vim.cmd[[
let g:ale_linters = {
\   'go': ['staticcheck', 'golangci-lint', 'punused'],
\   'vue': ['eslint'],
\   'typescript': ['eslint', 'tsserver', 'typecheck'],
\   'haskell': [],
\   'php':[],
\}

let g:ale_fixers = {
\	'vue': ['prettier'],
\	'javascript': ['prettier'],
\	'typescript': ['prettier', 'eslint']
\}

" let g:ale_php_phpcs_executable = 'C:\app\phpcs\PHP_CodeSniffer\bin\phpcs.bat'
" let g:ale_php_phpcs_executable = 'C:\app\phpcs\PHP_CodeSniffer\bin\phpcs'
" let g:ale_php_phpcs_standard = 'PSR2'
" let g:ale_php_phpcs_use_global = 1

let g:ale_typescript_tsc_options = '--noImplicitAny'


let g:ale_fix_on_save = 0

let g:ale_set_highlights = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_save = 1
let g:ale_set_balloons = 1

let g:ale_sign_error = '🔥'
let g:ale_sign_warning = '💣'

let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_info_str = 'Info'
let g:ale_echo_msg_warning_str = 'Warning'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" let g:ale_virtualtext_prefix = '%comment% %type% '
let g:ale_virtualtext_prefix = '%comment% 💣 '

"let g:ale_floating_preview = 1
"let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']

"let g:ale_use_neovim_diagnostics_api = 0
"let g:ale_virtualtext_cursor = 0

]]
