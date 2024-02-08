#!/bin/bash
detect_os() {
    case "$(command uname)" in
        'Darwin') OS="macos";;
        'Linux') OS="linux" ;;
    esac
}

detect_homebrew(){
    if [[ $(command -v brew) == "" ]]; then
        printf "Some of the following installations require Homebrew. Do you want to install it? "
        printf "Yes (y) , No (n) : "     
        read install_homebrew
        if [[ "$install_homebrew" == "y" ]]; then
            printf "Installing HomeBrew" 
            command /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            SKIP_DEPENDENT_COMPONENTS="y"
        fi
    fi
}
install_Kitty(){
    printf "Do you want to install \"Kitty\" shell? "
    printf "Yes (y) , No (n) : " 
    read installKitty
    if test "$installKitty" = "y"; then
        printf "Installing Kitty"
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
        command cp -r ./configuration_files/kitty/. ~/.config/kitty
    fi
}

install_Zsh_AutoSuggestions(){
    printf "Do you want to install \"zsh-autosuggestions\"? "
    printf "Yes (y) , No (n) : " 
    read install_zsh_autoSuggestions
    # zsh-autosuggestions
    if [[ "$install_zsh_autoSuggestions" == "y" && ! -d ~/.zsh/zsh-autosuggestions ]]; then
        echo "Installing zsh-autosuggestions"
        command git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
    fi
}

install_Zsh_Asyntax_Highlighting(){
    printf "Do you want to install \"zsh-syntax-highlighting\"? "
    printf "Yes (y) , No (n) : " 
    read install_zsh_syntax_highlighting
    # zsh-syntax-highlighting
    if [[ "$install_zsh_syntax_highlighting" == "y" && ! -d ~/.zsh/zsh-syntax-highlighting ]]; then
        echo "Installing zsh-syntax-highlighting"
        command git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
    fi
}

install_Zsh_Sudo(){
    printf "Do you want to install \"zsh-sudo\"? "
    printf "Yes (y) , No (n) : " 
    read install_zsh_sudo
    # zsh-syntax-highlighting
    if [[ "$install_zsh_sudo" == "y" && ! -e ~/.zsh/zsh-sudo/sudo.plugin.zsh ]]; then
        if [[ ! -d ~/.zsh/zsh-sudo ]]; then
        echo "zsh-sudo directory doesn't exist, creating new one"
        command mkdir ~/.zsh/zsh-sudo
        fi
        echo "Installing zsh-sudo"
        curl -L -o ~/.zsh/zsh-sudo/sudo.plugin.zsh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
    fi
}

install_LSDeluxe(){
    printf "Do you want to install \"lsd\"? "
    printf "Yes (y) , No (n) : " 
    read install_lsdeluxe
    # zsh-syntax-highlighting
    if [[ "$install_lsdeluxe" == "y" ]]; then
        if [[ $OS == "macos" ]]; then
            command brew install lsd
        else
            command pacman -S lsd
        fi
    fi
}

install_Bat(){
    printf "Do you want to install \"bat\"? "
    printf "Yes (y) , No (n) : " 
    read install_bat
    # zsh-syntax-highlighting
    if [[ "$install_bat" == "y" ]]; then
        if [[ $OS == "macos" ]]; then
            command brew install bat
        else
            command pacman -S bat
        fi
    fi
}

install_Powerlevel10k(){
    printf "Do you want to install \"powerlevel10k\"? "
    printf "Yes (y) , No (n) : " 
    read install_powerlevel10k
    # powerlevel10k
    if [[ "$install_powerlevel10k" == "y" ]]; then
        command git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
        command cp -r ./fonts/. ~/Library/Fonts
        command cat ./configuration_files/.zshrc ~/.zshrc > ~/.zshrc_temp
        echo "A temporal file has been created for powerlevel10k at : ~/.zshrc_temp"
        echo "Please validate this file include all your previous .zshrc configurations"
        echo "Execute this command to finish with the instalation:"
        echo "  mv ~/.zshrc_temp ~/.zshrc   "
        echo "Open a new Kitty shell to enjoy!"
    fi

}

main(){
    install_Zsh_AutoSuggestions
    install_Zsh_Asyntax_Highlighting
    install_Zsh_Sudo
    detect_os
    if [[ "$OS" == "macos" ]]; then
        detect_homebrew
    fi

    if [[ ! "$SKIP_DEPENDENT_COMPONENTS" == "y" ]]; then
        install_LSDeluxe
        install_Bat
    fi
    install_Kitty
    install_Powerlevel10k
}

main "$@"