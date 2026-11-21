#!/bin/sh
# Reuse a pinned zsdcc source archive already in the tree.
# Usage: ensure-src-tarball.sh <tarball> <shafile> <url>
# A missing hash, or a failed download when a copy is already present,
# keeps that copy and prints a warning. The sum is read only when the
# hash file exists and has a value.

set -u

tarball=$1
shafile=$2
url=$3
partial=$tarball.partial

sum() {
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$1" | awk '{ print $1 }'
    else
        shasum -a 256 "$1" | awk '{ print $1 }'
    fi
}

fetch() {
    rm -f "$partial"
    if curl -fL "$url" -o "$partial"; then
        return 0
    fi
    rm -f "$partial"
    return 1
}

if [ ! -f "$shafile" ] || [ ! -s "$shafile" ]; then
    if [ -f "$tarball" ]; then
        echo "warning: $shafile is missing; using existing $tarball"
        exit 0
    fi
    echo "warning: $shafile is missing; downloading $tarball unchecked"
    if fetch; then
        mv "$partial" "$tarball"
        exit 0
    fi
    echo "error: $tarball is absent and the download failed"
    exit 1
fi

want=$(awk 'NR==1 { print $1; exit }' "$shafile")
if [ -z "$want" ]; then
    if [ -f "$tarball" ]; then
        echo "warning: $shafile is missing; using existing $tarball"
        exit 0
    fi
    echo "warning: $shafile is missing; downloading $tarball unchecked"
    if fetch; then
        mv "$partial" "$tarball"
        exit 0
    fi
    echo "error: $tarball is absent and the download failed"
    exit 1
fi

if [ -f "$tarball" ] && [ "$(sum "$tarball")" = "$want" ]; then
    echo "$tarball matches $shafile"
    exit 0
fi

echo "fetching $tarball"
if fetch; then
    got=$(sum "$partial")
    if [ "$got" = "$want" ]; then
        mv "$partial" "$tarball"
        exit 0
    fi
    rm -f "$partial"
    echo "error: downloaded $tarball does not match $shafile"
    exit 1
fi

if [ -f "$tarball" ]; then
    echo "warning: cannot download $tarball; using existing file"
    exit 0
fi

echo "error: $tarball is absent and the download failed"
exit 1
