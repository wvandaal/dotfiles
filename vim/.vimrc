set nocompatible					" required for vundle
filetype off  						" required for vundle

" add vundle and fzf to rtp
let &rtp .= ", " . $DOTDIR . "/vim/bundle/vundle, " . &rtp
let &rtp .= $DOTDIR . "/zsh/fzf" 

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

" git command support
Plugin 'tpope/vim-fugitive'

" git diff signs in gutter
Plugin 'airblade/vim-gitgutter'

" descriptive status line
Plugin 'Lokaltog/vim-powerline'

" highlight hex color-codes in the color they represent
Plugin 'ap/vim-css-color'

" Allow for tab completion in insert mode
Plugin 'ervandew/supertab'

" Sublime text snippets
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'

" multiple cursors like those in Sublime Text
Plugin 'terryma/vim-multiple-cursors'

" finish installing plugins	
call vundle#end()      				
filetype plugin indent on 			" required for vundle

 
inoremap ii <ESC>					" map ii to ESC
nnoremap <CR> :nohlsearch<CR><CR> 			" toggle off search highlighting with 'Enter' 

syntax on						" syntax highlighting
set encoding=utf-8					" char encoding
set mouse+=a 						" allow input with mouse
set nu							" line numbers
set laststatus=2 					" keep status line visible always
set hlsearch 						" turn on search highlighting

" auto-indent braces and set tab width to 4 spaces
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab


" Set 80 col ruler 
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif


"   Supertab Options    "
"""""""""""""""""""""""""
set completeopt=longest,menuone


"  Colorscheme Options  "
"""""""""""""""""""""""""
" set vim to 256 colors
if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
  set t_Co=256 						
endif				

" molokai 256 colors, should come before colorscheme declaration
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
