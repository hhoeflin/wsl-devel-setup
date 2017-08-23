##############################################################
## The date of the CRAN repo to use
dateToUse <- "2017-08-19"
## other repos to use ?
otherRepos <- NULL
## number of CPUs to use
cpusToUse <- 10
## Should all packages that are installed with R itself be re-installed
reinstallAllPackagesIncludedWithR <- TRUE
## Is there another library that should be used (and therefore packages contained
## therein not be re-installed)?
otherLibs <- NULL
## A folder to use for local packages (not available form a CRAN server)
local.package.folder <- normalizePath("local_packages", mustWork = FALSE)
## set the bioconductor version explicitly
R_BIOC_VERSION="3.3"
Sys.setenv(R_BIOC_VERSION=R_BIOC_VERSION)
## library where everything is going to be installed
## this will be set by the makefile
installRLIB <- normalizePath(Sys.getenv("INSTALL_RLIB"), mustWork=FALSE)
## set the configure args and vars; named list for each package that needs them
configure.args <- NULL 
configure.vars <- NULL
##############################################################

########################################################
## considered fixed for the makefile
## where is the list of packages that should be installed
packagesFile <- "PackagesToInstall.txt"
## directory to save the packages into
download.dir <- file.path(getwd(), "downloaded_packages")
## RLIB where required packages for building are
build_rlib <- "BUILD_RLIB"
## name of the manifest file
manifest.file <- "manifest.txt"
#######################################################


my_write_packages <- function(dir) {
    num_packs <- write_PACKAGES(dir=dir, type="source")
    if(num_packs == 0) {
        system(paste("touch", paste0(dir, "/PACKAGES")))
    }
    return(num_packs)
}

calc_packname_version <- function(avail.df) {
    if(!is.data.frame(avail.df)) {
        avail.df <- as.data.frame(avail.df, stringsAsFactors=FALSE)
    }
    if(nrow(avail.df) > 0) {
        res <- within(avail.df, Packname_version <- paste0(Package, "_", Version))
    }
    else {
        res <- cbind(avail.df, data.frame(Packname_version=character(0)))
    }
    return(res)
}

calc_filename <- function(avail.df) {
    if(nrow(avail.df) > 0) {
        res <- within(avail.df, filename <- paste0(Repository, "/", Packname_version, ".tar.gz"))
    }
    else {
        res <- cbind(avail.df, data.frame(filename=character(0)))
    }
    return(res)
}


#########################################
# Pre-work to read the config and ensure that
# necessary packages are available
#########################################


## check that the build_rlib exists; if not create it
## ensure that the packages we need are installed and available
dir.create(build_rlib, showWarnings = FALSE, recursive = TRUE)
required_packages <- c("devtools", "miniCRAN")
required_not_installed <- setdiff(required_packages, rownames(installed.packages(lib.loc=build_rlib)))
build_rlib <- normalizePath(build_rlib)
.libPaths(build_rlib)

if(length(required_not_installed) > 0) {
    repos_to_use_tools <- "https://cran.rstudio.com"
    ## need to check if igraph is available separately; if not, need to install it 
    if(!require("igraph", character.only = TRUE)) {
        if(!require("devtools", character.only=TRUE)) {
            install.packages("devtools", repos=repos_to_use_tools)
        }
        library(devtools)
        options(unzip = 'internal')
        install_github("igraph/rigraph")
    }
    install.packages(required_not_installed, repos=repos_to_use_tools)
}

library(miniCRAN)


#########################################
# Install the packages
#########################################

## get some helper functions needed for later
getBasePackages <- function() {
    return(installed.packages(priority="base")[, "Package"])
}

library(tools)
## .libPaths("")
## First set the repositories to what we want to use
## this command sets the CRAN as well as the bioconductor repositories
setRepositories(ind=1:5)

## for reproducibility, we use revolution analytics daily versioned CRAN server
current.repos <- getOption("repos")
current.repos["CRAN"] <- paste0("http://mran.revolutionanalytics.com/snapshot/", dateToUse)
options(repos=c(current.repos, otherRepos))

## create the local minicran; download XML just so that it is not empty at the beginning
dir.create(download.dir, showWarnings=FALSE, recursive=TRUE)
download.contriburl <- paste0("file:/", download.dir)
## check which are already there so that we only download those that are newer
my_write_packages(download.dir)
available.download <- available.packages(contriburl=download.contriburl, type="source")


## personal contriburls (to create one - copy .tar.gz package files into a directory and run
## write_PACKAGES from the tools package on it
## here, local.package.folder is a folder where you have packages and write permissions (an index
## will be created)
## but other online sources (e.g. in an svn repo) can be given as well
my_write_packages(local.package.folder)
local.contriburl <- paste0("file:/", local.package.folder)


## read a file that specifies all the packages that should be downloaded
packages.requested <- unique(read.table(packagesFile, stringsAsFactors = FALSE, header=FALSE)[[1]])

## all available packages 
all.contriburl <- c(download.contriburl, local.contriburl, contrib.url(getOption("repos")))
available.all <- available.packages(contriburl=all.contriburl)
available.internet <- available.packages(contriburl=contrib.url(getOption("repos")))
available.local <- available.packages(contriburl=local.contriburl)

## now we need to enrich this list by its dependencies
packages.to.download <- pkgDep(packages.requested, type="source", suggests=FALSE,
                              availPkgs = available.all)


## aside from those we also want all globally installed one except for R-base
## the reason for that is that we want to control all packages that are being used
## and globally installed ones would be accessible without people realizing it
if(reinstallAllPackagesIncludedWithR) {
    packages.to.download <- setdiff(union(packages.to.download,
                                      installed.packages(lib.loc=rev(.libPaths())[1])[, "Package"]),
                                    getBasePackages())
}

## some prep to make it easier to compare versions
available.local <- calc_filename(calc_packname_version(available.local))

available.internet <- calc_filename(calc_packname_version(available.internet))

available.download <- calc_filename(calc_packname_version(available.download))

## now remove from those available local and the internet all that are already downloaded to download
available_rest.local <- available.local[!(available.local[["Packname_version"]] %in% available.download[["Packname_version"]]),]
available_rest.internet <- available.internet[!(available.internet[["Packname_version"]] %in% available.download[["Packname_version"]]),]
## also don't download anything from internet that is available local
available_rest.internet <- available_rest.internet[!(available_rest.internet[["Package"]] %in% available.local[["Package"]]),]


download.local <- intersect(packages.to.download, available_rest.local[["Package"]])
# local trumps internet
download.internet <- setdiff(intersect(packages.to.download, available_rest.internet[["Package"]]), download.local)

## those are the ones we don't download
packages.not.download <- setdiff(packages.to.download, union(download.local, download.internet))

packages.missing <- setdiff(packages.not.download, available.download[["Package"]])

## what to do if some packages that were supposed to be downloaded are not available
if(length(packages.missing) > 0) {
    stop(paste("The following packages were supposed to be downloaded but are missing:",
               paste(packages.missing, collapse=", ")))
}


## now add the remaining packages
if(length(download.internet) > 0) {
    download.packages(pkgs=download.internet, destdir=download.dir, repos=getOption("repos"), type="source")
}
if(length(download.local) > 0) {
    files_to_copy <- available_rest.local$filename[available_rest.local$Package %in% download.local]
    files_to_copy <- gsub("file:/", "", files_to_copy, fixed=TRUE)
    file.copy(files_to_copy, to=download.dir)
}

## now write out a manifest of all the downloaded packages;
## ensure that all of the ones we wanted to download are present
my_write_packages(download.dir)
avail_download <- calc_packname_version(available.packages(contriburl = download.contriburl, type="source"))
packages.not.downloaded <- setdiff(packages.to.download, avail_download[,"Package"])
if(length(packages.not.downloaded) > 0) {
    stop("The following packages were not downloaded: ", paste(packages.not.downloaded, collapse=", "))
}

########################################################
##
## Now I want to install the packages
## But only the ones that are not already installed in
## exactly this version
##
########################################################
dir.create(installRLIB, showWarnings=FALSE, recursive=TRUE)
packs.installed <- calc_packname_version(installed.packages(lib.loc=installRLIB))


## we install all packages.to.download, except those that are installed in the same version in
## which they were downloaded
downloaded.to.install  <- avail_download[avail_download[["Package"]] %in% packages.to.download, ]
downloaded.to.install <- downloaded.to.install[!(downloaded.to.install[["Packname_version"]] %in% packs.installed[["Packname_version"]]),]

if(nrow(downloaded.to.install) > 0) {
    install.packages(downloaded.to.install[["Package"]], lib=installRLIB, contriburl=download.contriburl, available=avail_download,
                     configure.args=configure.args, configure.vars=configure.vars, method="source", quite=FALSE, Ncpus=cpusToUse)
                     
}

## return a document with all the now installed packages
packs.installed <- installed.packages(lib.loc=installRLIB)
write.csv(as.data.frame(packs.installed), file=manifest.file)
quit(save="no")

