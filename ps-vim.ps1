Write-Output "Start installation..."
Write-Output "Checking if git is installed..."
$gitLoc  "None"
$gitLoc  Get-Command git.exe -errorAction SilentlyContinue
if ($gitLoc -Like "None") {
	Write-Output "Could not find 'git' command! Exit."
	Exit 99
}
Write-Output "Now checking if there is an existing vimOLD file in USERPROFILE..."
$uprofile  $env:USERPROFILE
$vimOld  "$uprofile/vimOLD"
if (Test-Path -Path $vimOld) {
	Write-Output "$vimOld exists. Deleting existing $vimOld..."
	Remove-Item -Path "$vimOld" -Force -Recurse
}
Write-Output "Checking if there is the 'vimfiles' exist?"
$vimFiles  "$uprofile/vimfiles"
# 
# rename the existing vimfiles to vimOLD
# 
if (Test-Path -Path $vimFiles) {
	Rename-Item -Path "$vimFiles" -NewName "$vimOld"
}

$listOfSubdirs  @("vimfiles", "vimfiles/autoload", "vimfiles/bundle", "vimfiles/colors")

foreach ($onesubdir in $listOfSubdirs) {
	New-Item -ItemType Directory -Path "$uprofile" -Name $onesubdir
} 

$scriptsList = @(
	"https://github.com/tpope/vim-pathogen.git",
	"https://github.com/tpope/vim-surround.git",
	"https://github.com/tmhedberg/matchit.git",
	"https://github.com/tpope/vim-rails.git",
	"https://github.com/tpope/vim-sensible.git",
	"https://github.com/mattn/emmet-vim.git",
	"https://github.com/xsbeats/vim-blade.git", 
	"https://github.com/tpope/vim-abolish.git",
	"https://github.com/tpope/vim-eunuch.git",
	"https://github.com/tpope/vim-sleuth.git",
	"https://github.com/tpope/vim-repeat.git",
	"https://github.com/tpope/vim-vividchalk.git",
	"https://github.com/tpope/vim-bundler.git",
	"https://github.com/tpope/vim-fugitive.git",
	"https://github.com/tpope/vim-scriptease.git",
	"https://github.com/scrooloose/syntastic.git",
	"https://github.com/scrooloose/nerdtree.git",
	"https://github.com/tomtom/tlib_vim.git",
	"https://github.com/MarcWeber/vim-addon-mw-utils.git",
	"https://github.com/garbas/vim-snipmate.git",
	"https://github.com/honza/vim-snippets.git",
	"https://github.com/tomtom/tcomment_vim.git",
	"https://github.com/ervandew/supertab.git",
	"https://github.com/tomasr/molokai.git",
	"https://github.com/bling/vim-airline.git",
	"https://github.com/vim-scripts/Gundo.git",
	"https://github.com/Lokaltog/vim-easymotion.git",
	"https://github.com/vim-ruby/vim-ruby.git",
	"https://github.com/ap/vim-css-color.git",
	"https://github.com/kien/rainbow_parentheses.vim.git",
	"https://github.com/kien/ctrlp.vim.git",
	"https://github.com/terryma/vim-multiple-cursors.git",
	"https://github.com/altercation/vim-colors-solarized.git",
	"https://github.com/vim-erlang/vim-erlang-runtime.git",
	"https://github.comvim-erlang/vim-erlang-compiler.git",
	"https://github.com/vim-erlang/vim-erlang-omnicomplete.git",
	"https://github.com/vim-erlang/vim-erlang-tags.git",
	"https://github.com/elixir-lang/vim-elixir.git"
)

# --- iterate through the list using FOR /L
Push-Location -Path "$vimFiles/bundle"

foreach ($scriptFile in $scriptsList) {
	git clone $scriptFile
}

# restore current directory
Pop-Location

# -- Move/copy pathogen to autoload
Move-Item -Path "$vimFiles/bundle/vim-pathogen/autoload/pathogen.vim" `
			-Destination "$vimFiles/autoload/pathogen.vim"

Write-Output "Start populating vimrc file... "

$vimRcContent = @"
set nocompatible  
filetype off  
call pathogen#infect()  
call pathogen#helptags()  
filetype plugin indent on  
syntax on  
set autoindent smartindent  
set ts4 sts4 sw4  
nmap ^<leader^o  :set paste!^<CR^^<bar^:set paste?^<CR^  
set incsearch  
set ignorecase  
set hlsearch  
nmap ^<leader^} :RainbowParenthesesToggle^<CR^  
nmap ^<leader^n :NERDTreeToggle^<CR^  
nmap ^<leader^z :noh^<CR^  
set nu  
if has("gui_running")   
   set lines35 columns90  
   set guioptions-T  
end  
colorscheme vividchalk  
"@

Set-Content  -Path "$uprofile/_vimrc" -Value $vimRcContent 
Write-Output "Done. Init file: $uprofile/_vimrc, directory: $vimFiles"