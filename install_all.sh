#!/bin/sh
# Run from the repo root.  Native: ./install_all.sh   Flatpak: FLATPAK=1 ./install_all.sh
set -e
if [ "$FLATPAK" = "1" ]; then
  C="$HOME/.var/app/com.github.wwmm.easyeffects/config/easyeffects"
  D="$HOME/.var/app/com.github.wwmm.easyeffects/data/easyeffects"
else
  C="$HOME/.config/easyeffects"
  D="$HOME/.local/share/easyeffects"
fi
mkdir -p "$C/output" "$D/irs"
cp irs/*.irs "$D/irs/"        # impulse responses
cp ./*.json "$C/output/"       # presets in the repo root
cp v3/*.json "$C/output/"      # presets in v3/
echo "Installed presets: $(ls ./*.json v3/*.json | xargs -n1 basename | tr '\n' ' ')"
echo "Open EasyEffects > Presets > Output, or run: easyeffects -l atmos-v3-cinema"
