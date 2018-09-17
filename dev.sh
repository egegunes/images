#!/bin/bash

set -e

CONTAINER=$(buildah from fedora)
NAME=dev

buildah config --label maintainer="Ege Gunes <egegunes@gmail.com>" $CONTAINER

buildah run $CONTAINER -- dnf update -y
buildah run $CONTAINER -- dnf install -y vim git fzf make
buildah run $CONTAINER -- dnf clean all
buildah run $CONTAINER -- useradd -Ums /bin/bash egegunes

buildah config --user egegunes $CONTAINER
buildah run $CONTAINER -- git clone https://github.com/egegunes/dotfiles.git /home/egegunes/.dotfiles

buildah config --workingdir /home/egegunes/.dotfiles $CONTAINER
buildah run $CONTAINER -- git clone https://github.com/VundleVim/Vundle.vim.git /home/egegunes/.vim/bundle/Vundle.vim
buildah run $CONTAINER -- make all
buildah run $CONTAINER -- vim -E -s -c "source /home/egegunes/.vim/vimrc" -c PluginInstall -c qa

buildah config --workingdir /home/egegunes/ $CONTAINER
buildah copy $CONTAINER /home/egegunes/.ssh/ /home/egegunes/.ssh

buildah config --entrypoint /bin/bash $CONTAINER

buildah commit $CONTAINER $NAME
