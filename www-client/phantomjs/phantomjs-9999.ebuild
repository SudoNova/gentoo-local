# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs pax-utils multiprocessing git-r3 qmake-utils

DESCRIPTION="A headless WebKit scriptable with a JavaScript API"
HOMEPAGE="http://phantomjs.org/"
EGIT_REPO_URI="https://github.com/ariya/${PN}"
EGIT_BRANCH="master"

LICENSE="BSD-3"
SLOT=$(ver_cut 1-3)
KEYWORDS=""
IUSE="examples test"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	dev-libs/glib
	>=dev-qt/qtcore-5.12:5
	>=dev-qt/qtgui-5.12:5
	>=dev-qt/qtnetwork-5.12:5
	>=dev-qt/qtwebkit-5.12:5
	>=dev-qt/qtwidgets-5.12:5
"
BDEPEND="
	dev-vcs/git
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {

	default
}

src_configure() {
	# unset CBUILD
	./configure \
		--prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share
#	make check
}
src_compile(){
	make
}

src_test() {
	./bin/phantomjs test/run-tests.js || die
}

src_install() {
	pax-mark m bin/phantomjs || die
	dobin bin/phantomjs
	dodoc ChangeLog README.md
	if use examples ; then
		docinto examples
		dodoc examples/*
	fi
}
