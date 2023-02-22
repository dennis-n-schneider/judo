#!/bin/sh

function init()
{
    mkdir -p .judo/.cache .judo/.cache/plugins_dir
    # Get active plugins and copy to image cache
    source $DATA_ROOT/src/plugins.sh; echo $(_active_plugins) | xargs -I{} cp -rpu $DATA_ROOT/plugins/{} .judo/.cache/plugins_dir
    touch .judo/config.sh .judo/plugins
    cp -u $JUDO_CONFIG_HOME/config.sh .judo/.cache/common_config.sh
    cp -u .judo/config.sh .judo/.cache/project_config.sh
    new_config=$(cat .judo/.cache/common_config.sh .judo/.cache/project_config.sh)
    [ echo "$new_config" | cmp --silent .judo/.cache/combined_config.sh ] \
        || echo "$new_config" > .judo/.cache/combined_config.sh
    datafiles=$(ls -d $DATA_ROOT/assets/*)
    datafile_names=$(ls $DATA_ROOT/assets)
    echo $datafiles | sed 's/ /\n/g' | xargs -I{} cp -rpu {} .judo/.cache
    touch requirements.txt && chmod 604 requirements.txt
    cp -u requirements.txt .judo/.cache/requirements.txt
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
    docker build -t $project_name $alternative_image .judo/.cache
    #rm -rf plugins_dir
}


function help()
{
    echo """
    -n|--name: Specify the name of the Docker container. Default: The current directories name (lowercase).
    -i|--image: Use alternative base-image, instead of default jupyter/scipy-notebook.
    """
}

function parse_arguments()
{
    # Read input arguments.
    LONGOPTS=port:,name:,image:
    OPTIONS=p:n:i:

    ARGUMENTS=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name $0 -- $@)
    if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
        # getopt: wrong arguments
        exit 2
    fi
    eval set -- "$ARGUMENTS"

    while true; do
        case $1 in
            -h|--help)
                help=1
                shift 1
                ;;
            -n|--name)
                project_name=$2
                shift 2
                ;;
            -i|--image)
                image=$2
                shift 2
                ;;
            --)
                shift
                break
                ;;
        esac
    done
}

function exec_init()
{
    init $@
}
