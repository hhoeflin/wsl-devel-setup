SHELL := /bin/bash

.PHONY: all

ifndef INSTALL_DIR      
INSTALL_DIR=${HOME}/user_RLIB/R-3.3.3_Q32017
endif                   

all: manifest.txt install_packages.Rout

manifest.txt install_packages.Rout: install_packages.R PackagesToInstall.txt
	. /usr/share/modules/init/bash;\
	module purge;\
	module load R/3.3.3;\
	export INSTALL_RLIB=${INSTALL_DIR};\
	R CMD BATCH install_packages.R install_packages.Rout

