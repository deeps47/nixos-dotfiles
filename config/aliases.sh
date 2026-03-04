#!/bin/bash

# --- Simple Aliases ---
alias btw="echo i use nixos btw"
alias vim="nvim"
alias nrs="sudo nixos-rebuild switch --flake path: ";

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
