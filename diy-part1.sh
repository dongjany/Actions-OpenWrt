#!/bin/sh

# 1. OpenWrt 分支
    REPO_BRANCH="24.10"

# 2. 内核主版本 6.6 
    KERNEL_MAJOR="6.6"

# 3. 拼接官方 kmods 基础 URL（armsr/armv8）
BASE_URL="https://downloads.openwrt.org/releases/$REPO_BRANCH-SNAPSHOT/targets/armsr/armv8/kmods/"

echo "分支: $REPO_BRANCH"
echo "内核主版本: $KERNEL_MAJOR"
echo "kmods 地址: $BASE_URL"

# 4. 先抓取最新内核完整版本号（如 6.6.121-1-xxx）
echo "正在获取最新内核版本目录..."
LATEST_DIR=$(wget -qO- "$BASE_URL" | grep -oE "${KERNEL_MAJOR}\.[0-9]+-1-[0-9a-f]{32}" | sort -V | tail -n1)

if [ -z "$LATEST_DIR" ]; then
    echo "未找到匹配的内核目录"
    exit 1
fi

echo "最新内核目录: $LATEST_DIR"

# 提取 6.6.121 部分（前面的版本号）
FULL_KERNEL_VER=$(echo "$LATEST_DIR" | cut -d'-' -f1)
# 提取 vermagic（最后的 32 位）
VERMAGIC=$(echo "$LATEST_DIR" | grep -oE '[0-9a-f]{32}')

echo "提取内核版本: $FULL_KERNEL_VER"
echo "提取 vermagic: $VERMAGIC"

# 5. 写入 vermagic 文件
echo -n "$VERMAGIC" > vermagic

echo -e "\n✅ 成功生成 vermagic："
cat vermagic
echo -e "\n文件位置：$(pwd)/vermagic"

# ===================== 自动修改编译配置 =====================
echo -e "\n正在修改 kernel-defaults.mk..."
sed -i 's/^grep .\+vermagic$/# &/' include/kernel-defaults.mk
sed -i '/^# grep/a\	cp $(TOPDIR)/vermagic $(LINUX_DIR)/.vermagic' include/kernel-defaults.mk

echo -e "\n正在修改 kernel Makefile..."
sed -i 's/^  STAMP_BUILT:=/# &/' package/kernel/linux/Makefile
sed -i '/^#  STAMP_BUILT/a\  STAMP_BUILT:=$(STAMP_BUILT)_$(shell cat $(LINUX_DIR)/.vermagic)' package/kernel/linux/Makefile

# 新增：向 feeds.conf.default 追加指定的源
echo -e "\n正在添加 kiddin9 软件源到 feeds.conf.default..."
echo 'src-git kiddin9 https://github.com/kiddin9/op-packages.git;main' >> feeds.conf.default

echo -e "\n✅ 所有修改完成！"
