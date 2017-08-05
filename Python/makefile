.PHONY: all

all: ~/modules/Python/${PY_VERSION}

Python-${PY_VERSION}.tgz:
	wget https://www.python.org/ftp/python/${PY_VERSION}/Python-${PY_VERSION}.tgz 

Python-${PY_VERSION}: Python-${PY_VERSION}.tgz
	tar kxvf Python-${PY_VERSION}.tgz

${PY_INSTALL_DIR}/Python-${PY_VERSION}/bin/${PY_EXEC}: Python-${PY_VERSION}
	cd Python-${PY_VERSION};\
	mkdir -p ${PY_INSTALL_DIR}/Python-${PY_VERSION};\
	./configure --prefix=${PY_INSTALL_DIR}/Python-${PY_VERSION};\
	make;\
	make install;\
	touch +x ${PY_INSTALL_DIR}/Python-${PY_VERSION}/bin/${PY_EXEC}

~/modules/Python/${PY_VERSION}: ${PY_INSTALL_DIR}/Python-${PY_VERSION}/bin/${PY_EXEC} Python_module_template
	mkdir -p ~/modules/Python
	cat Python_module_template | envsubst '$$PY_INSTALL_DIR $$PY_VERSION $$PY_EXEC' > ~/modules/Python/${PY_VERSION}
