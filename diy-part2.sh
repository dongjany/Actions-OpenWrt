#!/bin/bash

# 克隆整个仓库 → 移动目标目录 → 删除仓库（干净无残留）
git_clone_move() {
    local branch="$1"
    local repo="$2"
    local target_dir="$3"

    echo -e "\n===== 克隆仓库 $repo ====="
    git clone -b "$branch" --single-branch --depth 1 "$repo" temp_repo

    echo "===== 移动 $target_dir 到 package/ ====="
    mv -f temp_repo/$target_dir package/

    echo "===== 删除临时仓库 ====="
    rm -rf temp_repo

    echo "===== 完成！package/$(basename $target_dir) 已就绪 ====="
}

# ========== 直接 Git 克隆到 package ==========
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
git clone https://github.com/sbwml/luci-app-ramfree.git package/luci-app-ramfree

# ========== Git 下载仓库 → 移动 → 删除 ==========
git_clone_move main https://github.com/kiddin9/op-packages luci-app-turboacc
git_clone_move main https://github.com/kiddin9/op-packages luci-app-demon
git_clone_move main https://github.com/kiddin9/op-packages luci-app-xunlei
git_clone_move main https://github.com/kiddin9/op-packages luci-app-fan
git_clone_move main https://github.com/kiddin9/op-packages mosdns
git_clone_move main https://github.com/kiddin9/op-packages luci-app-mosdns
git_clone_move main https://github.com/kiddin9/op-packages luci-app-broadbandacc
git_clone_move main https://github.com/Lienol/openwrt-package other/lean/ddns-scripts_aliyun
git_clone_move main https://github.com/Lienol/openwrt-package other/lean/ddns-scripts_dnspod

echo -e "\n✅ 所有插件下载完成！已全部放入 package 目录"
