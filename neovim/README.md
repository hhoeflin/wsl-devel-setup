# Instructions for setting up neovim

## Intro
All individual steps are detailed below. The code exection steps are also all 
available in the script 'install.sh' in this directory.

Note: Some steps regarding plugin installation need to be performed manually. 

## Prerequisites
In order for neovim to work correctly also with the plugins, 
- git
- nodejs
need to be installed and available on the PATH.

## Setting up the plug-in system
The page for the plugin can be found at https://github.com/junegunn/vim-plug.

For Unix, the instructions there state to 
```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Nvim initialization and other settings files
The nvim initialization file needs to be copied to its correct location. The same is the
case for the settings file for 'coc-nvim' as well as 'iron.nvim'.
```bash
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim
cp coc-settings.json ~/.config/nvim
cp plugins.lua ~/.config/nvim
cp flake8 ~/.config/flake8
cp .tmux.conf ~
```

## Powerline fonts
In order for powerline to display correctly, some additional fonts need to
be installed. The fonts come from https://github.com/powerline/fonts.


### Unix
For unix the instructions are:
```bash
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
```

### Windows
When using a terminal from  windows, we also need to install all (or at least
some of the fonts. For windows, instructions can be found at 
https://medium.com/@slmeng/how-to-install-powerline-fonts-in-windows-b2eedecace58.

In these instructions, it is advised to run a powershell script. Due to lacking 
administrator permissions, this may not be possible. In this case, just go into
a few individual subdirectories and install a font you may like (the ttf file).

## All platforms

Afterwards, depending on the terminal used, it may be necessary to set one of the 
powerline enabled fonts in the console. 

## Plugin Installation
In order to install all plugins, please open nvim and type
```
:PlugInstall
```
This triggers vim-plug to download all plugins from github and install them correctly. 

For nvim-coc, we then also need to install 'coc-python', which is done by 
```
:CocInstall coc-python
```
Also very useful is potentially the json extension which can be included using
```
:CocInstall coc-json
```


For further instructions please see the websites
- https://github.com/neoclide/coc-python
- https://github.com/neoclide/coc.nvim

## Note on TMUX
When using tmux and vim, it is possible that the screen colors do not
appear to look very well. In order for it to work  it is necessary to 
call tmux with the '-2' option to force it to set 256 colors.

Additionally, in the .tmux.conf settings
- the status bar has been turned off
- the tmux wait time for an ESC key has been shortened as this slowed down nvim.

## Python
Please note that in a python environment, the following packages should be installed for 
the configuration to work:
- pynvim
- jedi
- flake8
- black
