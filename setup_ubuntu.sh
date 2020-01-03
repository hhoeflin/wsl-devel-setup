# install dependencies for building r from source and devtools
# also a number of other useful tools
apt-get update
apt-get --yes upgrade 
 
# install graphics and browser and editor
apt-get --yes install xorg firefox chromium-browser neovim

# nodejs support needed for neovim
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
apt-get install -y nodejs

apt-get --yes install build-essential libssl-dev libxml2-dev pandoc nautilus evince gedit\
	environment-modules libhdf5-dev qpdf emacs tcl

apt-get --yes install python-dev python-setuptools python-pip zlib1g-dev\
	libsqlite3-dev tk-dev libncursesw5-dev libgdm-dev libc6-dev python-pip\
	libffi-dev

apt-get --yes build-dep r-base python python3

