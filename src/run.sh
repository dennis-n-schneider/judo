#!/bin/sh


function run()
{
    docker run --pull never -e GRANT_SUDO=yes --user=root -it --rm -p $port:8888 -v $PWD:/home/jovyan/work --name $project_name $project_name
}

function help()
{
    source $DATA_ROOT/src/common.sh
    show_help "judo run" "Run the judo-project in this directory." \
        "-n|--name name" "Specify the name of the Docker container. Default: The current directories name (lowercase)." \
        "-p|--port port" "Use specific port. Default: 8888" "--" \
        "help" "View this help."
}

function exec_run()
{
    while [ $# -gt 0 ]; do
        case $1 in
            -p|--port)
                port=$2
                shift 2
                ;;

            -n|--name)
                project_name=$2
                shift 2
                ;;

            help|*)
                help
                shift 1
                return
                ;;
        esac
    done
    echo $port
    echo $project_name
    #run
}

