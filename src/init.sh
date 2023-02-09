#!/bin/sh

function init()
{
    mkdir -p .judo/plugins_dir
    source $DATA_ROOT/src/plugins.sh; echo $(_active_plugins) | xargs -I{} cp -rp $DATA_ROOT/plugins/{} .judo/plugins_dir
    mkdir -p .judo
    touch .judo/config.sh .judo/plugins
    cp $JUDO_CONFIG_HOME/config.sh .judo/combined_config.sh
    cat .judo/config.sh >> .judo/combined_config.sh
    datafiles=$(ls -d $DATA_ROOT/assets/*)
    datafile_names=$(ls $DATA_ROOT/assets)
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
    rm -r plugins_dir
    rm combined_config.sh
    echo $datafile_names | sed 's/ /\n/g' | xargs rm -r
}

init
