#!/bin/sh

function _show_opt()
{
    option=$1
    summary=$2
    echo -e $summary | awk -v o=$option -v p=$padding 'BEGIN{printf "%-"p"s", o};
        NR==1{print $0};
        NR>1 {printf "%-"p"s", ""; print $0}'

}

function show_help()
{
    COMMAND_NAME=$1
    shift 1
    opt=1
    echo -e "usage: $COMMAND_NAME [COMMANDS] [options]\n"

    SUMMARY=$1
    shift 1
    echo $SUMMARY

    padding=16
    if [[ $@ == *"--"* ]]; then
        echo -e "\nOptions:"
        padding=24
    else
        echo -e "\nCommands:"
    fi
    while [ $# -gt 0 ]; do
        if [ $1 = '--' ]; then
            echo -e "\nCommands:"
            padding=16
            shift 1
        else
            _show_opt "$@"
            shift 2
        fi
    done
}
