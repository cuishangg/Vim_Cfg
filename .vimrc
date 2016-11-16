" An example for a vimrc file.
"
" Maintainer:    Bram Moolenaar <Bram@vim.org>
" Last change:    2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"          for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"        for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup        " do not keep a backup file, use versions instead
else
  set backup        " keep a backup file
endif
set history=100        " keep 50 lines of command line history
set ruler        " show the cursor position all the time
set showcmd        " display incomplete commands
set incsearch        " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else
  set autoindent        " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

" Custom setting
set nu
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set whichwrap+=<,>,h,l
set splitright

" Set to auto read when a file is changed from the outside
set autoread

" Set mapleader
let mapleader = ","

" Fast editing of .vimrc
map <silent> <leader>ss :source ~/.vimrc<cr>
" Fast editing of .vimrc
map <silent> <leader>ee :e ~/.vimrc<cr>
" When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Fast saving
nmap <leader>w :w!<cr>
" Fast quit
nmap <leader>q :qa<cr>

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turn backup off,since most stuff is in SVN,git et.c anyway...
set nobackup
set nowb
set noswapfile

" Treat long lines as bread lines(useful when moving around in them)
map j gj
map k gk

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" auto change working dir
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif

" pathogen configuration
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
Helptags

" ctrlp.vim setting
set runtimepath^=~/.vim/bundle/ctrlp.vim

" colorscheme solarized
let g:solarized_termcolors=256
set background=light
colorscheme solarized

" ctrl c and v to clipboard
vmap <C-c> "+y
nmap <C-a> ggVG
nmap <C-v> "+p
nmap <leader>bn :bn<cr>
nmap <leader>bp :bp<cr>

" set lines and columns
set lines=50 columns=100

" set nerdtree mapping
" map <F3> :NERDTreeMirror<cr>
map <F3> :NERDTreeToggle<cr>
map <F4> :NERDTreeToggle<cr>:NERDTreeCWD<cr>

" set transparent, defaut is transparent
hi Normal ctermfg=255 ctermbg=none
hi LineNr ctermfg=255 ctermbg=none
let g:btransparent=1

map <leader>l :bro ol<cr>

" set fdm=indent
set fdm=indent
set autowrite

" set tagbar mapping key
nmap <F8> :TagbarToggle<CR>

" map tab
nmap tn :tabn<cr>
nmap tp :tabp<cr>

" set airline to use powerline fonts
let g:airline_powerline_fonts = 1
let g:airline_theme='cool'

" set encoding=utf-8 fileencodings=ucs-bom,utf-8,cp936

" set customize highlight color
hi CursorLine ctermbg=240 ctermfg=230

" comment and uncomment
function! Docomment(comment)
    let lnum = line('.')
    let str_line = getline('.')
    let comm_ident = "\/\/"
    let syntax_type = &syntax
    if syntax_type == "vim"
        let comm_ident = "\""
    elseif syntax_type == "cpp" || syntax_type == "c" || syntax_type == "java"
        let comm_ident = "\/\/"
    elseif syntax_type == "sh" || syntax_type == "rc"
        let comm_ident = "#"
    endif

    if a:comment
        let str_line = substitute(str_line, "\\(\\S.*$\\)", comm_ident . " \\1", "")
        call setline(lnum, str_line)
    else
        let str_line = substitute(str_line, "\\(^\\s*\\)" . comm_ident ." \\?", "\\1", "")
        call setline(lnum, str_line)
    endif
endfunction

nmap <leader>c :call Docomment(1)<CR>
nmap <leader>x :call Docomment(0)<CR>

" for easy using sliver search
nmap <leader>f :norm yiw<CR>:Ag! -t -Q --hidden "<C-R>""

" Locate and return character "above" current cursor position.
function! LookUpwards()
    let column_num = virtcol('.')
    let target_pattern = '\%' . column_num . 'v.'
    let target_line_num = search(target_pattern . '*\S', 'bnW')

    if !target_line_num
        return ""
    else
        return matchstr(getline(target_line_num), target_pattern)
    endif
endfunction

imap <silent> <C-Y> <C-R><C-R>=LookUpwards()<CR>
