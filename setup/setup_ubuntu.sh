# add source repositories as needed
mkdir temp
sudo cp /etc/apt/sources.list ./temp/sources.list.deb_src
sudo sed -i 's/deb /deb-src /g' temp/sources.list.deb_src
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bkp
sudo cat ./temp/sources.list.deb_src | sudo tee -a /etc/apt/sources.list

# install dependencies for building r from source and devtools
# also a number of other useful tools
sudo apt-get update
sudo apt-get --yes upgrade 
sudo apt-get --yes install build-essential libssl-dev libxml2-dev pandoc nautilus iceweasel evince gedit environment-modules libhdf5-dev qpdf emacs tcl

sudo apt-get --yes install python-dev python-setuptools python-pip python-smbus zlib1g-dev libsqlite3-dev tk-dev libncursesw5-dev libgdm-dev libc6-dev python-pip\
	libffi-dev
sudo apt-get --yes build-dep r-base python python3


###################################
# need to make additons to .bashrc
###################################

# save the old .bashrc
cp ~/.bashrc ~/.bashrc.old

# set up modules
if !(grep -q "^module().*" ~/.bashrc) then
  cat add_bashrc_modules > .bashrc_temp
  cat ~/.bashrc >> .bashrc_temp
  mv -f .bashrc_temp ~/.bashrc
  # set up use of modulerc 
  echo '#%Module' > ~/.modulerc
  echo 'module use $HOME/modules' >> ~/.modulerc
  mkdir -p $HOME/modules
fi

if !(grep -q "^module use \\$HOME/modules.*" ~/.bashrc) then
  echo '#%Module' > ~/.modulerc
  echo 'module use '$HOME'/modules' >> ~/.modulerc
  mkdir -p $HOME/modules
fi

# export the display variable
if !(grep -q "^export DISPLAY.*" ~/.bashrc) then
  echo "" >> ~/.bashrc
  echo '#set DISPLAY variable for X-server' >> ~/.bashrc
  echo 'export DISPLAY=:0' >> ~/.bashrc
fi
