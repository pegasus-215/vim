"""""""""""""""""""""""""""""""""Don't put any lines in your vimrc that you don't understand."""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"
"
"所有set的设置，都可以把后面的内容通过:h name来进行查询其作用
"
"
"
""""""""""CMake and other things seem to screw up the PATH with their own msvcrXX.dll versions. Add the following to the very top of your vimrc to remove these entries from the path.""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""http://cncc.bingj.com/cache.aspx?q=r6034+an+application+has+made+an+attempt+vim+youcompleteme&d=4590548584891289&mkt=zh-CN&setlang=en-US&w=39gPIddh0dsnij6Ec_2B_L11-Llnb7fm""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
python << EOF
import os
import re
path = os.environ['PATH'].split(';')

def contains_msvcr_lib(folder):
    try:
        for item in os.listdir(folder):
            if re.match(r'msvcr\d+\.dll', item):
                return True
    except:
        pass
    return False

path = [folder for folder in path if not contains_msvcr_lib(folder)]
os.environ['PATH'] = ';'.join(path)
EOF
""""""""""""""""""""""""""""""""""""""""""""""""""""""""解决R6034完""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



""""""""""""""""""""""""""""""""""""""""""""""""""""""""原代码""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""原代码结束""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"*************************************************自己添加的第一部分开始**********************************************************
"以下部分是我自己添加的
"改变了字体大小，和背景颜色
set guifont=courier\ New:h10
colorscheme desert

" 设置编码自动识别, 中文引号显示  
set fileencodings=utf-8,cp936,big5,euc-jp,euc-kr,latin1,ucs-bom  
set fileencodings=utf-8,gbk  
set ambiwidth=double
set encoding=utf-8

"如果不添加以下两行，gvim的菜单栏会变成乱码
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

"启用鼠标，在哪种模式下可以使用鼠标，a的意思是在任何模式下都可以使用鼠标。
"set mouse=a  

"You can automatically enable syntax coloring and automatic indentation for Python code by adding the following lines to your ~/.vimrc file: 
syntax on

"自动检测文件类型并加载相应的设置
"This both turns on filetype detection and allows loading of language specific indentation files based on that detection.
filetype indent plugin on

"show the matching part of the pair for [] {} and ()
set showmatch

"It visually selects the block of characters you added last time you were in INSERT mode.
nnoremap gV `[v`] 

"\ is a little far away for a leader. I've found , to be a much better replacement.
let mapleader=","

" edit vimrc/zshrc and load vimrc bindings
nnoremap <leader>ev :vsp $MYVIMRC<CR>

"nnoremap <leader>ez :vsp ~/.zshrc<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

"按F5对程序进行调试
map <F5> :call CompilePY()<CR>
function CompilePY()
	exec "w"
	exec "!python %"
endfunction
"*************************************************自己添加的第一部分结束**********************************************************

"***************************************https://www.fullstackpython.com/vim.html**************************************************
" Enable folding
" set foldenable

" foldlevelstart is the starting fold level for opening a new buffer. If it is set to 0, all folds will be closed. Setting it to 99 would guarantee folds are always open. So, setting it to 10 here ensures that only very nested blocks of code are folded when opening a buffer.
" set foldstart = 10

" Folds can be nested. Setting a max on the number of folds guards against too many folds. If you need more than 10 fold levels you must be writing some Javascript burning in callback-hell and I feel very bad for you.
" set foldnestmax=10


set foldmethod=indent " This tells Vim to fold based on indentation. This is especially useful for me since I spend my days in Python. Other acceptable values are marker, manual, expr, syntax, diff. Run :help foldmethod to find out what each of those do.
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

"tabstop is the number of spaces a tab counts for. So, when Vim opens a file and reads a <TAB> character, it uses that many spaces to visually show the <TAB>.
"softabstop is the number of spaces a tab counts for when editing. So this value is the number of spaces that is inserted when you hit <TAB> and also the number of spaces that are removed when you backspace.
"To add the proper PEP8 indentation, add the following to your .vimrc:
"autoindent就是指下一行回车会和上一行有一样的缩进
"'autoindent' does nothing more than copy the indentation from the previous line, when starting a new line. It can be useful for structured text files, or when you want to control most of the indentation manually, without Vim interfering. 
"'smartindent' automatically inserts one extra level of indentation in some cases, and works for C-like files. 'cindent' is more customizable, but also more strict when it comes to syntax. 
"'smartindent' and 'cindent' might interfere with file type based indentation, and should never be used in conjunction with it. 
"set smartindent
"shiftwidth是在用<, >这种缩进命令时，缩进的空格数
"expandtab是把expandtab转为空格
au BufNewFile,BufRead *.py
\ set tabstop=4 |
\ set softtabstop=4 |
\ set shiftwidth=4 |
\ set textwidth=79 |
\ set expandtab |
\ set autoindent |
\ set fileformat=unix 

"And for full stack development you can use another au command for each filetype:
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 

"to avoid extraneous whitespace. We can have VIM flag that for us so that it’s easy to spot – and then remove.
"接下来这一句是在网上找到的解决办法，给"BadWhitespace先定义一下，然后才能使用。
highlight BadWhitespace ctermbg=blue guibg=gray
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/


"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

" 启用行号  
set nu 

"下面是关于vundle的配置
"如果设置为compatible，则tab将不会变成空格
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=C:\myprogram\Vim\vimfiles\bundle\Vundle.vim\
call vundle#begin('C:\myprogram\Vim\vimfiles\bundle\')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
" let Vundle manage Vundle, required
" :PluginInstall进行安装，安装好后，点'l',就会出现安装细节。
Plugin 'VundleVim/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
"Want to see the docstrings for folded code?
let g:SimpylFold_docstring_preview=1

"Autoindent will help but in some cases (like when a function signature spans multiple lines), it doesn’t always do what you want, especially when it comes to conforming to PEP8 standards. To fix that, we can use the indentpython.vim extension:k
Plugin 'vim-scripts/indentpython.vim'

Bundle 'Valloric/YouCompleteMe'
let g:ycm_autoclose_preview_window_after_completion=1
"映射YcmComplete Goto 到 d
nnoremap <S-d> : YcmCompleter GoTo<CR>

"You can have VIM check your syntax on each save with the syntastic extension:
Plugin 'scrooloose/syntastic'

"Also add PEP8 checking with this nifty little plugin:
Plugin 'nvie/vim-flake8'

"enable all Python syntax highlighting features, Finally, make your code look pretty:
let python_highlight_all=1

Plugin 'jnurmine/Zenburn'

"Plugin 'altercation/vim-colors-solarized'

"把程序中的函数做个列表
Plugin 'vim-scripts/taglist.vim'
nnoremap  <c-t> :TlistToggle<CR>

Plugin 'scrooloose/nerdtree'
"以下值为0的时候，打开vim是不会启动nerdtree的，值为1的时候，启动自动打开nerdtree
let g:nerdtree_tabs_open_on_gui_startup = 0
"用于打开和关闭NERTree
map <C-n> :NERDTreeToggle<CR>

"if you want to use tabs, utilize vim-nerdtree-tabi:
Plugin 'jistr/vim-nerdtree-tabs'
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree

"超级搜索
Plugin 'kien/ctrlp.vim'

"fugitive is a git plugin, 再看看有没有其他版本管理plugin
Plugin 'tpope/vim-fugitive'

" 状态栏
Plugin 'Lokaltog/vim-powerline'
set laststatus=2   " Always show the statusline, it only appears in the split windows

"displaying that undo tree in graphical form. Get it and don't look back. Here I've mapped it to ,u, which I like to think of as "super undo".
Plugin 'sjl/gundo.vim'
nnoremap <leader>u :GundoToggle<CR>

" Insert or delete brackets, parens, quotes in pair.
Plugin 'jiangmiao/auto-pairs'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" to check how githup respond after i type
