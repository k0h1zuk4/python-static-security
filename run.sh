#!/bin/bash

# sysinfo_page - A Script to verify python dependencies known vulnerabilities and run security static analysis using Bandit

### Constants

REPO_LIST=()

### Functions

display_help () 
{
    echo
    echo "   -gu          Set git user for repository download. Ex: -gu=username"
    echo "   -gp          Set git password for repository download. Ex: -gp=passwd "
    echo "   -m           Set run mode. static-scan (Bandit); dep-check (Safety); git-leaks (Gitleaks). Ex: -m=dep-chek "
    echo "   -r           Set a especific repository for testing. Ex: -r=myreponame "
    echo "   -ro          Set a especific github repository owner. Ex: -r=google "
    echo "   -h           Show help"
    echo
    exit 1
}

donwload_repos ()
{
    echo "Downloading Repos..."
    for repo in ${REPO_LIST[@]}; do
        git clone https://${GIT_USER}:${GIT_PASSWORD}@github.com/${GIT_USER}/${repo}.git
    done
    echo "Download Repos... done"
}

run_python_dep_scan ()
{
    for file in $(find . -name "requirements*.txt"); do
        TEMP_FILENAME="${file:2}"
        TEMP_FILENAME="${TEMP_FILENAME////_}"
        python -m safety check -r ${file} --full-report --json > results/result_dep_scan_${TEMP_FILENAME}_$(date +"%Y-%m-%d").txt
    done
    echo "Dependence Scan... done"
}

run_bandit ()
{
    for repo in ${REPO_LIST[@]}; do
        echo "Running bandit for ${repo}..."
        python -m bandit -f json -r ~/${repo} > results/result_bandit_${repo}_$(date +"%Y-%m-%d").txt
    done
    echo "Static Scan... done"
}

run_git_leaks ()
{
    for repo in ${REPO_LIST[@]}; do
        echo "Running gitleaks for ${repo}..."
        ./gitleaks-linux-amd64 --repo-path=/home/pythonscan/${repo} --report=results/result_gitleaks_${repo}_$(date +"%Y-%m-%d").json
    done
    echo "Git Leaks Scan... done"
}

mode_caller ()
{
    if [[ ! $MODE ]]; then 
        donwload_repos
        run_python_dep_scan
        run_bandit
        run_git_leaks
    elif [ $MODE == "static-scan" ]; then
        donwload_repos
        run_bandit
    elif [ $MODE == "dep-check" ]; then
        donwload_repos
        run_python_dep_scan
    elif [ $MODE == "git-leaks" ]; then
        donwload_repos
        run_git_leaks
    else
        echo "Error mode argument (-m; --mode): Undefined mode, choose one of the options: static-scan; dep-check; git-leaks"
        exit 1
    fi
}

### Main

for i in "$@"
do
case $i in
    -h|--help)
    display_help
    shift # past argument=value
    ;;
    -gu=*)
    GIT_USER="${i#*=}"
    shift # past argument=value
    ;;
    -gp=*)
    GIT_PASSWORD="${i#*=}"
    shift # past argument=value
    ;;
    -m=*)
    MODE="${i#*=}"
    shift # past argument=value
    ;;
    -ro=*)
    REPO_LIST=("${i#*=}")
    shift # past argument=value
    ;;
    -r=*)
    REPO_LIST=("${i#*=}")
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

if [[ ! $GIT_USER ]]; then 
   echo "Must provide git credentials variable. Exiting...."
   exit 1
fi

mkdir results
mode_caller

echo "Script executed successfully, get the results in /results folder"
