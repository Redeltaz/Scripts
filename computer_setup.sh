#!/bin/bash

install_dependencies () {
    apt update -y
    apt upgrade -y

    apt install -y \
        git \
        curl \
        vim \
        wget \
        gpg \
        zsh \
        python3-pip \
        gnome-tweaks \
        gnome-shell-extensions \
        terminator \
        neofetch \
        rofi \
        dconf-editor \
        dconf-cli \
        make \
        ca-certificates \
        gnupg \
        lsb-release

    # Install vscode
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    apt install -y apt-transport-https
    apt update -y
    apt install -y code

    mkdir ~/Applications
    git clone https://github.com/Redeltaz/Dotfiles

    # Setup zsh and p10k
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
    source ~/.zshrc
    cp ~/Applications/Dotfiles/config/p10k/.p10k.zsh ~/.p10k.zsh

    # Install docker and docker compose
    
}

setup_environnement () {
    # terminator
    mkdir -p ~/.config/terminator
    cp ~/Applications/Dotfiles/config/terminator/config ~/.config/terminator/config

    # rofi
    mkdir -p ~/.config/rofi
    cp ~/Applications/Dotfiles/config/rofi/config.rasi ~/.config/rofi


    # Gnome extensions
    # For the moment install by hand with firefox / google extension
    # maybe I will make it automate one day 
    dconf load / < ~/Applications/Dotfiles/config/dconf/extensions-settings.dconf
    cp -R ~/Applications/Dotfiles/themes/TokyoNight /usr/share/themes

    # neofetch
    cp ~/Applications/Dotfiles/config/neofetch/config.conf ~/.config/neofetch/config.conf
    cp ~/Applications/Dotfiles/config/neofetch/neofetch /usr/bin/neofetch

    # Pop shell
    npm install -g typescript
    git clone https://github.com/pop-os/shell
    cd ~/shell
    make local-install

    echo -e "alias python="python3"\nalias pip="pip3"\nalias dc="docker-compose"\nneofetch" >> ~/.zshrc    echo -e $text >> ~/.zshrc
}