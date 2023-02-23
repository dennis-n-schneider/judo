#!/bin/sh

function init()
{
    mkdir -p .judo/.cache .judo/.cache/plugins_dir
    # Get active plugins and copy to image cache if updated
    source $DATA_ROOT/src/plugins.sh; echo $(_active_plugins) | xargs -I{} cp -rpu $DATA_ROOT/plugins/{} .judo/.cache/plugins_dir
    touch .judo/config.sh .judo/plugins
    if [ -z $ignore_global_config ]; then
        cp -u $JUDO_CONFIG_HOME/config.sh .judo/.cache/common_config.sh
    else
        touch .judo/.cache/common_config.sh
    fi
    cp -u .judo/config.sh .judo/.cache/project_config.sh
    find $DATA_ROOT/assets -exec cp -rpu {} .judo/.cache \;
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
    echo $project_name > .judo/container_name
    if [ ! -z $image ]; then
        alternative_image="--build-arg BASE_IMAGE=$image"
    fi
    docker build -t $project_name $alternative_image .judo/.cache
}


function help()
{
    source $DATA_ROOT/src/common.sh
    show_help "judo init" "Initialize a judo-project in the current directory." \
        "-n|--name name" "Specify the name of the Docker container. Default: The current directories name (lowercase)." \
        "-i|--image name" "Use specific base-image. Default: jupyter/scipy-notebook." \
        "--ignore_global_config" "Whether to ignore the global configuration file in .config/judo/config.sh." "--" \
        "help" "View this help."
}

function exec_init()
{
    while [ $# -gt 0 ]; do
        case $1 in
            -i|--image)
                image=$2
                shift 2
                ;;

            -n|--name)
                project_name=$2
                shift 2
                ;;

            --ignore_global_config)
                ignore_global_config=1
                shift 1
                ;;

            help|*)
                help
                shift 1
                return
                ;;
        esac
    done
    init
}
