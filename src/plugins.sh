#!/bin/sh

function _traverse_file_tree()
{
    parent_dir=$(dirname $1)
    echo $parent_dir
}

function _parent_judo_dir()
{
    curr_dir=$1
    judo_dir=""
    while [ $(echo $curr_dir) != '/' ]; do
        curr_dir=$(_traverse_file_tree $curr_dir)
        if $( ls -A $curr_dir | grep -q '.judo' ); then
            judo_dir=$curr_dir/.judo
            break
        fi
    done

    echo $judo_dir
}

function _active_plugins()
{
    judo_dir=$(_parent_judo_dir $PWD)

    if [ ! -z $judo_dir ] && [ -f $judo_dir/plugins ]; then
        active_plugins=$(cat $judo_dir/plugins | sed -E '/^#|^\s*$/d')
    fi
    if [ -z $active_plugins ]; then
        active_plugins=$(cat $JUDO_CONFIG_HOME/plugins | sed -E '/^#|^\s*$/d')
    fi
    echo $active_plugins
}

function list()
{
    echo "-- Installed plugins"
    ls $DATA_ROOT/plugins
    echo "-- Activated plugins"
    _active_plugins
}

function install()
{
    if [ $# -eq 0 ]; then
        # Install plugin from current directory
        plugin_name=${PWD##*/}
        cp -rp . $DATA_ROOT/plugins/$plugin_name && \
            echo "Successfully installed $plugin_name. You may now add it to your plugins-files."
    elif [ $(echo $1 | grep '/judo-') ]; then
        # Install plugin from github
        plugin_name=$(echo $1 | cut -d'/' -f2)
        if [ ! -d $DATA_ROOT/plugins/$plugin_name ]; then
            echo "Installing plugin $plugin_name ..."
            git clone -q "https://github.com/$1" $DATA_ROOT/plugins/$plugin_name
            echo "Successfully installed plugin $1."
        else
            echo "Plugin with name $plugin_name is already installed!"
        fi
    else
        echo 'judo-plugins have to start with "judo-".'
    fi
}

function uninstall()
{
    plugin_name=$1
    rm -rf $DATA_ROOT/plugins/$plugin_name && \
        echo "Successfully uninstalled $plugin_name."
}

function help()
{
    source $DATA_ROOT/src/common.sh
    show_help "judo plugins" "Manage and get information on active and installed plugins." \
        list "List both installed plugins and plugins active in the current image. \n
You may have to update the image for new plugins to take effect." \
        install "When run inside a plugin-directory, install this plugin and make it available for images. \n
When having specified a plugin-name, pull this plugin from git and install it. \n
You can use this plugin by noting its name in the global config under ~/.config/judo/plugins or the \n
project-specific config in <project-directory>/.judo/plugins." \
        uninstall "Uninstall plugin of given name." \
        help "View this help."
}

function exec_plugins()
{
    case $1 in
        list)
            list
            shift 1
            ;;

        install)
            install $2
            shift 1
            ;;

        uninstall)
            uninstall $2
            shift 2
            ;;

        help|*)
            help
            shift 1
            ;;
    esac
}
