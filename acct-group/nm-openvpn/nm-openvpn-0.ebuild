# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit acct-group

DESCRIPTION="Group for NetworkManager Openvpn plugin (nm-openvpn)"
ACCT_GROUP_ID=320 # https://gitlab.freedesktop.org/2A4U/openvpn-switcher/-/blob/master/README.md#nmcli-prerequisites
