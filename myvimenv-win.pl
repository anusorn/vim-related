#!/usr/bin/env perl
#
use File::Copy;
use Env qw/USERPROFILE PATH/;
# for Window - %USERPROFILE% shows \Users\username

my $homedir = "$USERPROFILE";
# print "HOMEDIR = " . $homedir ."\n";
my $git = `where git | wc -l`;
if ($git =~ "0") {
	print "Need to install GIT first!\n";
    exit 1;
}
# we will start with working directly with MSWIN32
@dirs = ("vimfiles", "vimfiles/autoload", "vimfiles/bundle", "vimfiles/colors");

# should it be $maindir = $homedir . '/' . "vimfiles";
my $main_dir = "vimfiles";
my $vimrc = "$main_dir/vimrc";

my $gitlist = {
	"autoload/pathogen_folder" => 'https://github.com/tpope/vim-pathogen.git',
	"bundle/surround" => 'https://github.com/tpope/vim-surround.git',
	"bundle/vim-matchit" => 'https://github.com/tmhedberg/matchit.git',
	"bundle/vim-rails" => 'https://github.com/tpope/vim-rails.git',
	"bundle/vim-sensible" => 'https://github.com/tpope/vim-sensible.git',
	"bundle/vim-eunuch" => 'https://github.com/tpope/vim-eunuch.git',
	"bundle/vim-sleuth" => 'https://github.com/tpope/vim-sleuth.git',
	"bundle/vim-repeat" => 'https://github.com/tpope/vim-repeat.git',
	"bundle/vim-vividchalk" => 'https://github.com/tpope/vim-vividchalk.git',
	"bundle/vim-bundler" => 'https://github.com/tpope/vim-bundler.git',
	"bundle/vim-abolish" => 'https://github.com/tpope/vim-abolish.git',
	"bundle/vim-fugitive" => 'https://github.com/tpope/vim-fugitive.git',
	"bundle/vim-scriptease" => 'https://github.com/tpope/vim-scriptease.git',
	"bundle/vim-nerdtree" => 'https://github.com/scrooloose/nerdtree.git',
	"bundle/vim-syntastic" => 'https://github.com/scrooloose/syntastic.git',
	"bundle/vim-tlib" => 'https://github.com/tomtom/tlib_vim.git',
	"bundle/vim-mw-utils" => 'https://github.com/MarcWeber/vim-addon-mw-utils.git',
	"bundle/vim-snipmate" => 'https://github.com/garbas/vim-snipmate.git',
	"bundle/vim-snippets" => 'https://github.com/honza/vim-snippets.git',
	"bundle/vim-tcomments" => 'https://github.com/tomtom/tcomment_vim.git',
	"bundle/vim-supertab" => 'https://github.com/ervandew/supertab.git',
	"bundle/vim-molokai" => 'https://github.com/tomasr/molokai.git',
	"bundle/vim-airline" => 'https://github.com/bling/vim-airline.git',
	"bundle/vim-gundo" => 'https://github.com/vim-scripts/Gundo.git',
	"bundle/vim-easymotion" => 'https://github.com/Lokaltog/vim-easymotion.git',
	"bundle/vim-ruby" => 'https://github.com/vim-ruby/vim-ruby.git',
	"bundle/vim-css-color" => 'https://github.com/ap/vim-css-color.git',
	"bundle/vim-rainbow-parens" => 'https://github.com/kien/rainbow_parentheses.vim.git',
	"bundle/vim-ctrlP" => 'https://github.com/kien/ctrlp.vim.git',
	"bundle/vim-blade" => 'https://github.com/xsbeats/vim-blade.git',
	"bundle/vim-go" =>  'https://github.com/fatih/vim-go.git',
    	"bundle/vim-erlang-runtime" => 'https://github.com/vim-erlang/vim-erlang-runtime.git',
    	"bundle/vim-erlang-compiler" => 'https://github.comvim-erlang/vim-erlang-compiler.git',
    	"bundle/vim-erlang-omnicomplete" => 'https://github.com/vim-erlang/vim-erlang-omnicomplete.git',
    	"bundle/vim-erlang-tags" => 'https://github.com/vim-erlang/vim-erlang-tags.git',
    	"bundle/vim-elixir" => 'https://github.com/elixir-lang/vim-elixir.git',
	"bundle/vim-multiple-cursors" => 'https://github.com/terryma/vim-multiple-cursors.git',
	"bundle/vim-colors-solarized" => 'https://github.com/altercation/vim-colors-solarized.git',
};

# we need to be at the $homedir
# NOTE::
#   We mapped $homedir to either $HOME for unix or %USERPROFILE% for Windows

chdir "$homedir";
foreach my $dir (@dirs) {
	if ( not (-d $dir)) {
		print "Directory $dir not available\n";
		mkdir $dir;
	}
}

chdir "$main_dir";
foreach my $git (keys %{ $gitlist}) {
	print "Retrieving $git --> ", $gitlist->{$git}, "\n";
	`git clone $gitlist->{$git}  $git`;
}
# Now we need to move pathogen.vim 
copy("$homedir/$main_dir/autoload/pathogen_folder/autoload/pathogen.vim",
		"$homedir/$main_dir/autoload/pathogen.vim") or die "Could not copy!";
# unlink -rf $homedir/$main_dir/autoload/pathogen_folder;

my @vimrc = (
	'" Pathogen load',
	'set nocompatible',
	'filetype off',
	'call pathogen#infect()',
	'call pathogen#helptags()',
	'filetype plugin indent on',
	'syntax on',
	'set autoindent smartindent',
	'set ts=4 sts=4 sw=4',
	'nmap <leader>o  :set paste!<CR><bar>:set paste?<CR>',
	'set incsearch',
	'set ignorecase',
	'set hlsearch',
	'nmap <leader>} :RainbowParenthesesToggle<CR>',
    'nmap <leader>n :NERDTreeToggle<CR>',
	'nmap <leader>z :noh<CR>',
	'set nu',
	'if has("gui_running") ',
	'   set lines=35 columns=90',
	'   set guioptions-=T',
	'end',
	'colorscheme vividchalk',
);

# we need to rename file
if ( -e "$homedir/_vimrc" ) {
	rename "$homedir/_vimrc", "$homedir/xxxxxxxxxx_vimrc";
}
my $oldold = "$homedir/$vimrc.oldold";
my $file_vimrc = "$homedir/$vimrc";
if ( -e $file_vimrc ) {
	if (-e $oldold) {
		unlink $oldold;
	}
	rename $file_vimrc,$oldold;
}
open(VIMRC, "> $file_vimrc");
foreach my $line (@vimrc) {
	print VIMRC $line . "\n";
}
if (-e $oldold) {
	open(OLDVIMRC, "< $oldold");
	while (<OLDVIMRC>) {
		print VIMRC $_;
	}
	close (OLDVIMRC);
}
close(VIMRC);

print "Done!!";
