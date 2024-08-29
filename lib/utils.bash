#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/tamasfe/taplo"
TOOL_NAME="taplo"
TOOL_TEST="taplo --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if taplo is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# Change this function if taplo has other means of determining installable versions.
	list_github_tags | grep 'release-taplo-cli-' | cut -d'-' -f4
}

get_platform() {
	local -r kernel="$(uname -s)"
	if [[ ${OSTYPE} == "msys" || ${kernel} == "CYGWIN"* || ${kernel} == "MINGW"* ]]; then
		echo windows
	else
		uname | tr '[:upper:]' '[:lower:]'
	fi
}

get_arch() {
	local -r machine="$(uname -m)"

	if [[ ${machine} == "arm64" ]] || [[ ${machine} == "aarch64" ]]; then
		echo "aarch64"
	elif [[ ${machine} == *"arm"* ]] || [[ ${machine} == *"aarch"* ]]; then
		echo "aarch"
	elif [[ ${machine} == *"386"* ]]; then
		echo "x86"
	else
		echo "x86_64"
	fi
}

get_release_file() {
	echo "${ASDF_DOWNLOAD_PATH}/${TOOL_NAME}-${ASDF_INSTALL_VERSION}.gz"
}

download_release() {
	local version filename url
	version="$1"
	local -r filename="$(get_release_file)"
	local -r platform="$(get_platform)"
	local -r arch="$(get_arch)"

	url="$GH_REPO/releases/download/${version}/${TOOL_NAME}-full-${platform}-${arch}.gz"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"

	pushd "$ASDF_DOWNLOAD_PATH" >/dev/null
	#  Extract contents of gz file into the download directory
	gunzip --decrompress "$filename" || fail "Could not extract $filename"
	popd >/dev/null

	# Remove the gz file since we don't need to keep it
	rm "$filename"
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
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
