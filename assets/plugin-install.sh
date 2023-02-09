#!/bin/sh

DEVELOPER_PLUGINS_DIR='/tmp/developer-plugins'
PROJECT_PLUGINS_DIR='/tmp/project-plugins'

if [ $(\ls -A $PROJECT_PLUGINS_DIR | head -1) ]; then
    LOAD_PLUGINS=$PROJECT_PLUGINS_DIR
elif [ $(\ls -A $DEVELOPER_PLUGINS_DIR | head -1) ]; then
    LOAD_PLUGINS=$DEVELOPER_PLUGINS_DIR
fi

if [ ! -z $LOAD_PLUGINS ]; then
    for plugin in $(ls -d "$LOAD_PLUGINS"/* | sed 's/ /\n/g'); do
        echo $plugin
        cd $plugin
        sh run.sh
    done
fi
