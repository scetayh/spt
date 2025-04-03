#!/bin/bash

# 初始化变量
export log_{debug,info,warn,error,fatal}_num=0

function log.static () {
    [ $# -ne 0 ] && return 255

    printf "%s warning(s), %s error(s) and %s fatal error(s) generated.\n" "$log_warn_num" "$log_error_num" "$log_fatal_num"
}

function log.fatalGenerated () {
    [ $# -ne 0 ] && return 255

    if [ "$log_fatal_num" -ne 0 ]; then {
        return 0
    }
    else {
        return 1
    } fi
}

function log.generate () {
    [ $# -ne 2 ] && return 255

    local level="$1"
    local message="$2"

    case "$level" in
        "debug" )   color="\e[90m"      ; ((log_debug_num+=1))   ;;
        "info"  )   color="\e[32m"      ; ((log_info_num+=1))    ;;
        "warn"  )   color="\e[33m"      ; ((log_warn_num+=1))    ;;
        "error" )   color="\e[31m"      ; ((log_error_num+=1))   ;;
        "fatal" )   color="\e[41;37;1m" ; ((log_fatal_num+=1))   ;;
        *       )   return 254;;
    esac

    printf "${color}%s: \e[0m%s\n" "$level" "$message"
}