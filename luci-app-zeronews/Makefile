include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-zeronews
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

LUCI_TITLE:=LuCI support for ZeroNews
LUCI_DEPENDS:=+zeronews
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

define Package/$(PKG_NAME)/conffiles
/etc/config/zeronews
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
chmod +x $${IPKG_INSTROOT}/etc/init.d/zeronews
exit 0
endef

# call BuildPackage - OpenWrt buildroot signature