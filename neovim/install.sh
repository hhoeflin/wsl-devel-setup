# install vimplug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# copy the initialization file for neovim to its correct location
mkdir -p ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim
cp coc-settings.json ~/.config/nvim
cp plugins.lua ~/.config/nvim


# set up the powerline fonts
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

