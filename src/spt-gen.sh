#!/bin/bash

# set -e
set -x

if [ ! -d src ]; then {
    printf "这个目录看起来并不是SPT目录"
    exit 1
} fi

# 对于src/下每一项
for work_dir in src/*; do {
    # 格式化这些项
    declare work
    work="$(basename $work_dir)"

    # 如果是work
    if . "src/$work/work.conf" 2> /dev/null; then {
        # 创建work的对应obj目录
        mkdir -p "obj/work/$work"

        # 写入work的对应obj配置
        touch "obj/work/$work/work.conf"
        printf 'work_title="%s"'"\\n" "$work_title" >> "obj/work/$work/work.conf"

        # 对于src/$work/下每一项
        for art_dir in src/$work/*; do {
            #格式化这些项
            declare art
            art="$(basename $art_dir)"

            #如果是art
            if . "src/$work/$art/art.conf" 2> /dev/null; then {
                # 创建art的对应obj目录
                mkdir -p "obj/work/$work/$art.art/"

                # 写入art的对应obj配置
                touch "obj/work/$work/$art.art/art.conf"
                {
                    printf 'art_title="%s"'"\\n"    "$art_title"
                    printf 'art_year="%s"'"\\n"     "${art_date:0:4}"
                    printf 'art_month="%s"'"\\n"    "${art_date:4:2}"
                    printf 'art_day="%s"'"\\n"      "${art_date:6:2}"
                    printf 'include_list="%s"'"\\n" "${include_list}"
                } >> "obj/work/$work/$art.art/art.conf"

                # 创建art的对应obj date索引
                mkdir -p "obj/date/${art_date:0:4}/${art_date:4:2}/${art_date:6:2}/$work/$art"
            } fi
        } done
    } fi
} done

# 写入obj work索引页面
mkdir -p build/work
touch build/work/index.md
{
    printf '### **作品索引**'"\\n"
    printf "\\n"
    for work_dir in obj/work/*; do {
        declare work
        work="$(basename $work_dir)"

        . "obj/work/$work/work.conf"

        printf -- '- [%s](%s)'"\\n" "$work_title" "$work"
    } done
    printf "\\n"
} >> build/work/index.md

# 对于每一个obj work
for work_dir in obj/work/*; do {
    ## obj work本身

    # 格式化这些obj work
    declare work
    work="$(basename $work_dir)"

    # 读取obj work配置
    . "obj/work/$work/work.conf"

    # 创建obj work对应的build work目录
    mkdir -p "build/work/$work"

    # 写入obj work对应的页面
    touch "build/work/$work/index.md"
    {
        printf '### **%s**'"\\n" "$work_title"
        printf "\\n"
        for art_dir in obj/work/$work/*.art; do {
            declare art_dir_basename
            art_dir_basename="$(basename $art_dir)"
            declare art
            art=${art_dir_basename%.*}

            . "obj/work/$work/$art.art/art.conf"

            printf -- '- [%s](%s)'"\\n" "$art_title" "$art"
        } done
    } >> "build/work/$work/index.md"

    ## obj work下的obj art

    # 对于每一个obj art
    for art_dir in obj/work/$work/*.art; do {
        # 格式化这些obj art
        declare art_dir_basename
        art_dir_basename="$(basename $art_dir)"
        declare art
        art=${art_dir_basename%.*}

        # 读取obj art配置
        . "obj/work/$work/$art.art/art.conf"

        # 创建obj work对应的build work目录
        mkdir -p "build/work/$work/$art/"

        # 写入obj art对应的页面
        if [ ! -f "src/$work/$art/index.md" ]; then {
            touch "build/work/$work/$art/index.md"
            {
                printf '### **%s**'"\\n"    "$art_title"
                printf "\\n"
                printf '**[%s](%s)**'"\\n"        "$work_title" ".."
                printf "\\n"
                printf '%s年%s月%s日'"\\n"  "$art_year" "$art_month" "$art_day"
                printf "\\n"
                for include in $include_list; do {
                    printf '![](%s)'"\\n"   "$include"
                    printf "\\n"
                } done
            } >> "build/work/$work/$art/index.md"
        } fi
        
        # 从src art目录中复制include到对应的build art目录中
        for include in $include_list; do {
            cp "src/$work/$art/$include" "build/work/$work/$art/"
        } done
    } done
} done

# 写入主页
touch build/index.md
{
    printf '<style>'"\\n"
    printf '    body {'"\\n"
    printf '        background: url("bg.jpeg") no-repeat center center fixed;'"\\n"
    printf '        -webkit-background-size: cover;'"\\n"
    printf '        -o-background-size: cover;'"\\n"
    printf '        background-size: cover;'"\\n"
    printf '}'"\\n"
    printf '</style>'"\\n"
    printf "\\n"
    printf '### **斯迪克平台 Sdick Platform(beta)**'"\\n"
    printf "\\n"
    printf '**Dickmates欢迎您完善迪克系列☆和我签订契约，成为~~大迪克~~答题卡吧！**'"\\n"
    printf "\\n"
    for year in $(ls -r obj/date); do {
        for month in $(ls -r "obj/date/$year"); do {
            {
                printf '#### %s年%s月'"\\n" "$year" "$month"
                printf "\\n"
            }

            for day in $(ls -r "obj/date/$year/$month"); do {
                for work_dir in obj/date/$year/$month/$day/*; do {
                    declare work
                    work=$(basename "$work_dir")

                    . "obj/work/$work/work.conf"

                    for art_dir in obj/date/$year/$month/$day/$work/*; do {
                        declare art
                        art=$(basename "$art_dir")

                        . "obj/work/$work/$art.art/art.conf"

                        {
                            printf -- '- （**%s日**）**[%s](%s)** *[%s](%s)*'"\\n" "$day" "$art_title" "work/$work/$art" "$work_title" "work/$work"
                        }
                    } done
                } done
            } done

            printf "\\n"
        } done
    } done

    printf -- '---'"\\n"
    printf "\\n"
    printf 'Dick Series © 2024 - 2025 by Dickmates'"\\n"
    printf "\\n"
} >> build/index.md
