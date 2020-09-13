syntax on
colo gruvbox

set visualbell

set nu
set encoding=utf-8
set fileencoding=utf-8

autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype yml,yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2

set shiftwidth=4

set undofile "Maintains undo history over sessions
set undodir=~/.vim/undodir

filetype plugin indent on

set backspace=indent,eol,start

let g:go_fmt_command="goimports"
let g:go_auto_type_info=1

let g:go_auto_sameids = 1
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 0
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_fmt_experimental = 1
let g:go_metalinter_autosave=1
let g:go_metalinter_autosave_enabled=['golint', 'govet']


set omnifunc=go#complete#Complete
set completeopt=longest,menuone

imap <C-@> <C-Space>
imap <C-Space> <C-x><C-o>

"noremap <C-space> <C-x><C-o>
"au filetype go inoremap <C-space> <C-x><C-o>
"au filetype go inoremap <buffer> . .<C-x><C-o>

" NERDTree plugin specific commands
:nnoremap <C-g> :NERDTreeToggle<CR>

"let g:ycm_key_invoke_completion=''
"let g:ycm_key_invoke_completion=0
"au filetype go inoremap <C-Space> <C-X><C-U>

"Add Powerline fonts for airline.
let g:airline_powerline_fonts=1 

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

"let g:ycm_log_level='debug'
"
" disable arrows 
"
"noremap <Up> <NOP>
"noremap <Down> <NOP>
"noremap <Left> <NOP>
"noremap <Right> <NOP>
