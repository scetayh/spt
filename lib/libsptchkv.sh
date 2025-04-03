#!/bin/bash

function sptchkv.isValidDate() {
    local date_str="$1"

    # 1. 格式检查：必须是8位数字
    if [[ ! "$date_str" =~ ^[0-9]{8}$ ]]; then
        return 1  # 格式错误
    fi

    # 2. 分解年、月、日
    local year=${date_str:0:4}
    local month=${date_str:4:2}
    local day=${date_str:6:2}

    # 3. 检查月份是否有效（1-12）
    if ((10#$month < 1 || 10#$month > 12)); then
        return 1
    fi

    # 4. 检查日期是否有效
    # 计算该月最大天数
    local leap=0
    # 闰年判断：能被4整除但不能被100整除，或能被400整除
    if (( (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 )); then
        leap=1
    fi

    case "$month" in
        01|03|05|07|08|10|12) days=31 ;;  # 大月
        04|06|09|11)           days=30 ;;  # 小月
        02)                    days=$((28 + leap)) ;;  # 二月
    esac

    # 检查日期是否在有效范围内
    if ((10#$day < 1 || 10#$day > days)); then
        return 1
    fi

    # 所有检查通过
    return 0
}

function sptchkv.isValidObjName () {
    [[ "$1" =~ ^[a-z0-9_-]+$ ]]
}