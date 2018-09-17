#!/bin/bash

set -e

CONTAINER=$(buildah from dev)
NAME=python-dev

buildah config --user root $CONTAINER

buildah run $CONTAINER -- dnf install -y python3-flake8 python3-isort python3-ipython python3-ipdb

buildah config --user egegunes $CONTAINER

buildah commit $CONTAINER $NAME
