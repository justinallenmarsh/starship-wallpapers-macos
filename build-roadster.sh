#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
revision=b770729ecf305d50b1b9a9c26b46dc98096290eb
root="${WALLPAPER_OUTPUT_DIR:-$HOME/Pictures/Wallpapers/Starship}"
sources="$root/Roadster-Sources"
collection="$root/Collection"
profile='/System/Library/ColorSync/Profiles/sRGB Profile.icc'
for tool in magick heif-enc unzip shasum; do
  command -v "$tool" >/dev/null || { echo "Missing $tool (brew install imagemagick libheif)" >&2; exit 1; }
done
test -f "$profile" || { echo "Missing sRGB profile" >&2; exit 1; }
mkdir -p "$sources" "$collection"
archive="${1:-$sources/roadster-$revision.zip}"
if [ ! -f "$archive" ]; then
  curl --fail --location --retry 2 --output "$archive.part" "https://github.com/tcballard/omarchy-theme-roadster-8k/archive/$revision.zip"
  mv "$archive.part" "$archive"
fi
# Do not overwrite user edits: checksum every source before conversion.
while read -r expected path; do
  source="$sources/${path##*/}"
  if [ ! -f "$source" ]; then
    unzip -j -o "$archive" "*/$path" -d "$sources" >/dev/null
  fi
  actual=$(shasum -a 256 "$source")
  [ "${actual%% *}" = "$expected" ] || { echo "Source checksum mismatch: $path" >&2; exit 1; }
  base=${path##*/}
  title=${base#??-}
  title=${title%-8k.*}
  target="$collection/Roadster-$title-6K.heic"
  if [ -e "$target" ]; then echo "Keeping existing wallpaper: $target"; continue; fi
  master="$sources/Roadster-$title-6K-Master.png"
  # Fit the entire photograph within 16:9; dark letterboxing preserves original framing.
  magick "$source" -filter Lanczos -resize 6016x3384 -background '#090A0F' -gravity center -extent 6016x3384 -profile "$profile" -depth 16 "$master"
  heif-enc -q 92 -b 10 -p chroma=444 --enable-two-colr-boxes --colour_primaries 1 --transfer_characteristic 13 --matrix_coefficients 1 -o "$target" "$master"
  [ "$(magick identify -format '%wx%h' "$target")" = 6016x3384 ] || { echo "Invalid HEIC dimensions: $target" >&2; exit 1; }
  echo "Ready: $target"
done < roadster-sources.sha256
echo "Roadster collection ready: $collection"
