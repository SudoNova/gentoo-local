# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="NetworkManager OpenVPN plugin"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="gtk glib test"
REQUIRED_USE="!glib" # This flag is still not working
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

WANT_AUTOMAKE="1.9"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	>=dev-util/intltool-0.35
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
	ln -s $S/config.log $T
}
src_install(){
	default_src_install
	if has installsources ${FEATURES}; then
		INTO_BASE=/usr/src/debug/$CATEGORY/$PF/
		insinto		$INTO_BASE/src/
		doins		$S/src/*.c
		insinto		$INTO_BASE/shared/
		doins -r	$S/shared/*.c $S/shared/*.h
		insinto		$INTO_BASE/shared/nm-utils
		doins -r	$S/shared/nm-utils/*.c $S/shared/nm-utils/*.h
	fi
}
