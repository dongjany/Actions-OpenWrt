#!/bin/bash

git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic

rm -rf package/feeds/lienol/other/lean/luci-app-turboacc
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh
