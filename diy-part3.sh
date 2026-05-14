./scripts/feeds install -a 2> feeds_error.log && grep Makefile feeds_error.log | awk '{print $3}' | xargs rm -rf && ./scripts/feeds clean && ./scripts/feeds update -i && ./scripts/feeds install -a

# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-light/Makefile

# Modify hostname
sed -i 's/OpenWrt/iStoreOS/g' package/base-files/files/bin/config_generate

# 替换终端为bash
sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd
