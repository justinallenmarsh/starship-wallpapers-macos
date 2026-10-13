#!/bin/bash
set -euo pipefail

revision=dba3c7038404a7a842faad3a939dbf8006ba2c5a
destination="${STARSHIP_OUTPUT_DIR:-$HOME/Pictures/Wallpapers/Starship}"
sources="$destination/Sources"
collection="$destination/Collection"
profile='/System/Library/ColorSync/Profiles/sRGB Profile.icc'

for tool in magick heif-enc unzip shasum; do
  command -v "$tool" >/dev/null || { echo "Missing $tool. Install dependencies with: brew install imagemagick libheif" >&2; exit 1; }
done
test -f "$profile" || { echo "This builder requires macOS ColorSync profiles." >&2; exit 1; }
mkdir -p "$sources" "$collection"

archive="${1:-$sources/liftoff-$revision.zip}"
if [ ! -f "$archive" ]; then
  curl --fail --location --retry 2 --output "$archive.part" "https://github.com/tcballard/omarchy-theme-liftoff/archive/$revision.zip"
  mv "$archive.part" "$archive"
fi
unzip -j -o "$archive" "*/backgrounds/02-engine-cluster.png" "*/backgrounds/03-liftoff-sunset.png" "*/backgrounds/04-starship-ascent.png" -d "$sources"

while IFS=" " read -r expected source title; do
  actual=$(shasum -a 256 "$sources/$source")
  actual=${actual%% *}
  [ "$actual" = "$expected" ] || { echo "Source checksum mismatch: $source" >&2; exit 1; }
  target="$collection/$title-6K.heic"
  master="$sources/$title-6K-Master.png"
  if [ -e "$target" ]; then
    echo "Keeping existing wallpaper: $target"
    continue
  fi
  magick "$sources/$source" -filter Lanczos -resize "6016x3384^" -gravity center -extent 6016x3384 -profile "$profile" -depth 16 "$master"
  heif-enc -q 92 -b 10 -p chroma=444 --enable-two-colr-boxes --colour_primaries 1 --transfer_characteristic 13 --matrix_coefficients 1 -o "$target" "$master"
  dimensions=$(magick identify -format "%wx%h" "$target")
  [ "$dimensions" = "6016x3384" ] || { echo "Unexpected dimensions: $target" >&2; exit 1; }
  echo "Ready: $target"
done < "$(dirname "$0")/sources.sha256"

echo "Collection ready: $collection"
if ! open "$collection"; then
  echo "Open this folder in Finder: $collection"
fi
