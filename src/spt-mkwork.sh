#!/bin/bash

if [ "$spt_debug" = yes ]; then {
    export spt_lib_path=/Users/scetayh/Documents/repo/spt/lib
}
else {
    export spt_lib_path=/usr/local/lib/spt
} fi

. "$spt_lib_path"/libsptchkv.sh

function printUsage () {
    printf "Usage: spt-mkwork -t TITLE -d DATE [-D] WORK\n"
}

# 初始化变量
work_title=""
work_date=""
work_date_cover="no"
work=""

# 解析选项
while getopts ":t:d:a:l:DAL" opt; do
  case $opt in
    t)
        work_title="$OPTARG"
        ;;
    d)
        work_date="$OPTARG"
        ;;
    D)
        work_date_cover="yes"
        ;;
    :)
        #echo "错误：选项 -$OPTARG 需要一个参数。" >&2
        printUsage >&2
        exit 1
        ;;
    ?)
        #echo "错误：无效选项 -$OPTARG" >&2
        printUsage >&2
        exit 1
        ;;
  esac
done

# 检查必须选项是否存在
if [[ -z "$work_title" || -z "$work_date" ]]; then
    printUsage >&2
    #echo "错误：必须提供选项 -t, -d, -a, -l。" >&2
    exit 1
fi

# 处理非选项参数
shift $((OPTIND - 1))
if [ $# -ne 1 ]; then
    #echo "错误：必须有且只有一个非选项参数。" >&2
    printUsage >&2
    exit 1
fi
work="$1"

if ! sptchkv.isValidObjName "$work"; then {
    printUsage >&2
    exit 1
} fi

if ! sptchkv.isValidDate "$work_date"; then {
    printUsage >&2
    exit 1
} fi

# 输出结果
echo "work=$work"
echo "work_title=$work_title"
echo "work_year=${work_date:0:4}"
echo "work_month=${work_date:4:2}"
echo "work_day=${work_date:6:2}"
echo "work_date_cover=$work_date_cover"