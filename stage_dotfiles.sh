#!/bin/bash
#
# This script is intended to stage a git configuration repository on a new machine
# The old configuration files are checked into a new branch of the git repository.
#
# The set of parameters is
# - The URL of the repository to use (-r)
# - path were the bare git repository is cloned into (-p)
# - The name of the branch with the desired config files (-b)
# - The name of the branch under which the old config files should be checked in (-o)
# - The path to the git-binary to use (-b)

# The script below was guided by the implementation provided in
# https://stackoverflow.com/questions/11279423/bash-getopts-with-multiple-and-mandatory-options
# and
# https://www.atlassian.com/git/tutorials/dotfiles

usage () { 
    echo "$0 [-h] [-t target_branch_name] [-o old_branch_name] [-b git_binary_path] [-p gitdir_path] [-w working_dir] repo_url"
    echo "* -h: Print help"
    echo "* -t: Name of the branch of the repo that is intended to be deployed. Defaults to 'master'"
    echo "* -o: Name under which a new branch is created in which the old config is stored. Defaults to '\$USER_\$HOSTNAME'"
    echo "* -b: Path to the git binary to use. Defaults to '/usr/bin/git'"
    echo "* -p: Path under which the bare git repository directory is stored. Defaults to '\$(pwd)/.git_dotfiles'"
    echo "* -w: Work-tree directory for the repo. Defaults to the current working directory." 
    echo "* repo_url: The URL of the repo to deploy"
}

repo_url=''
gitdir_path="$(pwd)/.git_dotfiles"
repo_branch='master'
repo_oldbranch="${USER}_${HOSTNAME}"
git_bin='/usr/bin/git'
work_dir=$(pwd)
while getopts ":ht:p:o:b:w:" opt; do
    case $opt in
        t  ) repo_branch=$OPTARG;;
        o  ) repo_oldbranch=$OPTARG;;
        b  ) git_bin=$OPTARG;;
        p  ) gitdir_path=$OPTARG;;
        w  ) work_dir=$OPTARG;;
        h  ) usage; exit;;
        \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
        *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
    esac
done

# expand the paths that we are using for our repo and work-tree
gitdir_path=$(realpath ${gitdir_path})
work_dir=$(realpath ${work_dir})

# We don't require any options to be specified; commenting out
#if ((OPTIND == 1))
#then
#    echo "No options specified"
#fi

# This "shifts" all the options we have already processed above, so that
# $1 contains the first argument
shift $((OPTIND - 1))

# we require the repo-url to be given as an argument
if (($# == 0))
then
    echo "Need to provide the URL or the repository"
    usage; exit;
elif (($# == 1))
then
    repo_url=$1
else
    echo "More than one argument provided"
    usage; exit;
fi

echo -e "Repo: ${repo_url}\nBranch: ${repo_branch}\nOldbranch: ${repo_oldbranch}"\
    "\nGitdir Path: ${gitdir_path}\nGit binary: ${git_bin}"\
    "\nWorkdir: ${work_dir}"


# We have collected all the required information

# check if the git directory already exists; if yes, abort
if [[ -d ${gitdir_path} ]]
then
    echo "${gitdir_path} already exists. Please remove before proceeding. Aborting"; exit 1;   
elif [[ -f ${gitdir_path} ]]
then
    echo "${gitdir_path} exists, and is a file. Please remove before proceeding. Aborting."; exit 1;
fi

# set the gitignore
if [[ -f ${work_dir}/.gitignore ]] 
then
    echo "${work_dir}/.gitignore already exists. Please remove before proceeding. Aborting."; exit 1;
fi

# check out the repo as bare into the desired directory
# setting alias expansion for convenience
shopt -s expand_aliases
alias git=${git_bin}
git clone --bare ${repo_url} ${gitdir_path}


# create a temporary file that will hold the output of git-ls
# store the names of all files checked into the target branch
tmpfile=$(mktemp)
echo "Files in reference branch stored in ${tmpfile}"
# need to switch to the directory, or setting the symbolic-ref won't work
cd ${gitdir_path}
git symbolic-ref HEAD refs/heads/${repo_branch} 
git --git-dir=${gitdir_path} ls-tree --full-tree -r --name-only HEAD > ${tmpfile}

# create an orphan branch
git symbolic-ref HEAD refs/heads/${repo_oldbranch} 
# check if there is an index there; for a bare repo should not be the case
if [[ -f ${gitdir_path}/index ]] 
then
    echo "Bare repo at ${gitdir_path} has an index. This should not have happened. Aborting."; exit 1;
fi

# walk through all the files that were checked into the master branch
# and check them in as well here, if  it is set
# and also change back to the working directory
cd ${work_dir}
gitdir_path_rel_home=$(realpath --relative-to=${HOME} ${gitdir_path})
work_dir_rel_home=$(realpath --relative-to=${HOME} ${work_dir})
# we use this here a bit complicated relative to home as we want to print it later as well
config_git_alias="${git_bin} --git-dir=\$HOME/${gitdir_path_rel_home} --work-tree=\$HOME/${work_dir_rel_home}"
alias config_git=${config_git_alias}
cat ${tmpfile} | while read path
do
    if [[ -f ${work_dir}/${path} ]]
    then
        echo "Adding ${path}"
        config_git add ${path}
    fi
done
# set to ignore our path intended for the bare repo
# this should be relative to the working directory
gitdir_path_rel_work=$(realpath --relative-to=${work_dir} ${gitdir_path})
echo "${gitdir_path_rel_work}" > .gitignore
config_git add .gitignore
config_git commit -m "Old config files"  

# make sure that only tracked files are shown when asking for status
config_git config --local status.showUntrackedFiles no

# set a message to make sure the config_git alias is set
# set message how to switch to the config in the target branch
echo -e "\nPlease make sure that you have the following alias set in your .bashrc"
echo -e "    alias config_git=${config_git_alias}"


echo -e "\nIf you have this set you can switch to your target branch with"
echo -e "    config_git checkout ${repo_branch}"
echo -e "\nTo switch back to the current branch do"
echo -e "    confit_git checkout ${repo_oldbranch}"


