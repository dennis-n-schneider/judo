#/bin/sh

# if /project is empty
if [ ! -d "/project/src" ]; then
    echo "Initializing project directory ..."
    cp -r /template/* /project
fi
