#!/bin/sh

function init()
{
    touch .judo/config.sh .judo-plugins
    datafiles=$(ls -d "$DATA_ROOT"/*)
    datafile_names=$(ls $DATA_ROOT)
    cp -rp $judo_config_home/plugins .judo/developer-plugins
    cp $judo_config_home/config.sh .judo/developer-config.sh
    echo $datafiles | sed 's/ /\n/g' | xargs -I{} cp -rp {} .judo
    touch requirements.txt && chmod 604 requirements.txt
    if [ ! -d ".git" ]; then
        git init
        # Get up-to-date gitignore file for a jupyter notebook.
        git fetch --depth=1 git@github.com:jupyter/notebook.git
        git checkout FETCH_HEAD -- .gitignore
        git add requirements.txt
    fi
    # Use alternative image if specified.
    if [ ! -z $image ]; then
        alternative_image="--build-arg BASE_IMAGE=$image"
    fi
    docker build -t $project_name $alternative_image .judo
    cd .judo
    rm -r developer-plugins
    rm developer-config.sh
    echo $datafile_names | sed 's/ /\n/g' | xargs rm -r
}

init
