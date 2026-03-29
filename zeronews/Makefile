# SPDX-License-Identifier: GPL-3.0-only
#
# Copyright (C) 2023 ImmortalWrt.org

include $(TOPDIR)/rules.mk

PKG_NAME:=zeronews
PKG_VERSION:=3.0.3
PKG_RELEASE:=1

ifeq ($(ARCH),aarch64)
  PKG_ARCH:=arm64
else ifeq ($(ARCH),arm)
  PKG_ARCH:=arm
else ifeq ($(ARCH),mips)
  PKG_ARCH:=mips
else ifeq ($(ARCH),x86_64)
  PKG_ARCH:=x86_x64
endif

PKG_SOURCE:=zeronews
PKG_SOURCE_URL:=https://download.zeronews.cc/openwrt/$(PKG_ARCH)
PKG_HASH:=skip

PKG_BUILD_DIR:=$(BUILD_DIR)/zeronews

include $(INCLUDE_DIR)/package.mk

define Package/zeronews
  SECTION:=net
  CATEGORY:=Network
  TITLE:=ZeroNews Intranet Penetration
  DEPENDS:=@(aarch64||arm||mips||x86_64)
  URL:=https://zeronews.cc
endef

define Package/zeronews/description
  ZeroNews is an innovative edge cloud intranet penetration platform 
  designed to help users quickly address the security and fast access 
  needs between intranet and internet.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	cp $(DL_DIR)/$(PKG_SOURCE) $(PKG_BUILD_DIR)/zeronews
endef

define Build/Compile
endef

define Package/zeronews/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/zeronews $(1)/usr/bin/zeronews
endef

$(eval $(call BuildPackage,zeronews))