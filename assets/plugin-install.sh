#!/bin/sh

PLUGINS_DIR='/tmp/plugins'

for plugin in $(ls -d "$PLUGINS_DIR"/* | sed 's/ /\n/g'); do
    echo "Installing $plugin ..."
    cd $plugin
    sh run.sh
done

cd $WORKDIR
