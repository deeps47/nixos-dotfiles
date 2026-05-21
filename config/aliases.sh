#!/bin/bash

# --- Simple Aliases ---
alias btw="echo i use nixos btw"
alias vim="nvim"
alias nrs="sudo nixos-rebuild switch --flake path:."
alias nrb="sudo nixos-rebuild boot --flake path:."
alias ncg="sudo nix-collect-garbage -d"
alias try="nix-shell -p"

alias ai-up="sudo systemctl start ollama searx open-webui"
alias ai-down="sudo systemctl stop ollama searx open-webui"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Show all files (including hidden), long listing, human-readable, grouped dirs, icons, Git info
alias la="eza -lha --icons --group-directories-first"

# Fast, compact listing with icons and colors (good for quick overview)
alias ls="eza --icons --group-directories-first"

# --- Complex Multi-line Commands (Functions) ---
kali-vm() {
    qemu-system-x86_64 \
        -enable-kvm \
        -machine q35,accel=kvm,memory-backend=mem1 \
        -cpu host \
        -smp sockets=1,cores=8,threads=2 \
        -m 8G \
        -object memory-backend-memfd,id=mem1,size=8G,share=on \
        -device virtio-blk-pci,drive=drive0,config-wce=off \
        -drive file="$HOME/vm/kali/kali-linux-2025.4-qemu-amd64.qcow2",if=none,id=drive0,cache=none,discard=unmap,format=qcow2,aio=io_uring \
        -netdev user,id=net0 \
        -device virtio-net-pci,netdev=net0 \
        -device virtio-rng-pci \
        -device virtio-balloon \
        -device virtio-vga-gl,blob=true \
        -display gtk,gl=on \
        -boot order=c \
        "$@"
}
