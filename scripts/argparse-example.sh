#!/bin/sh

#abort on error
set -e

function usage
{
    echo "usage: arg_parse_example -a AN_ARG -s SOME_MORE_ARGS [-y YET_MORE_ARGS || -h]"
    echo "   ";
    echo "  -a | --an_arg            : A super special argument";
    echo "  -s | --some_more_args    : Another argument";
    echo "  -y | --yet_more_args     : An optional argument";
    echo "  -h | --help              : This message";
}

function parse_args
{
    # positional args
    args=()
    
    # named args
    while [ "$1" != "" ]; do
        case "$1" in
            -a | --an_arg )               an_arg="$2";             shift;;
            -s | --some_more_args )       some_more_args="$2";     shift;;
            -y | --yet_more_args )        yet_more_args="$2";      shift;;
            -h | --help )                 usage;                   exit;; # quit and show usage
            * )                           args+=("$1")             # if no match, add it to the positional args
        esac
        shift # move to next kv pair
    done
    
    # restore positional args
    set -- "${args[@]}"
    
    # set positionals to vars
    positional_1="${args[0]}"
    positional_2="${args[1]}"
    
    # validate required args
    if [[ -z "${an_arg}" || -z "${some_more_args}" ]]; then
        echo "Invalid arguments"
        usage
        exit;
    fi
    
    # set defaults
    if [[ -z "$yet_more_args" ]]; then
        yet_more_args="a default value";
    fi
}


function run
{
    parse_args "$@"
    
    echo "you passed in...\n"
    echo "positional arg 1: $positional_1"
    echo "positional arg 2: $positional_2"
    
    echo "named arg: an_arg: $an_arg"
    echo "named arg: some_more_args: $some_more_args"
    echo "named arg: yet_more_args: $yet_more_args"
}



run "$@";