#!/bin/bash

git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
git clone https://github.com/sbwml/luci-app-ramfree.git package/luci-app-ramfree

curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh

mkdir -p package/ddns-scripts_aliyun
mkdir -p package/ddns-scripts_dnspod

# 下载 aliyun
wget https://raw.githubusercontent.com/Lienol/openwrt-package/main/other/lean/ddns-scripts_aliyun/Makefile -P package/ddns-scripts_aliyun/
wget https://raw.githubusercontent.com/Lienol/openwrt-package/main/other/lean/ddns-scripts_aliyun/aliyun.com.json -P package/ddns-scripts_aliyun/
wget https://raw.githubusercontent.com/Lienol/openwrt-package/main/other/lean/ddns-scripts_aliyun/update_aliyun_com.sh -P package/ddns-scripts_aliyun/

# 下载 dnspod
wget https://raw.githubusercontent.com/Lienol/openwrt-package/main/other/lean/ddns-scripts_dnspod/Makefile -P package/ddns-scripts_dnspod/
wget https://raw.githubusercontent.com/Lienol/openwrt-package/main/other/lean/ddns-scripts_dnspod/dnspod.cn.json -P package/ddns-scripts_dnspod/
wget https://raw.githubusercontent.com/Lienol/openwrt-package/main/other/lean/ddns-scripts_dnspod/dnspod.com.json -P package/ddns-scripts_dnspod/
wget https://raw.githubusercontent.com/Lienol/openwrt-package/main/other/lean/ddns-scripts_dnspod/update_dnspod_cn.sh -P package/ddns-scripts_dnspod/
wget https://raw.githubusercontent.com/Lienol/openwrt-package/main/other/lean/ddns-scripts_dnspod/update_dnspod_com.sh -P package/ddns-scripts_dnspod/
