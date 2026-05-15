#!/bin/bash
# OpenWrt 自动清理 defconfig 报错：Makefile错误、依赖缺失、递归依赖
set -uo pipefail

LOG="build_error.log"
rm -f $LOG

echo "===== 开始自动修复 defconfig 报错 ====="

while true; do
    echo -e "\n==> 执行 make defconfig..."
    make defconfig > $LOG 2>&1

    # 如果成功，直接退出
    if grep -q "configuration written to .config" $LOG; then
        echo -e "\n✅ defconfig 执行成功！所有坏包已清理完毕！"
        break
    fi

    echo -e "\n❌ 检测到错误，开始自动清理..."

    # ==============================================
    # 规则1：清理 Makefile 报错的包（ERROR: please fix package/...）
    # ==============================================
    BAD_PACKAGES=$(grep -E "ERROR: please fix package/" $LOG | \
        sed -E 's#.*package/(.*/)?([^/]+)/Makefile.*#\2#' | sort -u)

    # ==============================================
    # 规则2：清理依赖缺失的包（dependency on xxx which does not exist）
    # ==============================================
    BAD_PACKAGES+=$(grep -E "has a dependency on.*does not exist" $LOG | \
        sed -E "s#.*Makefile.*##" | \
        sed -E 's/.* ([^ ]+)\/Makefile.*/\1/' | sort -u)

    # ==============================================
    # 规则3：清理递归依赖坏包（recursive dependency detected）
    # ==============================================
    BAD_PACKAGES+=$(grep -A5 "recursive dependency detected" $LOG | \
        grep -E "symbol PACKAGE_" | \
        sed -E 's/.*PACKAGE_([^ ]+).*/\1/' | sort -u)

    # 去重
    BAD_PACKAGES=$(echo "$BAD_PACKAGES" | tr ' ' '\n' | sort -u | grep -v '^$')

    if [ -z "$BAD_PACKAGES" ]; then
        echo -e "\n⚠️  未识别到错误包，手动查看日志：$LOG"
        cat $LOG
        exit 1
    fi

    echo -e "\n🛑 将要禁用的坏包列表："
    echo "$BAD_PACKAGES"

    # ==============================================
    # 批量禁用包（.config 里注释）
    # ==============================================
    for pkg in $BAD_PACKAGES; do
        sed -i '/CONFIG_PACKAGE_'"$pkg"'=y/c\# CONFIG_PACKAGE_'"$pkg"' is not set' .config
        sed -i '/CONFIG_PACKAGE_'"$pkg"'=m/c\# CONFIG_PACKAGE_'"$pkg"' is not set' .config
        sed -i '/CONFIG_'"$pkg"'=y/c\# CONFIG_'"$pkg"' is not set' .config
    done

    echo -e "\� 已禁用所有坏包，重试..."
done

echo -e "\n🎉 全部完成！可以继续 make menuconfig / make -j$(nproc)"
