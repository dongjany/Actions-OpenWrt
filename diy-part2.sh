sed -i 's/src-git lienol https:\/\/github.com\/Lienol\/openwrt-package.git;main/src-git kiddin9 https:\/\/github.com\/kiddin9\/op-packages.git;main/g' feeds.conf.default

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
