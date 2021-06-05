colorscheme onedark
syntax on
highlight Normal ctermbg=None
filetype indent on

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
set number
set ignorecase
set smartcase
set cursorline
set hlsearch
set incsearch
set showcmd
set wildmenu
set lazyredraw
set showmatch

set foldenable
set foldlevelstart=10
set foldmethod=indent

"=============================================================================
" Key Bindings
"=============================================================================

" navigate through wrapped lines
nnoremap j gj
nnoremap k gk

" open and close folds
nnoremap <space> za
