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
    plugin_name=${PWD##*/}
    cp -rp . $DATA_ROOT/plugins/$plugin_name && \
        echo "Successfully installed $plugin_name. You may now add it to your plugins-files."
}

function uninstall()
{
    plugin_name=$1
    rm -rf $DATA_ROOT/plugins/$plugin_name && \
        echo "Successfully uinstalled $plugin_name."
}

function help()
{
    echo """
Manage and get information on activate and installed plugins.
Available commands:
list:
    List both installed plugins and plugins activate in the current image.
    You may have to update the image for new plugins to take effect.
install:
    When run inside a plugin-directory, install this plugin and make it available for images.
    You can actively use this plugin ny noting its name in the global config under ~/.config/judo/plugins or the project-specific config in <project-directory>/.judo/plugins.
help:
    View this help.
    """
}

function exec_plugins()
{
    case $1 in
        list)
            list
            shift 1
            ;;

        install)
            install
            shift 1
            ;;

        uninstall)
            uninstall $2
            shift 2
            ;;

        help|*)
            help
            ;;
    esac
}
