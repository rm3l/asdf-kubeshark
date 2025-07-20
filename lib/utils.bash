#!/usr/bin/env bash

set -euo pipefail

# Ensure this is the correct GitHub homepage where releases can be downloaded for kubeshark.
GH_REPO="https://github.com/kubeshark/kubeshark"
TOOL_NAME="kubeshark"
TOOL_TEST="kubeshark version"

ansi() {
	if [ -n "$TERM" ]; then
		# see if terminal supports colors...
		local ncolors=$(tput colors)
		if test -n "$ncolors" && test $ncolors -ge 8; then
			echo -e "\e[${1}m${*:2}\e[0m"
		else
			echo -e ${*:2}
		fi
	else
		echo -e ${*:2}
	fi
}

bold() {
	ansi 1 "$@"
}

italic() {
	ansi 3 "$@"
}

strikethrough() {
	ansi 9 "$@"
}

underline() {
	ansi 4 "$@"
}

blue() {
	ansi 34 "$@"
}

red() {
	ansi 31 "$@"
}

fail() {
	red "asdf-$TOOL_NAME: $*"
	exit 1
}

uname_os() {
	os=$(uname -s | tr '[:upper:]' '[:lower:]')

	case "$os" in
	msys* | cygwin* | mingw*)
		os='windows'
		;;
	esac

	echo "$os"
}

uname_arch() {
	arch=$(uname -m)
	case $arch in
	x86_64) arch="amd64" ;;
	x86 | i686 | i386) arch="386" ;;
	aarch64) arch="arm64" ;;
	armv5*) arch="armv5" ;;
	armv6*) arch="armv6" ;;
	armv7*) arch="armv7" ;;
	esac
	echo "$arch"
}

curl_opts=(-fsSL -A "\"asdf-$TOOL_NAME ($(uname_os)/$(uname_arch))\"")

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- | grep -v stable | grep -v v0.0.1 | grep -v 'v72.3.83' |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# By default we simply list the tag names from GitHub releases.
	# Change this function if kubeshark has other means of determining installable versions.
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	# Adapt the release URL convention for kubeshark
	local versionMajor versionDl
	versionMajor=$(echo "$version" | cut -d'.' -f1)
	versionDl=${version}
	if [[ "$versionMajor" -gt "50" ]]; then
		versionDl="v${version}"
	fi
	url="$GH_REPO/releases/download/${versionDl}/${TOOL_NAME}_$(uname_os)_$(uname_arch)"
	if [[ "$(uname_os)" == "windows" ]]; then
		url="$GH_REPO/releases/download/${versionDl}/${TOOL_NAME}.exe"
	fi

	echo "* Downloading $TOOL_NAME release $version to $filename..."
	set -x
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -vr "$ASDF_DOWNLOAD_PATH"/$TOOL_NAME "$install_path/$TOOL_NAME"

		# Assert kubeshark executable exists
		test -x "$install_path/$TOOL_NAME" || fail "Expected $install_path/$TOOL_NAME to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
