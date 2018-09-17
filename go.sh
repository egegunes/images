#!/bin/bash

set -e

CONTAINER=$(buildah from dev)
NAME=go-dev

buildah config --user root $CONTAINER

buildah run $CONTAINER -- dnf install -y golang

buildah config --user egegunes $CONTAINER

buildah commit $CONTAINER $NAME
