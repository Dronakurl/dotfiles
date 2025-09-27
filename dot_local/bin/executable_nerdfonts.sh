#!/bin/bash

declare -a fonts=(
  # FantasqueSansMono
  # VictorMono
  # Agave
  # CascadiaCode
  # CodeNewRoman
  # SourceCodePro
  #  DejaVuSansMono
  # FiraCode
  # FiraMono
  #  Iosevka
  # Mononoki
  # NerdFontsSymbolsOnly
  # RobotoMono
  # UbuntuMono
  # Ubuntu
  # AnonymousPro
  # Arimo
  # AurulentSansMono
  # BigBlueTerminal
  # BitstreamVeraSansMono
  # CascadiaCode
  # Cousine
  # DaddyTimeMono
  # DroidSansMono
  # Go-Mono
  # Gohu
  # Hack
  # Hasklig
  # HeavyData
  # Hermit
  # iA-Writer
  # IBMPlexMono
  # Inconsolate
  # InconsolataGo
  # InconsolataLGC
  JetBrainsMono
  # Lekton
  # LiberationMono
  # Lilex
  # Meslo
  # Monofur
  # Monoid
  # MPlus
  # Noto
  # OpenDyslexic
  # Overpass
  # ProFont
  # ProggyClean
  # ShareTechMono
  # Terminus
  # Tinos
)

version='3.1.1'
fonts_dir="${HOME}/.local/share/fonts"

if [[ ! -d "$fonts_dir" ]]; then
  mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
  zip_file="${font}.zip"
  download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
  echo "Downloading $download_url"
  wget "$download_url"
  unzip -o "$zip_file" -d "$fonts_dir" -x "*.txt/*" -x "*.md/*"
  rm "$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

fc-cache -fv
