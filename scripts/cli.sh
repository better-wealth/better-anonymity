#!/bin/bash

################################################################################
# Bash CLI template
# A more flexible CLI parser (way of parsing)
# 20XX (C) Shakiba Moshiri
################################################################################

################################################################################
# an associative array for storing color and a function for colorizing
################################################################################
declare -A _colors_;
_colors_[ 'red' ]='\x1b[0;31m';
_colors_[ 'green' ]='\x1b[0;32m';
_colors_[ 'yellow' ]='\x1b[0;33m';
_colors_[ 'cyan' ]='\x1b[0;36m';
_colors_[ 'white' ]='\x1b[0;37m';
_colors_[ 'reset' ]='\x1b[0m';

function colorize(){
    if [[ ${_colors_[ $1 ]} ]]; then
        echo -e "${_colors_[ $1 ]}$2${_colors_[ 'reset' ]}";
    else
        echo 'wrong color name!';
    fi
}

function print_title(){
    echo $(colorize cyan "$@");
}


################################################################################
# key-value array
################################################################################
# Options which set attributes:
#   -a	to make NAMEs indexed arrays (if supported)
#   -A	to make NAMEs associative arrays (if supported)
#   -i	to make NAMEs have the `integer' attribute
#   -l	to convert the value of each NAME to lower case on assignment
#   -n	make NAME a reference to the variable named by its value
#   -r	to make NAMEs readonly
#   -t	to make NAMEs have the `trace' attribute
#   -u	to convert the value of each NAME to upper case on assignment
#   -x	to make NAMEs export
declare -i _os_flag=0;
declare -a _os_args=();

declare -i _docker_flag=0;
declare -a _docker_args=();

declare -i _port_flag=0;
declare -a _port_args=1;

declare -r CLI_VERSION='1.3.0';
################################################################################
# __help function
################################################################################
function _os_help(){
    printf "%-25s %s\n" "-O  │ --os" "Os actions:";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'type')" "show / check the name";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'version')" "show / check the version";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'update')" "update the OS";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'info')" "more info about OS";
    
    printf "%-40s %s\n" "    └── $(colorize 'cyan' 'info')" "more info about OS";
}

function _docker_help(){
    printf "%-25s %s\n" "-D  │ --docker" "docker actions";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'install')" "install docker";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'remove')" "uninstall docker";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'compose')" "install docker-compose";
    
    printf "%-40s %s\n" "    └── $(colorize 'cyan' 'kubectl')" "install kubernetes";
}

function _port_help(){
    printf "%-25s %s\n" "-P  │ --port" "manage firewall";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'stop')" "stop all firewalls";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'start')" "start all firewalls";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'disable')" "disable all firewalls";
    printf "%-40s %s\n" "    ├── $(colorize 'cyan' 'enable')" "enable all firewalls";
    
    printf "%-40s %s\n" "    └── $(colorize 'yellow' '<NUMBER>')" "open this port";
}

function _help(){
    printf "%-25s %s\n" "-h  │ --help" "show / print help";
    printf "%-25s %s\n" "-v  │ --version" "show version";
    printf "%-25s %s\n" "-vv │ --verbose" "verbose";
    echo
    echo "$(_os_help)"
    echo
    echo "$(_docker_help)"
    echo
    echo "$(_port_help)"
    echo
    echo "Developer Shakiba Moshiri"
    echo "source    https://github.com/k-five/bash-CLI-template"
    exit 0;
}

if [[ ${#} == 0 ]]; then
    _help;
fi

# /--?[a-zA-Z][^-]*
# this pattern does not work well when we have more dashes -
#
# new one non-group match
# https://stackoverflow.com/questions/36754105/not-group-in-regex
# (?:(?! -).)+
# (?:(?! -)[\s\S])+
mapfile -t ARGS < <( perl -lne 'print $& while /(?:(?! -)[\s\S])+/ig' <<< "$@");
if [[ ${#ARGS[@]} == 0 ]]; then
    _help;
fi

function _os_check(){
    echo "*** _os_check ***";
    echo "flag: $_os_flag";
    echo "args: '${_os_args[*]}'";
    echo "size: '${#_os_args[*]}'";
}

function _docker_check(){
    echo "*** _docker_check ***";
    echo "flag: $_docker_flag";
    echo "args: '${_docker_args[*]}'";
    echo "size: '${#_docker_args[*]}'";
}

function _port_check(){
    echo "*** _port_check ***";
    echo "flag: $_port_flag";
    echo "args: '${_port_args[*]}'";
    echo "size: '${#_port_args[*]}'";
}

function _version_check(){
    echo version: $CLI_VERSION;
    exit 0;
}

function _verbose_check(){
    echo This is --verbose call;
}

for arg in "${ARGS[@]}"; do
    _options_=($arg);

    case ${_options_[0]} in
        -O | --os )
            _os_flag=1;
            _os_args=(${_options_[@]:1});
            _os_check;
        ;;
        -D | --docker )
            _docker_flag=1;
            _docker_args=(${_options_[@]:1});
            _docker_check;
        ;;
        -P | --port )
            _port_flag=1;
            _port_args=(${_options_[@]:1});
            _port_check;
        ;;
        -v | --version )
            _version_check;
        ;;
        -vv | --verbose )
            _verbose_check;
        ;;
        -h | --help )
            _help;
        ;;
        * )
            echo "unknown options: ${_options_[0]}";
        ;;
    esac
done