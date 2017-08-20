# How to adapt the scripts

## In the global directory
In the global directory, the makefile needs to be adapted for every subdirectory with R-libraries contained.

## In the sudirectories
As a first step, any values at the beginning of the install_packages.R script should be adapted, 
especially the **dateToUse** variable that is being used to define the date of the repository in use.
In addition to that **R_BIOC_VERSION** should be set to the appropriate version of Bioconductor.

The packages to install are listed in the **PackagesToInstall.txt** file, one package per row.

In addition, the makefile needs to be adapte, with the correct version of R to use for the installation.
