#!/bin/bash

# set -e
set -x

if [ ! -d src ]; then {
    printf "这个目录看起来并不是SPT目录"
    exit 1
} fi

rm -rf obj/*
rm -rf build/*