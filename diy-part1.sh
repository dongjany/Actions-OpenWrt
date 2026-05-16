#!/bin/sh

echo "====================================="
echo "  OpenWrt 24.10-SNAPSHOT 一键初始化脚本"
echo "  1. 同步官方 vermagic"
echo "  2. 卸载 lienol 源"
echo "  3. 添加 iStore 官方源"
echo "  4. 添加 NAS 插件源"
echo "====================================="

# ==========================
# 1. 同步官方 vermagic（适配官方 kmod）
# ==========================
wget -q https://downloads.openwrt.org/releases/24.10-SNAPSHOT/targets/armsr/armv8/profiles.json -O profiles.json
jq -r '.linux_kernel.vermagic' profiles.json > .vermagic
cat .vermagic
sed -i 's/^\(.\).*vermagic$/\1cp $(TOPDIR)\/.vermagic $(LINUX_DIR)\/.vermagic/' include/kernel-defaults.mk
rm -f profiles.json

# ==========================
# 2. 删除 lienol 源
# ==========================
sed -i '/src-git lienol/d' feeds.conf.default

# ==========================
# 3. 添加 iStore + NAS 源
# ==========================
echo '' >> feeds.conf.default
echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default

echo ""
echo "====================================="
echo " ✅ 全部执行完成！"
echo " ✅ 官方 kmod 兼容已开启"
echo " ✅ iStore 商店已添加"
echo " ✅ NAS 工具已添加"
echo "====================================="
echo ""
echo "接下来执行："
echo "./scripts/feeds update -a && ./scripts/feeds install -a"
echo ""
