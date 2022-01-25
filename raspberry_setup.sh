#!/bin/bash

# Script to setup basic stuff for raspbian based appliances (mostly all raspberry)
# It may work on Debian too but maybe it won't work lol
# This is not an automatic script, that's mean the script will stop to ask user things
# Some conf (like network) are specific to me, so you must change them if you want to use this script

manage_users () {
    # Remove default user and add a new one 
    adduser --gecos GECOS admin
    # https://passwordsgenerator.net/
    # 16 characters, symbols, numbers...

    usermod -aG sudo admin
    # exit session then reconnect as admin
    deluser -remove-home pi
    rm -rf /etc/sudoers.d/
}

manage_network () {
    #Change network info before running the script
    IP="192.168.11.69"
    NETMASK="255.255.255.0"
    GATEWAY="192.168.11.1"

    # Setup static ip
    chmod 777 /etc/network/interfaces
    text="auto eth0\niface eth0 inet static\naddress ${IP}\nnetmask ${NETMASk}\ngateway ${GATEWAY}"
    echo -e $text >> /etc/network/interfaces
    chmod 644 /etc/network/interfaces

    systemctl restart networking.service
}

manage_packages () {
    apt update -y
    apt upgrade -y

    #Installing basics packages and needed packages for docker / docker compose
    apt install -y \
        build-essential \
        git \
        curl \
        vim \
        wget \
        zsh \
        ca-certificates \
        gnupg \
        lsb-release \
        python3-pip

    # Set oh my zsh and change shell
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    
    # Install Docker and Docker-compose
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    apt update -y
    apt install -y docker-ce docker-ce-cli containerd.io
    systemctl enable docker
    systemctl start docker

    usermod -aG docker admin

    pip3 install docker-compose

    # Install Node
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install 16
    nvm use 16
}

manage_utils () {
    # Setup utils things
    text="alias python="python3"\nalias pip="pip3"\nalias dc="docker-compose""
    echo -e $text >> ~/.zshrc

    source ~/.zshrc
}

# Call functions
manage_users
manage_network
manage_packages
manage_utils