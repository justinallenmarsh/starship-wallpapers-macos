#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
root="$PWD"
destination="${STARSHIP_OUTPUT_DIR:-$HOME/Pictures/Wallpapers/Starship}"
bash build.sh "${1:-}"
WALLPAPER_OUTPUT_DIR="$destination" bash build-roadster.sh "${ROADSTER_ARCHIVE:-}"
mkdir -p dist
heif-enc -q 92 -b 10 -p chroma=444 --enable-two-colr-boxes --colour_primaries 1 --transfer_characteristic 13 --matrix_coefficients 1 -o dist/frames.heic "$destination/Sources/Starship-Liftoff-6K-Master.png" "$destination/Sources/Starship-Sunset-6K-Master.png"
swift appearance.swift > dist/appearance.xmp
clang++ -std=c++17 dynamic.cpp $(pkg-config --cflags --libs libheif) -o dist/add-metadata
dist/add-metadata dist/frames.heic dist/appearance.xmp dist/Liftoff-Light-Sunset-Dark-6K.heic
app="$root/dist/Starship for Mac.app"
mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
cp dist/Liftoff-Light-Sunset-Dark-6K.heic "$app/Contents/Resources/"
cp "$destination/Collection/"*.heic "$app/Contents/Resources/"
cp CREDITS.md "$app/Contents/Resources/"
cat > "$app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>Starship</string>
<key>CFBundleIdentifier</key><string>com.justinmarsh.starshipwallpapers</string>
<key>CFBundleName</key><string>Starship for Mac</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>1.1.0</string>
<key>CFBundleVersion</key><string>2</string>
<key>LSMinimumSystemVersion</key><string>14.0</string>
<key>NSHighResolutionCapable</key><true/>
</dict></plist>
PLIST
for architecture in arm64 x86_64; do
  swiftc -target "$architecture-apple-macos14.0" Starship.swift -o "dist/Starship-$architecture"
done
lipo -create dist/Starship-arm64 dist/Starship-x86_64 -output "$app/Contents/MacOS/Starship"
"$app/Contents/MacOS/Starship" --verify
codesign --force --sign - "$app"
codesign --verify --deep --strict "$app"
ditto -c -k --sequesterRsrc --keepParent "$app" dist/Tesla-SpaceX-for-Mac-1.1.0.zip
mkdir -p dist/Wallpapers
cp "$app/Contents/Resources/"*.heic dist/Wallpapers/
cp CREDITS.md dist/Wallpapers/
ditto -c -k --sequesterRsrc dist/Wallpapers dist/Tesla-SpaceX-Wallpapers-6K-1.1.0.zip
echo "Ready: $root/dist/Tesla-SpaceX-for-Mac-1.1.0.zip"
