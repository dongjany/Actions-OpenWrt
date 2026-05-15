#!/bin/sh

echo -n "2a67cc4ae7b7c1f0c3b665bec0c6f387" > vermagic

echo -e "\n正在修改 kernel-defaults.mk..."
sed -i 's/^grep .\+vermagic$/# &/' include/kernel-defaults.mk
sed -i '/^# grep/a\	cp $(TOPDIR)/vermagic $(LINUX_DIR)/.vermagic' include/kernel-defaults.mk

echo -e "\n正在修改 kernel Makefile..."
sed -i 's/^  STAMP_BUILT:=/# &/' package/kernel/linux/Makefile
sed -i '/^#  STAMP_BUILT/a\  STAMP_BUILT:=$(STAMP_BUILT)_$(shell cat $(LINUX_DIR)/.vermagic)' package/kernel/linux/Makefile

echo -e "\n正在添加 kiddin9 软件源到 feeds.conf.default..."
echo 'src-git kiddin9 https://github.com/kiddin9/op-packages.git;main' >> feeds.conf.default

echo -e "\n✅ 所有修改完成！"
