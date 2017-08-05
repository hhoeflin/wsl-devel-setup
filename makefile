.PHONY: all emacs-24.5 R-3.4.1 R-3.3.3 R-3.2.5 Python-2.7.13 Python-3.6.2

ifndef INSTALL_DIR
INSTALL_DIR=${HOME}/prog
endif

all: emacs-24.5 R-3.4.1 R-3.3.3 R-3.2.5 Python-2.7.13 Python-3.6.2

emacs-24.5: 
	cd emacs; make EMACS_INSTALL_DIR=${INSTALL_DIR}/emacs/24.5

R-3.4.1:
	cd R; make R_INSTALL_DIR=${INSTALL_DIR}/R R_VERSION=3.4.1

R-3.3.3:
	cd R; make R_INSTALL_DIR=${INSTALL_DIR}/R R_VERSION=3.3.3

R-3.2.5:
	cd R; make R_INSTALL_DIR=${INSTALL_DIR}/R R_VERSION=3.2.5

Python-2.7.13:
	cd Python; make PY_INSTALL_DIR=${INSTALL_DIR}/Python PY_VERSION=2.7.13 PY_EXEC=python

Python-3.6.2:
	cd Python; make PY_INSTALL_DIR=${INSTALL_DIR}/Python PY_VERSION=3.6.2 PY_EXEC=python3
