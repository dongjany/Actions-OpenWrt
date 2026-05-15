#!/bin/sh

echo -n "2a67cc4ae7b7c1f0c3b665bec0c6f387" > vermagic

sed -i 's/^grep .\+vermagic$/# &/' include/kernel-defaults.mk
sed -i '/^# grep/a\	cp $(TOPDIR)/vermagic $(LINUX_DIR)/.vermagic' include/kernel-defaults.mk

sed -i 's/^  STAMP_BUILT:=/# &/' package/kernel/linux/Makefile
sed -i '/^#  STAMP_BUILT/a\  STAMP_BUILT:=$(STAMP_BUILT)_$(shell cat $(LINUX_DIR)/.vermagic)' package/kernel/linux/Makefile
