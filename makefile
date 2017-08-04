.PHONY: all

ifndef INSTALL_DIR
INSTALL_DIR=~/prog
endif

all: emacs-24.5 R-3.4.1 R-3.3.3 R-3.2.5 

emacs-24.5: 
	cd emacs; make EMACS_INSTALL_DIR=${INSTALL_DIR}/emacs/24.5

R-3.4.1:
	cd R; make R_INSTALL_DIR=${INSTALL_DIR}/R R_VERSION=3.4.1

R-3.3.3:
	cd R; make R_INSTALL_DIR=${INSTALL_DIR}/R R_VERSION=3.3.3

R-3.2.5:
	cd R; make R_INSTALL_DIR=${INSTALL_DIR}/R R_VERSION=3.2.5
