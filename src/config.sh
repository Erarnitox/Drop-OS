#!/bin/sh

export PROFILENAME="sigma"
export SYSNAME="Sigma Linux"
export ROOT_DIR="$(dirname -- "$(readlink -f -- "$0")")"
export CACHE_DIR="$ROOT_DIR/cache"
export SRC_DIR="$ROOT_DIR/src"
export MAX_THREADS="11"
export KERNEL_GIT="https://github.com/torvalds/linux"
export KERNEL_BRANCH="v6.8"
export KERNEL_DIR="$CACHE_DIR/linux"

echo "Config:"
echo " - PROFILENAME: $PROFILENAME"
echo " - SYSNAME: $SYSNAME"
echo " - ROOT_DIR: $ROOT_DIR"
echo " - CACHE_DIR: $CACHE_DIR"
echo " - SRC_DIR: $SRC_DIR"
echo " - KERNEL_GIT: $KERNEL_GIT"
echo " - KERNEL_BRANCH: $KERNEL_BRANCH"
echo " - KERNEL_DIR: $KERNEL_DIR"

mkdir -p "$CACHE_DIR"
