#!/bin/bash

install_dependencies () {
    apt update -y
    apt upgrade -y

    apt install -y \
        git \
        curl \
        vim \
        wget \
        zsh \
        python3-pip \
        gnome-tweaks \
        gnome-shell-extensions \
        terminator
}

setup_environnement () {
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}