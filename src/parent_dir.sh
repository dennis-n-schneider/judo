#!/bin/sh

function _traverse_file_tree()
{
    parent_dir=$(dirname $1)
    echo $parent_dir
}

function parent_judo_dir()
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

