#!/bin/sh
if [ "$FLATPAK" = "1" ]; then C="$HOME/.var/app/com.github.wwmm.easyeffects/config/easyeffects"; D="$HOME/.var/app/com.github.wwmm.easyeffects/data/easyeffects"
else C="$HOME/.config/easyeffects"; D="$HOME/.local/share/easyeffects"; fi
mkdir -p "$C/output" "$D/irs"; cp irs/*.irs "$D/irs/"; cp presets/*.json "$C/output/"
echo "installed: $(ls presets | tr '\n' ' ')"
