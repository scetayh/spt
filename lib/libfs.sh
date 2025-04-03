#!/bin/bash

function fs.getAbsPath () {
    [ $# -ne 1 ] && return 255
    [ -z "$1" ] && return 254

    local path="$1"
    local combined_path

    # 判断是否为绝对路径
    if [[ "$path" = /* ]]; then
        combined_path="$path"
    else
        combined_path="$PWD/$path"
    fi

    # 将路径拆分为数组
    IFS='/' read -ra parts <<< "$combined_path"

    local result=()
    for part in "${parts[@]}"; do
        if [[ "$part" == "." || "$part" == "" ]]; then
            continue  # 忽略当前目录和空部分
        elif [[ "$part" == ".." ]]; then
            # 处理上级目录，弹出结果数组的最后一个元素（如果存在）
            if (( ${#result[@]} > 0 )); then
                result=("${result[@]:0:${#result[@]}-1}")
            fi
        else
            result+=("$part")  # 添加有效目录部分
        fi
    done

    # 构造最终路径
    if (( ${#result[@]} == 0 )); then
        printf "/\n"
    else
        printf "/%s" "${result[@]}"
        printf "\n"
    fi
}

function fs.createDirectory () {
    [ $# -ne 1 ] && return 255
    [ -z "$1" ] && return 254

    local dir="$(fs.getAbsPath "$1")"
    local parent_dir="$(dirname "$dir")"

    [ ! -d "$parent_dir" ] && return 253
    [ ! -r "$parent_dir" ] && return 252
    [ ! -w "$parent_dir" ] && return 251

    [ -e "$dir" ] && return 250

    [ ! -f "$(which mkdir)" ] && return 249

    mkdir "$dir" 2&> /dev/null
}

function fs.createFile () {
    [ $# -ne 1 ] && return 255
    [ -z "$1" ] && return 254

    local file="$(fs.getAbsPath "$1")"
    local parent_dir="$(dirname "$file")"

    [ ! -d "$parent_dir" ] && return 253
    [ ! -r "$parent_dir" ] && return 252
    [ ! -w "$parent_dir" ] && return 251

    [ -e "$file" ] && return 250

    [ ! -f "$(which touch)" ] && return 249

    touch "$file" 2&> /dev/null
}