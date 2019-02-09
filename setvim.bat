@echo OFF
echo Start installation...
where /q git.exe
if errorlevel 1 goto GITNOTFOUND
REM -- git.exe found.
REM rename the existing vimfiles
echo "userprofile = %USERPROFILE%"
if exist "%USERPROFILE%\vimOLD" del /s /f "%USERPROFILE%\vimOLD"
if exist "%USERPROFILE%\vimfiles" move "%USERPROFILE%\vimfiles" "%USERPROFILE%\vimOLD"
REM now create directories
for %%f in (vimfiles, vimfiles\autoload, vimfiles\bundle, vimfiles\colors) do (
	mkdir "%USERPROFILE%\%%f"
)
setlocal EnableDelayedExpansion
REM -- scripts to fetch
set script[0]="https://github.com/tpope/vim-pathogen.git"
set script[1]=https://github.com/tpope/vim-surround.git
set script[2]=https://github.com/tmhedberg/matchit.git
set script[3]=https://github.com/tpope/vim-rails.git
set script[4]=https://github.com/tpope/vim-sensible.git
set script[5]=https://github.com/mattn/emmet-vim.git
set script[6]=https://github.com/xsbeats/vim-blade.git 
set script[7]=https://github.com/tpope/vim-abolish.git
set script[8]=https://github.com/tpope/vim-eunuch.git
set script[9]=https://github.com/tpope/vim-sleuth.git
set script[10]=https://github.com/tpope/vim-repeat.git
set script[11]=https://github.com/tpope/vim-vividchalk.git
set script[12]=https://github.com/tpope/vim-bundler.git
set script[13]=https://github.com/tpope/vim-fugitive.git
set script[14]=https://github.com/tpope/vim-scriptease.git
set script[15]=https://github.com/scrooloose/syntastic.git
set script[16]=https://github.com/scrooloose/nerdtree.git
set script[17]=https://github.com/tomtom/tlib_vim.git
set script[18]=https://github.com/MarcWeber/vim-addon-mw-utils.git
set script[19]=https://github.com/garbas/vim-snipmate.git
set script[20]=https://github.com/honza/vim-snippets.git
set script[21]=https://github.com/tomtom/tcomment_vim.git
set script[22]=https://github.com/ervandew/supertab.git
set script[23]=https://github.com/tomasr/molokai.git
set script[24]=https://github.com/bling/vim-airline.git
set script[25]=https://github.com/vim-scripts/Gundo.git
set script[26]=https://github.com/Lokaltog/vim-easymotion.git
set script[27]=https://github.com/vim-ruby/vim-ruby.git
set script[28]=https://github.com/ap/vim-css-color.git
set script[29]=https://github.com/kien/rainbow_parentheses.vim.git
set script[30]=https://github.com/kien/ctrlp.vim.git
set script[31]=https://github.com/terryma/vim-multiple-cursors.git
set script[32]=https://github.com/altercation/vim-colors-solarized.git
set script[33]=https://github.com/vim-erlang/vim-erlang-runtime.git
set script[34]=https://github.comvim-erlang/vim-erlang-compiler.git
set script[35]=https://github.com/vim-erlang/vim-erlang-omnicomplete.git
set script[36]=https://github.com/vim-erlang/vim-erlang-tags.git
set script[37]=https://github.com/elixir-lang/vim-elixir.git
REM -- end of list
REM
REM --- iterate through the list using FOR /L
REM
for /l %%n in (0,1,32) do (
	cd "%USERPROFILE%\vimfiles\bundle"
	git clone !script[%%n]!
)

REM -- we need to move pathogen to autoload
move "%USERPROFILE%\vimfiles\bundle\vim-pathogen\autoload\pathogen.vim" "%USERPROFILE%\vimfiles\autoload\pathogen.vim"
echo Start populating vimrc file...
echo ^" Pathogen load  >"%USERPROFILE%\vimfiles\vimrc"
echo set nocompatible  >>"%USERPROFILE%\vimfiles\vimrc"
echo filetype off  >>"%USERPROFILE%\vimfiles\vimrc"
echo call pathogen#infect()  >>"%USERPROFILE%\vimfiles\vimrc"
echo call pathogen#helptags()  >>"%USERPROFILE%\vimfiles\vimrc"
echo filetype plugin indent on  >>"%USERPROFILE%\vimfiles\vimrc"
echo syntax on  >>"%USERPROFILE%\vimfiles\vimrc"
echo set autoindent smartindent  >>"%USERPROFILE%\vimfiles\vimrc"
echo set ts=4 sts=4 sw=4  >>"%USERPROFILE%\vimfiles\vimrc"
echo nmap ^<leader^>o  :set paste!^<CR^>^<bar^>:set paste?^<CR^>  >>"%USERPROFILE%\vimfiles\vimrc"
echo set incsearch  >>"%USERPROFILE%\vimfiles\vimrc"
echo set ignorecase  >>"%USERPROFILE%\vimfiles\vimrc"
echo set hlsearch  >>"%USERPROFILE%\vimfiles\vimrc"
echo nmap ^<leader^>} :RainbowParenthesesToggle^<CR^>  >>"%USERPROFILE%\vimfiles\vimrc"
echo nmap ^<leader^>n :NERDTreeToggle^<CR^>  >>"%USERPROFILE%\vimfiles\vimrc"
echo nmap ^<leader^>z :noh^<CR^>  >>"%USERPROFILE%\vimfiles\vimrc"
echo set nu  >>"%USERPROFILE%\vimfiles\vimrc"
echo if has("gui_running")   >>"%USERPROFILE%\vimfiles\vimrc"
echo    set lines=35 columns=90  >>"%USERPROFILE%\vimfiles\vimrc"
echo    set guioptions-=T  >>"%USERPROFILE%\vimfiles\vimrc"
echo end  >>"%USERPROFILE%\vimfiles\vimrc"
echo colorscheme vividchalk  >>"%USERPROFILE%\vimfiles\vimrc"
copy "%USERPROFILE%\vimfiles\vimrc" "%USERPROFILE%\.vimrc" 
goto end
:GITNOTFOUND
echo 'GIT is needed, please install and start the script again!'
open http://git-scm.com/download/win
:end
