#!/bin/sh

# 设置默认后台 IP
default_ip="192.168.1.1"

# 如果传入了合法IP，替换默认IP
if [ -n "$1" ] && [ "$1" != "$default_ip" ]; then
    echo "Modify default IP address to: $1"
    sed -i "/lan) ipad=\${ipaddr:-/s/\${ipaddr:-\"[^\"]*\"}/\${ipaddr:-\"$1\"}/" package/base-files/files/bin/config_generate
fi

# 修改默认主题为 argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci-light/Makefile

# 修改主机名
sed -i 's/OpenWrt/iStoreOS/g' package/base-files/files/bin/config_generate

# 替换默认终端为 bash
sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# 设置默认密码为 password
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# 添加版本信息
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCEREPO='github.com/Lienol/openwrt'" >> package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='Lienol'" >> package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCEBRANCH='24.10'" >> package/base-files/files/etc/openwrt_release

# 配置编译加速 ccache
sed -i '/CONFIG_DEVEL/d' .config
sed -i '/CONFIG_CCACHE/d' .config

if [ "$2" = "true" ]; then
    echo "CONFIG_DEVEL=y" >> .config
    echo "CONFIG_CCACHE=y" >> .config
    echo 'CONFIG_CCACHE_DIR="$(TOPDIR)/.ccache"' >> .config
else
    echo "# CONFIG_DEVEL is not set" >> .config
    echo "# CONFIG_CCACHE is not set" >> .config
    echo 'CONFIG_CCACHE_DIR=""' >> .config
fi
