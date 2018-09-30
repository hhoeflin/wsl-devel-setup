SHELL=/bin/bash
.PHONY: all emacs-24.5 R-3.5.1 R-3.5.0 R-3.4.2 R-3.4.1 R-3.3.3 R-3.2.5 Python-2.7.13 Python-3.6.2\
	R Python hdf5 hdf5-1.10.3 hdf5-1.10.2 hdf5-1.10.1 hdf5-1.8.19 hdf5-1.8.17 hdf5-1.8.14 hdf5-1.8.12

ifndef INSTALL_DIR
INSTALL_DIR=${HOME}/prog
endif

all: emacs-24.5 R Python hdf5
R: R-3.5.1 R-3.5.0 R-3.4.2 R-3.4.1 R-3.3.3 R-3.2.5
Python: Python-2.7.13 Python-3.6.2
hdf5: hdf5-1.10.3 hdf5-1.10.2 hdf5-1.10.1 hdf5-1.8.21 hdf5-1.8.19 hdf5-1.8.17 hdf5-1.8.14 hdf5-1.8.12 

emacs-24.5: 
	cd emacs; make EMACS_INSTALL_DIR=${INSTALL_DIR}/emacs/24.5

R-3.5.1:
	cd R; make R_INSTALL_DIR=${INSTALL_DIR}/R R_VERSION=3.5.1

R-3.5.0:
	cd R; make R_INSTALL_DIR=${INSTALL_DIR}/R R_VERSION=3.5.0

R-3.4.2:
	cd R; make R_INSTALL_DIR=${INSTALL_DIR}/R R_VERSION=3.4.2

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

hdf5-1.8.12: 
	cd hdf5; make HDF5_INSTALL_DIR=${INSTALL_DIR}/hdf5 HDF5_VERSION_MAJOR=1.8 HDF5_VERSION_MINOR=12

hdf5-1.8.14: 
	cd hdf5; make HDF5_INSTALL_DIR=${INSTALL_DIR}/hdf5 HDF5_VERSION_MAJOR=1.8 HDF5_VERSION_MINOR=14

hdf5-1.8.17: 
	cd hdf5; make HDF5_INSTALL_DIR=${INSTALL_DIR}/hdf5 HDF5_VERSION_MAJOR=1.8 HDF5_VERSION_MINOR=17

hdf5-1.8.19: 
	cd hdf5; make HDF5_INSTALL_DIR=${INSTALL_DIR}/hdf5 HDF5_VERSION_MAJOR=1.8 HDF5_VERSION_MINOR=19

hdf5-1.8.21: 
	cd hdf5; make HDF5_INSTALL_DIR=${INSTALL_DIR}/hdf5 HDF5_VERSION_MAJOR=1.8 HDF5_VERSION_MINOR=21

hdf5-1.10.1: 
	cd hdf5; make HDF5_INSTALL_DIR=${INSTALL_DIR}/hdf5 HDF5_VERSION_MAJOR=1.10 HDF5_VERSION_MINOR=1

hdf5-1.10.2: 
	cd hdf5; make HDF5_INSTALL_DIR=${INSTALL_DIR}/hdf5 HDF5_VERSION_MAJOR=1.10 HDF5_VERSION_MINOR=2

hdf5-1.10.3: 
	cd hdf5; make HDF5_INSTALL_DIR=${INSTALL_DIR}/hdf5 HDF5_VERSION_MAJOR=1.10 HDF5_VERSION_MINOR=3
