# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="Console version of StarDict"
HOMEPAGE="https://dushistov.github.io/sdcv/"
GIT_REPO="https://github.com/Dushistov/sdcv"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS=""

IUSE="+nls +readline"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="$GIT_REPO"
	inherit git-r3
else
	SRC_URI="$GIT_REPO/archive/v$PV.tar.gz"
fi

CMAKE_MIN_VERSION=3.5

DEPEND="
	>=dev-libs/glib-2.36
	sys-devel/gettext
	readline? ( sys-libs/readline )
	sys-libs/zlib
"
# Two below packages were not included in CMakeList
#virtual/libiconv
#virtual/libintl

src_configure() {
	local mycmakeargs=(
		$(use_with readline)
		$(use_enable nls)
	)
	echo $mycmakea
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	pwd
	if use nls; then
		cd "$BUILD_DIR"
		emake lang
	fi
}

remove_unwanted_locales() {
	einfo "Removing unneeded locales (not listed in locale -a)"
	local locales=( $(locale -a) )
	local directories=( $(find "$D" -type d | grep /usr/share/locale/ | grep -v LC_MESSAGES) )
	local remove=()
	for directory in ${directories[@]}; do
		for locale in ${locales[@]}; do
			echo "$directory" | grep -oP '[^/]+$' | grep -xsq "$locale"
			[ $? -eq 0 ] && continue 2
		done
	rm -rf "$directory"
	done
}

pkg_preinst() {
	remove_unwanted_locales
}
