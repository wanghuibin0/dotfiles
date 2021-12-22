source "./default.vim"

" use zc and zo to close and open foldings

" {{{ General
set nocompatible
filetype plugin indent on
syntax on

set history=200

nnoremap <space>, <nop>
let mapleader=' '

set autoread
au FocusGained,BufEnter * checktime

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" remove trailing whitespace when saving
autocmd BufWritePre * :%s/\s\+$//e

set showmode showcmd
set number relativenumber
set ruler
set scrolloff=3
set cmdheight=2
set updatetime=300
set wildmode=longest,list

set laststatus=2
" set statusline=%f
" set statusline+=%=
" set statusline+=%l
" set statusline+=/
" set statusline+=%L
" set statusline+=\ buf:%n
" set statusline+=\ reg:%{v:register}
"
" function! WindowNumber()
"   let str=tabpagewinnr(tabpagenr())
"   return str
" endfunction
"
" set statusline+=\ win:%{WindowNumber()}

" Marker based folding in vim files
autocmd FileType vim setlocal foldmethod=marker

set novisualbell
set encoding=utf-8
set hidden
" set spell "spelllang=en_us,zh_cn

set nobackup
set nowritebackup

set wrap
set textwidth=79
set autoindent smartindent
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab shiftround
set list listchars=tab:▸\ ,trail:.,
set linebreak

set termguicolors

set pastetoggle=<F9>

set hlsearch incsearch ignorecase smartcase
set showmatch matchtime=2

set backspace=2  "indent,eol,start
set matchpairs+=<:>
runtime macros/matchit.vim

"set mouse-=a

noremap Y y$

" remember the cursor position of this file when it was last closed
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g'\"" |
      \ endif
" http://vim.wikia.com/wiki/Speed_up_Syntax_Highlighting
autocmd BufEnter * syntax sync maxlines=500

"map key * and # to search the text that have been visualized.
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

imap <F2> <C-R>=strftime("%Y-%m-%d")<CR>
imap <F3> <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>

for s:i in range(1, 9)
  " <Leader>[1-9] move to window [1-9]
  execute 'nnoremap <Leader>'.s:i ' :'.s:i.'wincmd w<CR>'

  " <Leader><leader>[1-9] move to tab [1-9]
  execute 'nnoremap <Leader><Leader>'.s:i s:i.'gt'

  " <Leader>b[1-9] move to buffer [1-9]
  execute 'nnoremap <Leader>b'.s:i ':b'.s:i.'<CR>'
endfor
unlet s:i

" let q quit the help buffer
autocmd FileType help noremap <buffer> q :q<cr>

set guifont=SauceCodePro\ Nerd\ Font\ Mono

" }}}

" {{{ Plug install
call plug#begin('~/.vim/plugged')

Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'markonm/traces.vim'

Plug 'mhinz/vim-startify'
Plug 'junegunn/seoul256.vim'
Plug 'liuchengxu/eleline.vim'
Plug 'liuchengxu/space-vim-theme'

Plug 'dominikduda/vim_current_word'

Plug 'voldikss/vim-floaterm'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'kdheepak/lazygit.nvim'

" Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Plug 'liuchengxu/vista.vim'  " replace tagbar
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'
" Plug 'puremourning/vimspector', { 'on': ['<Plug>VimspectorLaunch'] }

Plug 'liuchengxu/vim-which-key' ", { 'on': ['WhichKey', 'WhichKey!'] }

" Plug 'voldikss/vim-translator'

" Plug 'rhysd/vim-grammarous'

call plug#end()
" }}}

" {{{ theme settings
" colo seoul256
colo space_vim_theme
" }}}

" {{{ startify settings
let g:startify_bookmarks = [
      \ { 'b': '~/.bashrc' },
      \ { 'v': '~/.myconfig/init.vim' },
      \ ]
let g:startify_lists = [
      \ { 'header': ['   Bookmarks'],      'type': 'bookmarks' },
      \ { 'header': ['   MRU'],            'type': 'files' },
      \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
      \ ]
nmap <leader>s :Startify<cr>
" }}}

" {{{ floaterm settings
let g:floaterm_keymap_toggle = '<C-t>'
let g:floaterm_opener = 'vsplit'
let g:floaterm_width = 0.8
let g:floaterm_height = 0.8

nnoremap <leader>tt :FloatermToggle<cr>
nnoremap <leader>tf :FloatermNew fff<cr>
nnoremap <leader>tn :FloatermNew nnn<cr>
nnoremap <leader>tg :FloatermNew gitui<cr>
nnoremap <leader>tp :FloatermNew python<cr>
" }}}

" {{{ fzf settings
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fb :Buffers<cr>
nnoremap <leader>fl :BLines<cr>
nnoremap <leader>fm :Marks<cr>
nnoremap <leader>fw :Windows<cr>
nnoremap <leader>fr :History<cr>
nnoremap <leader>fc :Commands<cr>
nnoremap <leader>fk :Maps<cr>
nnoremap <leader>fh :Helptags<cr>
nnoremap <leader>fh :Filetypes<cr>

" search the selected text or the word under cursor with rg
if has('nvim')
  tnoremap <silent> <expr> <M-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif
vmap <silent> <leader>fs "hy:Rg<cr><M-r>h
nmap <silent> <leader>fs :Rg<cr>

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
"　}}}

" {{{ lazygit settings
nnoremap <silent> <leader>gg :LazyGit<CR>
" }}}

"" {{{ Coc settings
"" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c
"
"" Always show the signcolumn, otherwise it would shift the text each time
"" diagnostics appear/become resolved.
"if has("nvim-0.5.0") || has("patch-8.1.1564")
"  " Recently vim can merge signcolumn and number column into one
"  set signcolumn=number
"else
"  set signcolumn=yes
"endif
"
"" Use tab for trigger completion with characters ahead and navigate.
"" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Use <c-space> to trigger completion.
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"endif
"
"" Make <CR> auto-select the first completion item and notify coc.nvim to
"" format on enter, <cr> could be remapped by other vim plugin
"inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
"" Use `[g` and `]g` to navigate diagnostics
"" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
"" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"
"" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>
"
"function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  elseif (coc#rpc#ready())
"    call CocActionAsync('doHover')
"  else
"    execute '!' . &keywordprg . " " . expand('<cword>')
"  endif
"endfunction
"
"" Highlight the symbol and its references when holding the cursor.
"" autocmd CursorHold * silent call CocActionAsync('highlight')
"
"" change color for coc float error info
"" so that we can see the words clearly
"" autocmd BufEnter * highlight CocErrorFloat ctermfg=DarkBlue
"
"" Symbol renaming.
"nmap <leader>cr <Plug>(coc-rename)
"
"" Formatting selected code.
"xmap <leader>cf  <Plug>(coc-format-selected)
"nmap <leader>cf  <Plug>(coc-format-selected)
"
"" Update signature help on jump placeholder.
"autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"
"" Map function and class text objects
"" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"omap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap af <Plug>(coc-funcobj-a)
"xmap ic <Plug>(coc-classobj-i)
"omap ic <Plug>(coc-classobj-i)
"xmap ac <Plug>(coc-classobj-a)
"omap ac <Plug>(coc-classobj-a)
"
"" Add `:Format` command to format current buffer.
"command! -nargs=0 Format :call CocAction('format')
"
"" Add `:Fold` command to fold current buffer.
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
"" Mappings for CoCList
"" Show all diagnostics.
"nnoremap <silent><nowait> <space>cd  :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent><nowait> <space>ce  :<C-u>CocList extensions<cr>
"" Show commands.
"nnoremap <silent><nowait> <space>cc  :<C-u>CocList commands<cr>
"" Find symbol of current document.
"nnoremap <silent><nowait> <space>co  :<C-u>CocList outline<cr>
"" Search workspace symbols.
"nnoremap <silent><nowait> <space>cs  :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent><nowait> <space>cj  :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent><nowait> <space>ck  :<C-u>CocPrev<CR>
"
"" }}}

"" {{{ Vista settings
"" How each level is indented and what to prepend.
"" This could make the display more compact or more spacious.
"" e.g., more compact: ["▸ ", ""]
"" Note: this option only works for the kind renderer, not the tree renderer.
""let g:vista_icon_indent = ["▸ ", ""]
"let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
"
"" Executive used when opening vista sidebar without specifying it.
"" See all the avaliable executives via `:echo g:vista#executives`.
"let g:vista_default_executive = 'coc'
"
"" Set the executive for some filetypes explicitly. Use the explicit executive
"" instead of the default one for these filetypes when using `:Vista` without
"" specifying the executive.
"" let g:vista_executive_for = {
""       \ 'cpp': 'coc',
""       \ }
"
"" To enable fzf's preview window set g:vista_fzf_preview.
"" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
"" For example:
"let g:vista_fzf_preview = ['right:50%']
"
"" Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
"let g:vista#renderer#enable_icon = 1
"
"" The default icons can't be suitable for all the filetypes, you can extend it as you wish.
"let g:vista#renderer#icons = {
"\   "function": "\uf794",
"\   "variable": "\uf71b",
"\  }
"
"nnoremap <leader>v :Vista!!<cr>
"" }}}

"" {{{ Ultisnips settings
"let g:UltiSnipsEditSplit="vertical"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"" }}}

"" {{{ vimspector
"let g:vimspector_enable_mappings = 'HUMAN'
"
"" for normal mode - the word under the cursor
"nmap <Leader>di <Plug>VimspectorBalloonEval
"" for visual mode, the visually selected text
"xmap <Leader>di <Plug>VimspectorBalloonEval
"
"nmap <Leader><F11> <Plug>VimspectorUpFrame
"nmap <Leader><F12> <Plug>VimspectorDownFrame
"
"nmap <M-F11> <Plug>VimspectorStepInto
"nmap <Leader><F5> <Plug>VimspectorLaunch
"
"" }}}

" {{{ vim-which-key settings
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
set timeoutlen=500
let g:which_key_map = {}
let g:which_key_map.f = { 'name' : '+fzf' }
let g:which_key_map.g = { 'name' : '+git' }
let g:which_key_map.d = { 'name' : '+dict' }
let g:which_key_map.t = { 'name' : '+floaterm' }

" }}}

" {{{ dictionary settings
""" Configuration example
" Echo translation in the cmdline
nmap <silent> <Leader>dd <Plug>Translate
vmap <silent> <Leader>dd <Plug>TranslateV
" Display translation in a window
nmap <silent> <Leader>dw <Plug>TranslateW
vmap <silent> <Leader>dw <Plug>TranslateWV
" Replace the text with translation
nmap <silent> <Leader>dr <Plug>TranslateR
vmap <silent> <Leader>dr <Plug>TranslateRV
" Translate the text in clipboard
nmap <silent> <Leader>dx <Plug>TranslateX
let g:translator_default_engines = ['youdao', 'bing', 'haici']
" }}}

" {{{ gramarous settings
nnoremap <silent> <leader>cs :set spell!<cr>
nnoremap <silent> <leader>cg :GrammarousCheck<cr>
" }}}
