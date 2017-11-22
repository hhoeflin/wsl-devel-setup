.PHONY: all

all: ~/.emacs.d/elpa 

~/.emacs.d/init.el: 
	mkdir -p ~/.emacs.d
	cp init.el ~/.emacs.d/init.el

~/.emacs.d/elpa: ~/.emacs.d/init.el
	emacs --script install.el
