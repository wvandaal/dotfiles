set nocompatible					" required for vundle
filetype off  						" required for vundle

" add vundle to rtp
let &rtp .= ", " . $DOTDIR . "/vim/bundle/vundle, " . &rtp 

" install plugins
call vundle#begin($DOTDIR . "/vim/bundle")

" Bundle up the various packages
Plugin 'gmarik/vundle'

" improved js highlighting and other options	
Plugin 'pangloss/vim-javascript'

" molokai color scheme
Plugin 'tomasr/molokai'

" easymotion pattern matching
Plugin 'Lokaltog/vim-easymotion'

" directory tree traversal
Plugin 'scrooloose/nerdtree'		

" finish installing plugins	
call vundle#end()      				" required for vundle
filetype plugin indent on 			" required for vundle

 
inoremap ii <ESC>					" map ii to ESC
syntax on							" syntax highlighting
set encoding=utf-8					" char encoding
set mouse=a 						" allow input with mouse
set nu								" line numbers

" Set 80 col ruler 
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

"  Colorscheme Options  "
"""""""""""""""""""""""""
syntax enable						" enable complex color schemes
colorscheme molokai					" set molokai color scheme
let g:rehash256 = 1					" molokai 256 colors


"  Easymotion Settings  "
"""""""""""""""""""""""""
" map <Leader> <Plug>(easymotion-prefix)
map  // <Plug>(easymotion-sn)
omap // <Plug>(easymotion-tn)
let g:EasyMotion_smartcase = 1

"   NERDTree Settings   "
"""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR> 		" map NERDTree to ctrl-n

" open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" allow closing vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif