.PHONY: install all

all: ~/modules/emacs/24.5 ~/.emacs.d/elpa 

emacs-24.5.tar.xz:
	wget https://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.xz

emacs-24.5: emacs-24.5.tar.xz
	apt-get --yes install libxaw7-dev libncurses5-dev
	apt-get --yes install libjpeg-dev libpng-dev libtiff-dev libgif-dev
	tar kxvf emacs-24.5.tar.xz

${EMACS_INSTALL_DIR}/bin/emacs: emacs-24.5
	cd emacs-24.5; \
	mkdir -p ${EMACS_INSTALL_DIR};\
	./configure --without-dbus --without-gconf --without-gsettings --with-x-toolkit=athena --prefix=${EMACS_INSTALL_DIR};\
	sh -c "echo 0 > /proc/sys/kernel/randomize_va_space";\
	time nice make -j 4;\
	make install

~/modules/emacs/24.5: ${EMACS_INSTALL_DIR}/bin/emacs
	mkdir -p ~/modules/emacs
	cat emacs_module_template | envsubst '$$EMACS_INSTALL_DIR' > ~/modules/emacs/24.5

~/.emacs.d/init.el: 
	cp init.el ~/.emacs.d/init.el

~/.emacs.d/elpa: ~/.emacs.d/init.el ~/modules/emacs/24.5
	module load emacs/24.5; emacs --script install.el
