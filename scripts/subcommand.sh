#!/bin/bash


# bash strict mode
set -T # inherit DEBUG and RETURN trap for functions
set -C # prevent file overwrite by > &> <>
set -E # inherit -e
set -e # exit immediately on errors
set -u # exit on not assigned variables
set -o pipefail # exit on pipe failure


################################################################################
# check for needed commands
################################################################################
function import(){
    declare -r command_name=$1;
    
    if ! which $command_name > /dev/null 2>&1; then
        echo $command_name not found.
        echo Make sure you have installed it.
        echo install $command_name from here:
        case $command_name in
            yq )
                echo 'https://github.com/mikefarah/yq';
            ;;
            * )
                echo 'your OS repository or search the Internet';
            ;;
        esac
        exit 1;
    fi
}

import echo
import printf
import perl

################################################################################
# global variable
################################################################################
declare -r CLI_VERSION='1.0.0';
declare -r CLI_NAME='<CLI_NAME>';
declare -r PS4='debug($LINENO) ${FUNCNAME[0]:+${FUNCNAME[0]}}(): ';


################################################################################
# functions
################################################################################
function main_help(){
    echo list of commands:
    printf "%-23s %s\n" "help" "show help menu and commands";
    printf "%-23s %s\n" "version" "show version of this script";
    printf "%-23s %s\n" "encrypt" "encrypt values of selected keys";
    printf "%-23s %s\n" "decrypt" "decrypt values of selected keys";
    
    exit ${1:-0};
}

function version(){
    echo $CLI_NAME $CLI_VERSION;
    exit 0
}

function encrypt_help(){
    printf "%-23s %s\n" "encrypt" "generate from a template";
    printf "%-25s %s\n" "-f  │ --file" "any well formatted file";
    printf "%-25s %s\n" "-s  │ --salt" "salt for encryption";
    printf "%-25s %s\n" "-a  │ --anchor" "[true|false] default: true";
    exit 0;
}

function encrypt(){
    if [[ ${#} == 0 ]]; then
        encrypt_help;
    fi
    
    local __filename='';
    local __salt='';
    local __anchor=false;
    local error_message='';
    
    while [ ${#} -gt 0 ]; do
        error_message="Error: a value is needed for '$1'";
        case $1 in
            -f | --file )
                __filename=${2:?$error_message}
                shift 2;
            ;;
            -s | --salt )
                __salt=${2:?$error_message}
                shift 2;
            ;;
            -a | --anchor )
                __anchor=${2:?$error_message}
                shift 2;
            ;;
            * )
                echo "unknown option $1";
                break;
            ;;
        esac
    done
    
    echo filename: ${__filename:-empty};
    echo salt: ${__salt:-empty};
    echo anchor: $__anchor;
    
    exit 0;
}

function decrypt_help(){
    printf "%-23s %s\n" "decrypt" "decrypt values";
    printf "%-25s %s\n" "-f  │ --file" "any well formatted file";
    printf "%-25s %s\n" "-s  │ --salt" "salt for decryption";
    printf "%-25s %s\n" "-a  │ --anchor" "[true|false] default: true";
    exit 0;
}

function decrypt(){
    if [[ ${#} == 0 ]]; then
        decrypt_help;
    fi
    
    local __filename='';
    local __salt='';
    local __anchor=false;
    local error_message='';
    
    while [ ${#} -gt 0 ]; do
        error_message="Error: a value is needed for '$1'";
        case $1 in
            -f | --file )
                __filename=${2:?$error_message}
                shift 2;
            ;;
            -s | --salt )
                __salt=${2:?$error_message}
                shift 2;
            ;;
            -a | --anchor )
                __anchor=${2:?$error_message}
                shift 2;
            ;;
            * )
                echo "unknown option $1";
                break;
            ;;
        esac
    done
    
    echo filename: ${__filename:-empty};
    echo salt: ${__salt:-empty};
    echo anchor: $__anchor;
    
    exit 0;
}


function main(){
    if (( ${#} == 0 )); then
        main_help 0;
    fi
    
    case ${1} in
        help | version | encrypt | decrypt )
            $1 "${@:2}";
        ;;
        * )
            echo "unknown command: $1";
            main_help 1;
            exit 1;
        ;;
    esac
}

main "$@";