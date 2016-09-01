if v:progname =~? "evim"
	finish
endif

set nocompatible

set backspace=indent,eol,start

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nohlsearch
set number
set visualbell
set ignorecase smartcase
set guioptions=aegtc
" set guioptions=egmrLt
" " a -> visual yank into clipboard
" " A -> a in modeless only
" " c -> console dialogs
" " e -> tabs
" " f -> wait
" " i -> icon
" " m -> menu bar
set clipboard=unnamed

" Don't use Ex mode, use Q for formatting
map Q gq

set mouse=a

map <leader>t :FuzzyFinderTextMate<CR>

set wildmode=list:longest

map <c-j> <c-w>j<c-w>_
map <c-k> <c-w>k<c-w>_
set wmh=0

"This allows for change paste motion cp{motion}
vnoremap <silent> cp "_dp
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
	silent exe "normal! `[v`]\"_d"
	silent exe "normal! P"
endfunction

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
syntax on


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
		autocmd BufReadPost *
					\ if line("'\"") > 0 && line("'\"") <= line("$") |
					\   exe "normal! g`\"" |
					\ endif

	augroup END

else

	set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
			\ | wincmd p | diffthis

if has("gui_running")
	set transp=0
	set gfn=Source\ Code\ Pro:h10
	set background=dark
	let psc_style='warm'
	colo ps_color
else
	set term=linux
	set t_Co=256
	set background=dark
	colo peaksea
end

""""""""""""""

set splitright "Vertical split by default (hopefully)
set hidden "Hide rather than close buffers
set tabstop=4
set shiftwidth=4
set guioptions-=T
cnoremap vh vert h
cnoremap vsb vert sb
runtime! ftplugin/man.vim

"""""""""""""

let g:netrw_keepdir=1

inoremap <F2> <ESC><C-w>o:Ve %:h<CR>:vertical resize 30<CR>li
noremap <F2> <C-w>o:Ve<CR>:vertical resize 30<CR>
noremap <F3> :TlistOpen<CR>
noremap <F5> :BufExplorer<CR>

inoremap jj <ESC>

noremap <F6> :tabnew ~/.vimrc<CR>
noremap <F4> :TlistClose<CR>

nnoremap <D-Enter> o<ESC> 

inoremap <C-x><C-v> <ESC><C-w>g}li
noremap  <C-x><C-v> <C-w>g}

noremap  <C-x><C-e> :exe getline(".")<CR>
inoremap <C-x><C-e> <ESC>:exe getline(".")<CR>li
noremap  <C-x><C-r> <C-w>t<C-w>H

inoremap <C-x><C-h> <ESC>\lwli
noremap clw c/[_A-Z]\\|\W<CR>

"" FuzzyFinder

let g:fuf_modesDisable = []
let g:fuf_abbrevMap = {
	\   '^vr:' : map(filter(split(&runtimepath, ','), 'v:val !~ "after$"'), 'v:val . ''/**/'''),
	\   '^m0:' : [ '/mnt/d/0/', '/mnt/j/0/' ],
	\ }
let g:fuf_mrufile_maxItem = 300
let g:fuf_mrucmd_maxItem = 400
nnoremap <silent> <C-x><C-b>      :FufBuffer<CR>
"nnoremap <silent> <C-p>      :FufFileWithCurrentBufferDir<CR>
"nnoremap <silent> <C-f><C-p> :FufFileWithFullCwd<CR>
"nnoremap <silent> <C-f>p     :FufFile<CR>
"nnoremap <silent> <C-f><C-d> :FufDirWithCurrentBufferDir<CR>
"nnoremap <silent> <C-f>d     :FufDirWithFullCwd<CR>
"nnoremap <silent> <C-f>D     :FufDir<CR>
nnoremap <silent> <C-x><C-h>      :FufMruFile<CR>
nnoremap <silent> <C-x><C-c>      :FufMruCmd<CR>
nnoremap <silent> <C-x><C-m>      :FufBookmark<CR>
nnoremap <silent> <C-x><C-]> :FufTag<CR>
"nnoremap <silent> <C-f>t     :FufTag!<CR>
noremap  <silent> g]         :FufTagWithCursorWord!<CR>
nnoremap <silent> <C-x><C-f> :FufTaggedFile<CR>
nnoremap <silent> <C-x><C-j> :FufJumpList<CR>
nnoremap <silent> <C-x><C-g> :FufChangeList<CR>
nnoremap <silent> <C-x><C-q> :FufQuickfix<CR>
nnoremap <silent> <C-x><C-a> :FufAddBookmark<CR>
"vnoremap <silent> <C-f><C-b> :FufAddBookmarkAsSelectedText<CR>
"nnoremap <silent> <C-f><C-e> :FufEditInfo<CR>
"nnoremap <silent> <C-f><C-r> :FufRenewCache<CR>
nnoremap <silent> <C-x><C-i> :FufFunction<CR>
nnoremap <silent> <LocalLeader>t :call FufAllFiles()<CR>


noremap <D-P> :FuzzyFinderTag<CR>
noremap <Leader>s :Scratch<CR>isnap

""""""""""""""""

set nobackup
set nowrap

let Tlist_Show_One_File = 1
let Tlist_Close_On_Select = 1
let Tlist_File_Fold_Auto_Close = 1

augroup AllListed
	au BufRead * set bufhidden=hide | set buflisted
augroup END

"""" VimClojure """"
set rtp+=~/.vim/vimclojure-2.1.2
let clj_want_gorilla = 1

let clj_highlight_builtins = 1
let clj_highlight_contrib  = 1
let clj_paren_rainbow      = 1

" command! StartNg !java -cp /Users/selah/clojure/clojure.jar:/Users/selah/clojure-contrib/clojure-contrib.jar:/Users/selah/.vim/bin/vimclojure.jar com.martiansoftware.nailgun.NGServer 127.0.0.1 &
" command! StopNg !ng ng-stop

command! Tag !ctags --excmd=pattern --PHP-kinds=+cfi-v --regex-PHP='/abstract class ([^ ]*)//c/' --regex-PHP='/interface ([^ ]*)//c/' --regex-PHP='/(public |static |abstract |protected |private )+function ([^ (]*)/ /f/' --JavaScript-kinds=+cf --regex-JavaScript='/(w+) ?: ?function//f/' -R --exclude='.git' --exclude='.svn' --exclude='.cvs' --tag-relative=yes --fields=Kn
command! ReloadSnippets runtime! ~/.vim/after/ftplugin/**/*.vim<CR>
command! ReloadPlugins runtime! ~/.vim/plugin/**/*.vim<CR>

" let g:Tlist_Ctags_Cmd = "ctags --excmd=pattern --PHP-kinds=+cfi-v --regex-PHP='/abstract class ([^ ]*)//c/' --regex-PHP='/interface ([^ ]*)//c/' --regex-PHP='/(public |static |abstract |protected |private )+function ([^ (]*)/ /f/' --JavaScript-kinds=+cf --regex-JavaScript='/(w+) ?: ?function//f/' -R --exclude='.git' --exclude='.svn' --exclude='.cvs' --tag-relative=yes --fields=Kn"
"
"let processing_doc_path="/Applications/Processing.app:/"
