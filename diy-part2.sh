#!/bin/bash

git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
git clone https://github.com/sbwml/luci-app-ramfree.git package/luci-app-ramfree

# 克隆整个仓库 → 移动目标目录 → 删除仓库
git_clone_move() {
    local branch="$1"
    local repo="$2"
    local target_dir="$3"

    echo "===== 克隆仓库 $repo ====="
    git clone -b "$branch" --single-branch --depth 1 "$repo" temp_repo

    echo "===== 移动 $target_dir 到 package/ ====="
    mv -f temp_repo/$target_dir package/

    echo "===== 删除临时仓库 ====="
    rm -rf temp_repo

    echo "===== 完成！文件已放置在 package/$target_dir ====="
}

# 执行下载 + 移动 + 删除
git_clone_move main https://github.com/kiddin9/op-packages luci-app-turboacc
git_clone_move main https://github.com/Lienol/openwrt-package other/lean/ddns-scripts_aliyun
git_clone_move main https://github.com/Lienol/openwrt-package other/lean/ddns-scripts_dnspod
