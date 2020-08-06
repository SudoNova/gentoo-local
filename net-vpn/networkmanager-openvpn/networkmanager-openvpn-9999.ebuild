# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2-utils git-r3

DESCRIPTION="NetworkManager OpenVPN plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="gtk glib test"
REQUIRED_USE="!glib" # This flag is still not working
RESTRICT="!test? ( test )"
EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/NetworkManager-openvpn"
RDEPEND="
	acct-user/nm-openvpn
	glib? ( >=dev-libs/glib-2.32:2 )
	>=net-misc/networkmanager-1.7.0:=
	>=net-vpn/openvpn-2.1
	gtk? (
		>=app-crypt/libsecret-0.18
		>=net-libs/libnma-1.7.0
		>=x11-libs/gtk+-3.4:3
		>=gnome-extra/nm-applet-1.7
	)
"

BDEPEND="
	>=sys-devel/automake-1.9
"

DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
"

src_prepare() {
	# Test will fail if the machine doesn't have a particular locale installed
	# FAIL: (tls-import-data) unexpected 'ca' secret value, upstream bug #742708
	sed '/test_non_utf8_import (plugin, test_dir)/ d' \
		-i properties/tests/test-import-export.c || die "sed failed"
	eapply_user
	eautoreconf
	elibtoolize

}

src_configure() {
	econf \
		--disable-more-warnings \
		--disable-static \
		--with-dist-version=Gentoo \
		$(use_with gtk gnome) \
		$(use_with glib libnm-glib)
}
src_install(){
	insinto /usr/src/debug/$CATEGORY/$PF/src/
	doins	src/*.c
	insinto /usr/src/debug/$CATEGORY/$PF/shared/
	doins shared/*.c
	doins shared/*.h
	insinto /usr/src/debug/$CATEGORY/$PF/shared/nm-utils
	doins shared/nm-utils/*.c
	doins shared/nm-utils/*.h
}

