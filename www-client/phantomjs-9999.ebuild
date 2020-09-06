# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs pax-utils multiprocessing git-r3 qmake-utils

DESCRIPTION="A headless WebKit scriptable with a JavaScript API"
HOMEPAGE="http://phantomjs.org/"
EGIT_REPO_URI="https://github.com/ariya/${PN}"
LICENSE="BSD-3"
SLOT=0
KEYWORDS=""
IUSE="examples"

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype
	dev-libs/glib
	>=dev-qt/qtcore:5/5.12
	>=dev-qt/qtgui:5/5.12
	>=dev-qt/qtnetwork:5/5.12
	>=dev-qt/qtwebkit:5/5.12
	>=dev-qt/qtwidgets:5/5.12
	"
BDEPEND="
	dev-vcs/git
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
## Seems this is not the case anymore	# Vanilla QtWebkit:5 does not support WebSecurityEnabled in QWebSettings
#	sed -r \
#		-e '/QWebSettings::WebSecurityEnabled/d' \
#		-i src/webpage.cpp

	default
}

src_configure() {
	qmake5
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
