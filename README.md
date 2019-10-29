# Setup before running scripts
We would like to have permission to run sudo on apt-get without
giving the password. Therefore type 
```
sudo visudo
```

and add the line

```
<myusername> ALL=NOPASSWD: /usr/bin/apt-get
```

to the file.

In addition, to set up vundle for nvim, do 

```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.nvim/bundle/Vundle.vim
```
