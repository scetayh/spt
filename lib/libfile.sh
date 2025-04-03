#!/bin/bash

function file.execCurrent () {
    [ $# -ne 1 ] && return 255
    [ -z "$1" ] && return 254

    [ ! -f "$1" ] && return 253
    [ ! -r "$1" ] && return 252
    [ ! -w "$1" ] && return 251

    . "$1" 2&> /dev/null
}