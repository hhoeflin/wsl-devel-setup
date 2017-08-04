.PHONY: all

all: ~/modules/R/${R_VERSION}

R-${R_VERSION}.tar.gz:
	wget https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz 

R-${R_VERSION}: R-${R_VERSION}.tar.gz
	tar kxvf R-${R_VERSION}.tar.gz

${R_INSTALL_DIR}/R-${R_VERSION}/bin/R: R-${R_VERSION}
	cd R-${R_VERSION};\
	mkdir -p ${R_INSTALL_DIR}/R-${R_VERSION};\
	./configure --prefix=${R_INSTALL_DIR}/R-${R_VERSION};\
	make\
	make install

~/modules/R/${R_VERSION}: ${R_INSTALL_DIR}/R-${R_VERSION}/bin/R
	mkdir -p ~/modules/R
	cat R_module_template | envsubst '$$R_INSTALL_DIR $$R_VERSION' > ~/modules/R/${R_VERSION}
