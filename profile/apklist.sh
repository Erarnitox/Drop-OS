#!/bin/sh

APKS=""

addapk() {
	APKS="$APKS $@"
}

# --------------------
# Xorg

## Xorg Server
addapk dbus dbus-openrc xorg-server dbus eudev udev udev-init-scripts udev-init-scripts-openrc

## Xorg Video
addapk xf86-video-intel xf86-video-amdgpu xf86-video-vesa xf86-video-vboxvideo xf86-video-vmware xf86-video-modesetting xf86-video-qxl xf86-video-nouveau mesa mesa-egl

## Xorg Input
addapk xf86-input-libinput xf86-input-evdev xf86-input-synaptics

## Xorg Tools
addapk xrandr xsetroot setxkbmap xprop

## Display Manager
addapk lightdm lightdm-gtk-greeter

## Window Manager
addapk bspwm

## Hotkey Daemon
addapk sxhkd

## Compositor
addapk picom

## Cursor Theme
addapk adwaita-icon-theme

## Icon Theme
addapk papirus-icon-theme

## Appearance Changer
addapk lxappearance

## Screenshot Tool
addapk maim

# --------------------
# Audio 

## Audio Server
addapk pipewire pipewire-alsa pipewire-pulse

## Audio Tools
addapk pavucontrol pulseaudio-ctl wireplumber

# --------------------
# Network

## Network Daemon
addapk iwd

## VPN Tools
addapk wireguard-tools openvpn

# --------------------
# Applications

## Terminal Emulator
addapk alacritty

## Status Bar
addapk polybar

## Text Editor
addapk vim

## App Launcher
addapk rofi

## Image Viewer
addapk feh

## Browser
addapk firefox

## Office Tools
# addapk libreoffice
# addapk poppler poppler-utils

## Image Editor
# addapk gimp

## Vector Editor
# addapk inkscape

## Password Manager
# addapk keepassxc

## Development Tools
addapk gcc gdb make python3 tar gzip xz p7zip

## Tools for building this distribuition
addapk git alpine-sdk build-base apk-tools alpine-conf busybox fakeroot syslinux xorriso squashfs-tools sudo mtools dosfstools grub-efi

# --------------------
# Misc

## Fonts
addapk font-ubuntu-mono-nerd

# --------------------
# Show Packages

echo $APKS
