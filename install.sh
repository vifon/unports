#!/bin/bash

check-dependency() {
    if ! command -v "$1" &> /dev/null; then
        cat <<EOF

Warning:
  You don't have $1 installed.
  Unports may not work without it.
EOF
        false
    else
        true
    fi
}

check-dependencies() {
    local RET=0
    local STATUS
    while [ -n "$1" ]; do
        check-dependency "$1"
        STATUS=$?
        if [ "$RET" = 0 ]; then
            RET=$STATUS
        fi
        shift
    done
    return $RET
}

guess-shell-config() {
    local CONFIG
    case "$SHELL" in
        /bin/bash)
            CONFIG=$HOME/.bashrc
            ;;
        /bin/zsh)
            CONFIG=$HOME/.zshrc
            ;;
        *)
            CONFIG=
            ;;
    esac
    echo "$CONFIG"
}

ask() {
    local REPLY
    while ! [ "$REPLY" = y -o "$REPLY" = n ]; do
        echo -n $'\n'"$1 [y/n] "
        read -n 1
        echo -n $'\n'
    done
    test "$REPLY" = "y"
}

main() {
    if ! check-dependencies "git" "tar" "make" "quilt" "wget"; then
        if ! ask "Do you want to continue nonetheless?"; then
            exit
        fi
    fi

    cat <<EOF

Unports will be installed into ~/ports.
Unports will be using ~/pkgs to install individual packages.
The ~/local tree will be maintained by Unports using GNU Stow.
EOF
    if ! ask "Continue?"; then
        exit
    fi

    mkdir -pv ~/ports ~/pkgs ~/local
    ln -sv --relative --force --target-directory="$HOME/ports" unports/*

    cat <<'EOF'

It's recommended to add ~/local/bin to $PATH:

  PATH="$HOME/local/bin:$PATH"
EOF

    for rc in bashrc zshrc; do
        if ask "Should the modified \$PATH be appended to your ~/.$rc?"; then
            cat <<'EOF' >> ~/.$rc
PATH="$HOME/local/bin:$PATH"
EOF
        fi
    done

    cat <<'EOF'

In the future you may want to add ~/local/lib*/python*/site-packages
to $PYTHONPATH in the same manner.
EOF
}

main
