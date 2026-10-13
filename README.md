# Starship for Mac

Liftoff by day. Sunset after dark. Four finished 6K Starship wallpapers with native macOS appearance switching.

## Install

[Download Starship for Mac](https://github.com/justinallenmarsh/starship-wallpapers-macos/releases/latest), unzip, and open **Starship for Mac.app** once. It installs the finished images and applies the Automatic wallpaper to your connected displays. No Terminal, Homebrew, conversion, or background app is needed.

**Light appearance → Liftoff. Dark appearance → Sunset.** With Appearance set to Auto, macOS handles the day/night change. Permanent Dark appearance keeps Sunset active.

Open Starship for Mac again from your home Applications folder to choose Liftoff, Sunset, Engines, or Ascent, or restore your previous wallpaper. Enable Show on all Spaces in Wallpaper settings to sync virtual desktops.

Requires macOS 14 or later; Apple Silicon and Intel are supported. The community app is ad-hoc signed and not Apple-notarized, so macOS may require approval on first launch.

The release also includes a wallpaper-only ZIP for manual HEIC installation and a source ZIP containing the complete installer source and packaging scripts.

## Preview

[Liftoff](https://github.com/tcballard/omarchy-theme-liftoff/blob/main/backgrounds/01-liftoff.png) · [Sunset](https://github.com/tcballard/omarchy-theme-liftoff/blob/main/backgrounds/03-liftoff-sunset.png) · [Engines](https://github.com/tcballard/omarchy-theme-liftoff/blob/main/backgrounds/02-engine-cluster.png) · [Ascent](https://github.com/tcballard/omarchy-theme-liftoff/blob/main/backgrounds/04-starship-ascent.png)

## Quality

6016 × 3384 pixels, 10-bit HEIC, embedded sRGB profiles, and high-quality compression. The automatic image has two full-resolution frames with native Light/Dark metadata. Original artwork is AI-enhanced from [Tom Ballard’s Liftoff collection](https://github.com/tcballard/omarchy-theme-liftoff), not native 8K camera photography.

Both frames, dimensions, appearance metadata, macOS Automatic mode, the Dark/Sunset preview, and installer application were verified on the maintainer’s Mac. Intel is cross-compiled and has not been tested on Intel hardware.

## Build from source

Download and unzip **Starship-Source-1.0.0.zip** from the release. For contributors with Xcode command-line tools and Homebrew:

```sh
brew install imagemagick libheif pkg-config
bash package.sh
```

The repository’s original `build.sh` is also available for static exports. End users should download the finished app.

## Credits and permission

Artwork: **SpaceX and Tom Ballard**. Written redistribution permission was received by the maintainer, subject to attribution. See [CREDITS.md](CREDITS.md). Software is MIT-licensed; the license does not transfer ownership of artwork.

Independent community project. Not affiliated with or endorsed by Apple, SpaceX, DHH, or Omarchy.
