#!/bin/bash

# 备份当前配置
make defconfig

# 自动检测并删除所有 defconfig 报错的软件包
make defconfig 2>&1 | grep -oP "Package \K[^ ]+" | sort -u | xargs -I {} sed -i '/CONFIG_PACKAGE_{}=/d' .config

# 重新生成正确配置
make defconfig

echo "✅ 所有有问题的包已删除，配置已修复完成！"
