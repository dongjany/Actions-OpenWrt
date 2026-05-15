#!/bin/bash

# OpenWrt 三合一脚本：自动去重lienol/kiddin9 + 自动修复defconfig报错
set -uo pipefail

# ===================== 第一部分：自动删除 lienol 与 kiddin9 重复包 =====================
FEED_LIENOL="feeds/lienol"
FEED_KIDDIN9="feeds/kiddin9"

echo "====================================="
echo "  第一步：自动删除 lienol <-> kiddin9 重复软件包"
echo "  保留：kiddin9  |  删除：lienol 同名包"
echo "====================================="

if [ -d "$FEED_LIENOL" ] && [ -d "$FEED_KIDDIN9" ]; then
    ls -1 $FEED_KIDDIN9 | sort > /tmp/kiddin9_list.txt
    ls -1 $FEED_LIENOL | sort > /tmp/lienol_list.txt
    DUP=$(comm -12 /tmp/kiddin9_list.txt /tmp/lienol_list.txt 2>/dev/null)

    if [ -n "$DUP" ]; then
        echo "🛑 发现重复包，开始删除..."
        for pkg in $DUP; do
            rm -rf "$FEED_LIENOL/$pkg"
            echo "🗑️  已删除：lienol/$pkg"
        done
    else
        echo "✅ 无重复包，跳过"
    fi
else
    echo "⚠️  未找到 lienol 或 kiddin9 源，跳过去重"
fi

# ===================== 第二部分：自动修复 defconfig 报错 =====================
LOG="build_error.log"
rm -f $LOG

echo -e "\n====================================="
echo "  第二步：自动修复 defconfig 报错"
echo "====================================="

while true; do
    echo -e "\n==> 执行 make defconfig..."
    make defconfig > $LOG 2>&1

    if grep -q "configuration written to .config" $LOG; then
        echo -e "\n✅ defconfig 执行成功！"
        break
    fi

    echo -e "\n❌ 检测到错误，开始清理..."

    # 规则1：清理 Makefile 错误
    BAD_PACKAGES=$(grep -E "ERROR: please fix package/" $LOG | \
        sed -E 's#.*package/(.*/)?([^/]+)/Makefile.*#\2#' | sort -u)

    # 规则2：清理依赖缺失
    BAD_PACKAGES+=$(grep -E "has a dependency on.*does not exist" $LOG | \
        sed -E 's/.* ([^ ]+)\/Makefile.*/\1/' | sort -u)

    # 规则3：清理递归依赖
    BAD_PACKAGES+=$(grep -A5 "recursive dependency detected" $LOG | \
        grep -E "symbol PACKAGE_" | \
        sed -E 's/.*PACKAGE_([^ ]+).*/\1/' | sort -u)

    # 去重
    BAD_PACKAGES=$(echo "$BAD_PACKAGES" | tr ' ' '\n' | sort -u | grep -v '^$')

    if [ -z "$BAD_PACKAGES" ]; then
        echo -e "\n⚠️  无法识别错误，查看日志：$LOG"
        cat $LOG
        exit 1
    fi

    echo -e "\n🛑 将要禁用的坏包："
    echo "$BAD_PACKAGES"

    # 批量禁用
    for pkg in $BAD_PACKAGES; do
        sed -i "/CONFIG_PACKAGE_${pkg}=y/c\\# CONFIG_PACKAGE_${pkg} is not set" .config 2>/dev/null
        sed -i "/CONFIG_PACKAGE_${pkg}=m/c\\# CONFIG_PACKAGE_${pkg} is not set" .config 2>/dev/null
        sed -i "/CONFIG_${pkg}=y/c\\# CONFIG_${pkg} is not set" .config 2>/dev/null
    done

    echo -e "\n🔧 已禁用，重新尝试..."
done

echo -e "\n🎉🎉🎉 全部完成！"
echo "现在可以执行：make menuconfig 或 make -j$(nproc)"
