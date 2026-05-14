#!/bin/sh

# 自动检测 OpenWrt 分支
if grep -q "24.10" version.openwrt 2>/dev/null || grep -q "24.10" .git/config 2>/dev/null; then
    REPO_BRANCH="24.10"
else
    REPO_BRANCH="25.12"
fi

# 自动检测内核版本 6.6 / 6.12
if ls include/kernel-6.6* 1>/dev/null 2>&1; then
    KERNEL_MAJOR="6.6"
elif ls target/linux/generic/kernel-6.12* 1>/dev/null 2>&1; then
    KERNEL_MAJOR="6.12"
else
    echo "无法识别内核版本"
    exit 1
fi

# 提取完整内核版本（如 6.6.137）
LINUX_VERSION=$(cat include/kernel-$KERNEL_MAJOR | grep "LINUX_VERSION-$KERNEL_MAJOR" | awk -F' = ' '{print $2}' | sed 's/^.//')
FULL_KERNEL_VER="$KERNEL_MAJOR$LINUX_VERSION"

# 拼接官方 kmods 地址
URL="https://downloads.openwrt.org/releases/$REPO_BRANCH-SNAPSHOT/targets/armsr/armv8/kmods/$FULL_KERNEL_VER-1-"

# 自动抓取 vermagic
echo "正在获取官方 vermagic..."
echo "官方地址前缀: $URL"
VERMAGIC=$(wget -qO- --spider $URL* 2>&1 | grep -oE '[0-9a-f]{32}' | head -n1)

# 写入文件
echo -n "$VERMAGIC" > vermagic

echo -e "\n✅ 成功生成 vermagic："
cat vermagic
echo -e "\n文件位置：$(pwd)/vermagic"

# ===================== 新增：自动修改编译配置 =====================
echo -e "\n正在修改 kernel-defaults.mk..."
sed -i 's/^grep .\+vermagic$/# &/' include/kernel-defaults.mk
sed -i '/^# grep/a\	cp $(TOPDIR)/vermagic $(LINUX_DIR)/.vermagic' include/kernel-defaults.mk

echo -e "\n正在修改 kernel Makefile..."
sed -i 's/^  STAMP_BUILT:=/# &/' package/kernel/linux/Makefile
sed -i '/^#  STAMP_BUILT/a\  STAMP_BUILT:=$(STAMP_BUILT)_$(shell cat $(LINUX_DIR)/.vermagic)' package/kernel/linux/Makefile

echo -e "\n✅ 所有修改完成！现在可以正常编译固件，兼容官方 kmod 源！"
