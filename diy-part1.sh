#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Add a feed source
# echo 'src-git istore https://github.com/linkease/istore;main' >> feeds.conf.default
# echo 'src-git nas https://github.com/linkease/nas-packages.git;master' >> feeds.conf.default
# echo 'src-git nas_luci https://github.com/linkease/nas-packages-luci.git;main' >> feeds.conf.default
# curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
# git clone https://github.com/sbwml/luci-app-ramfree.git package/luci-app-ramfree
# git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
# git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic

# Remove unnecessary packages
# rm -rf package/utils/{ucode,fbtest}
