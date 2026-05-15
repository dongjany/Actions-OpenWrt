#!/bin/bash
set -e

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

# ===================== 第二部分：自动删除 defconfig 报错的软件包（删源码） =====================
LOG="del_error.log"
rm -f $LOG

echo -e "\n========================================"
echo "  第二步：自动删除 defconfig 报错包（删目录）"
echo "  作用：直接删除 package/feeds/ 下坏包"
echo "========================================"

while true; do
    echo -e "\n→ 执行 make defconfig..."
    make defconfig > $LOG 2>&1

    if grep -q "configuration written to .config" $LOG; then
        echo -e "\n✅ defconfig 成功！无错误包需要删除"
        break
    fi

    echo -e "\n❌ 发现错误，开始提取要删除的包路径..."

    # 提取所有报错的包路径（精准匹配你日志）
    BAD_PATHS=$(grep -E "package/feeds/|package/public/|package/wwan/" $LOG | \
        grep -E "Makefile" | \
        sed -E 's/.*(package\/.*\/[^/]+)\/Makefile.*/\1/' | \
        sort -u)

    if [ -z "$BAD_PATHS" ]; then
        echo -e "\n⚠️  未找到可删除的包，错误日志："
        cat $LOG
        exit 1
    fi

    echo -e "\n🗑️  即将删除以下报错软件包目录："
    echo "$BAD_PATHS"

    # 直接删除！
    for path in $BAD_PATHS; do
        if [ -d "$path" ] || [ -f "$path/Makefile" ]; then
            echo "删除：$path"
            rm -rf "$path"
        fi
    done

    echo -e "\n🔄 删除完成，重新测试 defconfig..."
done

echo -e "\n🎉🎉🎉 全部完成！"
echo "现在可以直接编译：make menuconfig || make -j$(nproc)"
