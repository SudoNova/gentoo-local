# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit acct-user

DESCRIPTION="User for NetworkManager Openvpn plugin (nm-openvpn)"
ACCT_USER_GROUPS=( nm-openvpn )
ACCT_USER_ID=320 # https://gitlab.freedesktop.org/2A4U/openvpn-switcher/-/blob/master/README.md#nmcli-prerequisites

acct-user_add_deps
