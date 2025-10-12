#!/usr/bin/env bash

TARGET_TRIPLET="${1:?Please provide a target triplet as the first argument, e.g., aarch64-unknown-linux-gnu.}"
REPOSITORY_ROOT="${2:-refvalue}"
VERSION="${3:-latest}"

docker build --build-arg TARGET_TRIPLET="$TARGET_TRIPLET" -t "$REPOSITORY_ROOT/toolchain-$TARGET_TRIPLET:$VERSION" ./docker
