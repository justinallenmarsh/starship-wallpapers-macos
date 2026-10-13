# Starship for Mac

A small, unofficial Starship wallpaper collection, finished for a 6K Mac display.

Three views: **Ascent**, **Engines**, and **Sunset**. Each export is 6016 × 3384, 10-bit HEIC with an embedded sRGB profile and high-quality HEVC compression. Original 8K PNGs remain available locally. These are static wallpapers; macOS can shuffle the collection.

## Preview the collection

| Ascent | Engines | Sunset |
| --- | --- | --- |
| [View image](https://github.com/tcballard/omarchy-theme-liftoff/blob/dba3c7038404a7a842faad3a939dbf8006ba2c5a/backgrounds/04-starship-ascent.png) | [View image](https://github.com/tcballard/omarchy-theme-liftoff/blob/dba3c7038404a7a842faad3a939dbf8006ba2c5a/backgrounds/02-engine-cluster.png) | [View image](https://github.com/tcballard/omarchy-theme-liftoff/blob/dba3c7038404a7a842faad3a939dbf8006ba2c5a/backgrounds/03-liftoff-sunset.png) |

## Build

Install [Homebrew](https://brew.sh), then run:

```sh
brew install imagemagick libheif
git clone https://github.com/justinallenmarsh/starship-wallpapers-macos.git
cd starship-wallpapers-macos
bash build.sh
```

The builder downloads a pinned version of [Tom Ballard’s Liftoff collection](https://github.com/tcballard/omarchy-theme-liftoff), verifies the source images, and writes wallpapers to `~/Pictures/Wallpapers/Starship/Collection`. Sources and lossless masters are preserved under `~/Pictures/Wallpapers/Starship/Sources`. It does not install the Omarchy theme or change your desktop automatically.

For an existing archive: `bash build.sh /path/to/omarchy-theme-liftoff-main.zip`. Set `STARSHIP_OUTPUT_DIR` to choose a different destination. Existing HEICs are preserved.

## Use on macOS

Open System Settings → Wallpaper → Add Photo and select the HEIC files. Depending on macOS version, the menu may also offer a folder option. Alternatively, select a HEIC in Finder and choose Services → Set Desktop Picture. It then appears under Your Photos in Wallpaper settings.

Choose an individual image, or use macOS’s shuffle control if available. Enable Show on all Spaces to synchronize desktops.

## Quality

The upstream images are AI-enhanced 8K exports, not native 8K camera originals. The builder downsamples once with Lanczos filtering, crops centrally to 16:9 without stretching, and encodes at quality 92 with 4:4:4 chroma. The 10-bit export improves encoding precision; it does not recover information absent from the source. Composition and color are retained. A clean local build of all three wallpapers was verified with macOS decoding and color-profile checks.

## Credits

Artwork comes from Tom Ballard’s Liftoff collection, including SpaceX imagery and a sunset reinterpretation. See [CREDITS.md](CREDITS.md). This repository distributes the builder, not the upstream artwork.

Independent community project. Not affiliated with or endorsed by Apple, SpaceX, DHH, or Omarchy.
