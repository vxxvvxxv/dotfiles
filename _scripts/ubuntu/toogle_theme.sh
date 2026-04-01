#!/bin/bash
# Get current hour
hour=$(date +%H)
# If time is between 8pm (20) and 8am (08), set dark mode
if [ $hour -ge 20 ] || [ $hour -lt 8 ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
else
    gsettings set org.gnome.desktop.interface color-scheme 'default'
    gsettings set org.gnome.desktop.interface gtk-theme 'Yaru'
fi
