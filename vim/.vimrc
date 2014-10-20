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
call vundle#end()      				
filetype plugin indent on 			" required for vundle

 
inoremap ii <ESC>					" map ii to ESC
syntax on							" syntax highlighting
set encoding=utf-8					" char encoding
set mouse+=a 						" allow input with mouse
set nu								" line numbers

" Set 80 col ruler 
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif


"  Status Line Options  "
"""""""""""""""""""""""""
set laststatus=2
set statusline=%4*\ %<%F%*              " full path
set statusline +=%2*%m%*                " modified flag
set statusline +=%1*%=%5l%*             " current line
set statusline +=%2*/%L%*               " total lines
set statusline +=%1*%4v\ %*             " virtual column number
hi StatusLine ctermbg=yellow


"  Colorscheme Options  "
"""""""""""""""""""""""""
set t_Co=256						" set vim to 256 colors
" molokai 256 colors, should come before color scheme declaration
let g:rehash256 = 1					
syntax enable						" enable complex color schemes
colorscheme molokai					" set molokai color scheme


"  Easymotion Settings  "
"""""""""""""""""""""""""
" map <Leader> <Plug>(easymotion-prefix)
map  // <Plug>(easymotion-sn)
omap // <Plug>(easymotion-tn)
let g:EasyMotion_smartcase = 1


"   NERDTree Settings   "
"""""""""""""""""""""""""
map <C-n> :NERDTreeToggle<CR> 		" map NERDTree to ctrl-n

" allow closing vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif