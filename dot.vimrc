" .vimrc
" $Id: dot.vimrc,v 1.19 2009-02-02 11:27:07 mml Exp $

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set exrc                " load local .exrc or .vimrc files

" things we could add to this
"   \" for register saving
"   % save/restore buffer list
set viminfo='50,f1,r/mnt/cdrom,r/mnt/floppy

set backspace=2         " allow backspacing over everything in insert mode
set autoindent          " copy indent level from current line to next new line
set showmatch           " blink matching parens
set textwidth=80        " size of most people's screens

set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

set hidden              " allow hidden buffers -- a little dangerous

set ruler               " always show cursor position
set laststatus=2        " always show a status line

set cpoptions-=s        " Set buffer options only when buffer first created; not
                        " when I firt enter it.
set formatoptions-=t    " DON'T Auto-wrap text using textwidth
set formatoptions+=r    " Automatically insert the current comment leader after
                        " hitting <return> in insert mode.
set formatoptions+=o    " Automatically insert the current comment leader after
                        " hitting 'o' or 'O' in Normal mode.
set formatoptions+=l    " Long lines are not broken in insert mode: When a line
                        " was longer than 'textwidth' when the insert command
                        " started, Vim does not automatically format it.

set wildmode=list:longest,full

" Where to search for files (e.g. using gf or ^Wf).
set path=.,/usr/local/include,/usr/include,/usr/X11R6/include

" Keyword completion (^P/^N)
set complete=.,b,u,w,t,i,d

" Auto indenting and outdenting based on {}, etc.
set smartindent

" Incremental searches are handy.
set incsearch

" Don't use Ex mode; use Q for formatting
map Q gq

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" wrap a word in an SGML tag
map ,b   dbr<pa>wwhi</pa>bbb

" insert the date
map ,d :.!date +\%Y\%m\%d' '\%H\%M\%S<CR>A -- 

" muscle memory from Socialtext
map <f1> :w<CR>
imap <f1> <esc><f1>
map + <C-^>

" this one's giving me trouble
" map ,bb  bhdbr<pa>wwhi</pa>l
" close an SGML tag
imap </>  0ma?>^My?<^M`apmb`axa/`ba>

" ^O in command mode moves left a WORD; this is most useful for ^W^E below
cnoremap  <C-Left>

" ^W^E in visual mode is like ^W^], but lets you edit before comitting (e.g. to
" place a class name in front of a method name)
nmap <C-W><C-E> "zyw:sta <C-R>z<C-O>

" Fixed delete/backspace stupidity.
noremap ^? ^H

" Unhighlight on ^L.
noremap <C-l> :noh<CR><C-l>

" Magicify the tab key.  Sometimes it tab completes; sometimes it indents.
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

" This forces all xterms to be color xterms.  Handy when the local tercmap has
" no xterm-color entry (bogus) but you're always connecting from something like
" PuTTY anyhow.
if &term =~ "xterm"
    set t_Co=8
    if has("terminfo")
        set t_Sf=[3%p1%dm
        set t_Sb=[4%p1%dm
    else
        set t_Sf=[3%dm
        set t_Sb=[4%dm
    endif
endif

if has("gui_macvim")
    set fuoptions+=maxhorz
elseif has("gui")
    set guifont=smooth
    highlight Normal guibg=black guifg=white
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    augroup mmlVimrc
        autocmd!

        " Moved from filetype.vim while at Socialtext.
        autocmd BufRead,BufNewFile *.txt        setf plaintext

        autocmd FileType perl,php3 setlocal cindent cinkeys-=0# comments=:#
        autocmd FileType perl setlocal isfname-=-
        autocmd FileType vim setlocal comments=:\"
        autocmd FileType mail set textwidth=70 shiftwidth=2 softtabstop=2 formatoptions-=or formatoptions-=r formatoptions+=tn
        autocmd FileType mail nmap <buffer> <F3> d/^--<SPACE><CR>:nohlsearch<CR>

        " We want nice word wrap in our commit messages.
        autocmd FileType cvs set formatoptions+=t
        autocmd FileType svn set formatoptions+=t
        autocmd FileType svk set formatoptions+=t
    augroup END
endif

filetype plugin indent on

" If we have colour, turn on syntax highlighting and search highlighting.
if (&t_Co > 1) || has("gui_running")
    set background=dark
    syntax on
    set hlsearch
endif

" Maximize window on startup on Windows.
if has("gui_running") && has("win32")
    autocmd GUIEnter * simalt ~x
endif

" Load local settings last
let FILE=expand('~/.vimrc.local')
if filereadable(FILE)
    " We must quote the spaces before handing the filename of to source
    let FILE=fnamemodify(FILE, ":gs/ /\\\\ /")
    exe 'source ' . FILE
endif
