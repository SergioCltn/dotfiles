#!/usr/bin/env bash

set -e 

check_go_version() {
    local version

    if command -v go &> /dev/null; then
        version=$(go version 2>/dev/null | awk '{print $3}')
    else
        echo "not installed."
        return 0  
    fi

    echo "$version"
}

install_go() {
    local os="$1"
    local release="$2"
    local release_file="$3"
    local install_dir="$4"

    echo "Downloading https://go.dev/dl/$release_file ..."
    curl -OL "https://go.dev/dl/$release_file"

    ## TODO: Add path to go installation and handle different versions
    sudo rm -rf /usr/local/go || true
    sudo tar -C /usr/local -xzf "$release_file"
    ln -sf "/usr/local/$release" "/usr/local/go"
}

version=$(check_go_version)
release=$(wget -qO- "https://golang.org/VERSION?m=text" | sed 's/time.*//')

if [[ $version == "$release" ]]; then
    echo "The local Go version ${release} is up-to-date."
    exit 0
else
    echo "The local Go version is ${version}. A new release ${release} is available."
fi

OS=$(uname)
release_file=""
## This install_dir is for when the path of go is not the default
install_dir="${HOME}/apps"

if [[ "$OS" == "Linux" ]]; then
    echo "You are using Linux."
    release_file="${release}.linux-amd64.tar.gz"
elif [[ "$OS" == "Darwin" ]]; then
    echo "You are using macOS."
    release_file="${release}.darwin-arm64.tar.gz"
else
    echo "Unknown operating system: $OS"
    exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT  

cd "$tmp"
install_go "$OS" "$release" "$release_file" "$install_dir"

version=$(check_go_version)
echo "Now, local Go version is $version"
