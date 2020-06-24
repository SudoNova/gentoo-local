# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson ninja-utils git-r3

EGIT_REPO_URI="https://github.com/Genymobile/${PN}.git"

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://blog.rom1v.com/2018/03/introducing-scrcpy/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

BDEPEND="dev-vcs/git"
COMMON_DEPEND="media-libs/libsdl2
	media-video/ffmpeg"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
PDEPEND=""
src_configure() {
MY_SERVER_PV="$(curl https://github.com/Genymobile/scrcpy/releases/latest -o /dev/null -w  %{url_effective} -sL | sed -r 's,(.*?)/tag/v(.*),\2,')"
MY_SERVER_PN="scrcpy-server"
MY_SERVER_P="${MY_SERVER_PN}-v${MY_SERVER_PV}"
curl -sL "https://github.com/Genymobile/scrcpy/releases/download/v${MY_SERVER_PV}/${MY_SERVER_P}" -o "${S}/${MY_SERVER_P}.jar"

	local emesonargs=(
		-Db_lto=true
		-Dprebuilt_server="${S}/${MY_SERVER_P}.jar"
	)
	meson_src_configure
}
