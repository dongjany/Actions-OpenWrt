#!/bin/sh

# 克隆整个仓库 → 移动多个目标目录 → 删除仓库（干净无残留）
git_clone_move() {
    branch="$1"
    repo="$2"
    shift 2
    target_dirs="$@"

    echo "\n===== 克隆仓库 $repo ====="
    git clone -b "$branch" --single-branch --depth 1 "$repo" temp_repo

    # 循环移动所有目录
    for dir in $target_dirs; do
        echo "===== 移动 $dir 到 package/ ====="
        mv -f temp_repo/$dir package/
    done

    echo "===== 删除临时仓库 ====="
    rm -rf temp_repo

    echo "===== 完成！所有目录已移动到 package/ ====="
}

# ========== 直接 Git 克隆到 package ==========
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
git clone https://github.com/sbwml/luci-app-ramfree.git package/luci-app-ramfree

# ========== 一次克隆 → 移动多个目录 ==========
git_clone_move main https://github.com/kiddin9/op-packages luci-app-demon luci-app-xunlei luci-app-fan v2dat mosdns luci-app-mosdns luci-app-broadbandacc
git_clone_move main https://github.com/Lienol/openwrt-package other/lean/ddns-scripts_aliyun other/lean/ddns-scripts_dnspod
git_clone_move openwrt-24.10 https://github.com/immortalwrt/immortalwrt package/emortal/default-settings package/emortal/automount package/emortal/autocore

# ========== 添加luci-app-turboacc插件 ==========
rm -rf package/network/utils/fullconenat-nft
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh
sed -i 's|rm -rf "$file_path"|# 保留原有补丁，不删除|g' add_turboacc.sh
bash add_turboacc.sh

echo "\n✅ 所有插件下载完成！已全部放入 package 目录"
