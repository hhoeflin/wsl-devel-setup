# add source repositories as needed
mkdir temp
cp /etc/apt/sources.list ./temp/sources.list.deb_src
sed -i 's/deb /deb-src /g' temp/sources.list.deb_src
cp /etc/apt/sources.list /etc/apt/sources.list.bkp
cat ./temp/sources.list.deb_src | sudo tee -a /etc/apt/sources.list

# install dependencies for building r from source and devtools
# also a number of other useful tools
apt-get update
apt-get --yes upgrade 
apt-get --yes install build-essential
apt-get --yes build-dep r-base
apt-get --yes install libssl-dev
apt-get --yes install libxml2-dev
apt-get --yes install pandoc
apt-get --yes install nautilus
apt-get --yes install iceweasel
apt-get --yes install evince

# install dependencies for building python from source
apt-get --yes build-dep python

# also install some standard programs
apt-get --yes install gedit

# environment modules
apt-get --yes install environment-modules

###################################
# need to make additons to .bashrc
###################################

# save the old .bashrc
cp ~/.bashrc ~/.bashrc.old

# set up modules
cat add_bashrc_modules > .bashrc_temp
cat ~/.bashrc >> .bashrc_temp
mv -f .bashrc_temp ~/.bashrc

# export the display variable
echo "" >> ~/.bashrc
echo '#set DISPLAY variable for X-server' >> ~/.bashrc
echo 'export DISPLAY=:0' >> ~/.bashrc

# set up the modulerc
echo '#%Module' > ~/.modulerc
echo 'module use $HOME/modules' >> ~/.modulerc
