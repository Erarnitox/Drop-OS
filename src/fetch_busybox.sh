#!/bin/sh

set -e

git clone --depth 1 -b "$BUSYBOX_BRANCH" "$BUSYBOX_GIT" "$BUSYBOX_DIR"
