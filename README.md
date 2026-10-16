# Tesla & SpaceX Wallpapers for Mac

One Mac wallpaper collection for SpaceX Starship and Tesla Roadster: four Starship stills, nine Roadster shots, and a native macOS Light/Dark Starship wallpaper. The original **Starship for Mac.app** name is retained for seamless upgrades from version 1.0.

## Install

Download **Tesla-SpaceX-for-Mac-1.1.0.zip** from the [latest release](https://github.com/justinallenmarsh/starship-wallpapers-macos/releases/latest), unzip, and open **Starship for Mac.app**. It copies the HEICs into `~/Pictures/Wallpapers/Starship for Mac` and applies Liftoff/Sunset Automatic on a first install. Opening it again lets you choose a Starship or Roadster wallpaper, or restore the wallpaper saved before the first install. Upgrading retains that previous-wallpaper backup and refreshes the app in `~/Applications`.

Light appearance shows Liftoff; Dark appearance shows Sunset. Set macOS Appearance to Auto to follow day and night. Roadster wallpapers are individual still images, not automatic day/night pairs. The release also offers a wallpaper-only ZIP for manual installation.

Requires macOS 14 or newer. The app is ad-hoc signed, not Apple-notarized, so macOS may ask for approval on first launch. Apple Silicon has been build-tested; Intel is cross-compiled but not tested on Intel hardware. In Wallpaper settings, enable **Show on all Spaces** if you want virtual desktops to match.

## Preview

**SpaceX / Starship:** [Liftoff](https://github.com/tcballard/omarchy-theme-liftoff/blob/dba3c7038404a7a842faad3a939dbf8006ba2c5a/backgrounds/01-liftoff.png) · [Sunset](https://github.com/tcballard/omarchy-theme-liftoff/blob/dba3c7038404a7a842faad3a939dbf8006ba2c5a/backgrounds/03-liftoff-sunset.png) · [Engines](https://github.com/tcballard/omarchy-theme-liftoff/blob/dba3c7038404a7a842faad3a939dbf8006ba2c5a/backgrounds/02-engine-cluster.png) · [Ascent](https://github.com/tcballard/omarchy-theme-liftoff/blob/dba3c7038404a7a842faad3a939dbf8006ba2c5a/backgrounds/04-starship-ascent.png)

**Tesla / Roadster:** [Wall Ride](https://github.com/tcballard/omarchy-theme-roadster-8k/blob/b770729ecf305d50b1b9a9c26b46dc98096290eb/backgrounds/01-wall-ride-8k.png) · [Lineup](https://github.com/tcballard/omarchy-theme-roadster-8k/blob/b770729ecf305d50b1b9a9c26b46dc98096290eb/backgrounds/02-lineup-8k.png) · [Hover](https://github.com/tcballard/omarchy-theme-roadster-8k/blob/b770729ecf305d50b1b9a9c26b46dc98096290eb/backgrounds/03-hover-8k.webp) · [Ramp](https://github.com/tcballard/omarchy-theme-roadster-8k/blob/b770729ecf305d50b1b9a9c26b46dc98096290eb/backgrounds/04-ramp-8k.png) · [Inverted](https://github.com/tcballard/omarchy-theme-roadster-8k/blob/b770729ecf305d50b1b9a9c26b46dc98096290eb/backgrounds/05-inverted-8k.png) · [Rear](https://github.com/tcballard/omarchy-theme-roadster-8k/blob/b770729ecf305d50b1b9a9c26b46dc98096290eb/backgrounds/06-rear-8k.png) · [Diffuser](https://github.com/tcballard/omarchy-theme-roadster-8k/blob/b770729ecf305d50b1b9a9c26b46dc98096290eb/backgrounds/07-diffuser-8k.png) · [Studio](https://github.com/tcballard/omarchy-theme-roadster-8k/blob/b770729ecf305d50b1b9a9c26b46dc98096290eb/backgrounds/08-studio-8k.png) · [Poster](https://github.com/tcballard/omarchy-theme-roadster-8k/blob/b770729ecf305d50b1b9a9c26b46dc98096290eb/backgrounds/09-poster-8k.png)

## Quality and provenance

Every still is 6016 × 3384, 10-bit HEIC with an embedded sRGB profile. Roadster images are scaled to fit without cropping their original composition; dark margins appear where needed. The automatic Starship image has two full-resolution frames and native Light/Dark metadata. The originals are AI-enhanced; 8K refers to upstream export dimensions, not native camera or AI generation resolution.

Credits and redistribution terms are in [CREDITS.md](CREDITS.md), which is also included in the app and wallpaper-only ZIP. Artwork is not covered by the software's MIT license. Independent community project, not affiliated with or endorsed by Tesla, SpaceX, Apple, DHH, or Omarchy.

## Build from source

On macOS with Xcode command-line tools and Homebrew:

```sh
brew install imagemagick libheif pkg-config
bash package.sh
```

`package.sh` downloads pinned upstream revisions, verifies each source SHA-256, converts images, makes the native automatic HEIC, compiles the universal app, checks all 14 resources, signs it ad hoc, and creates app and wallpaper-only ZIPs under `dist/`. Intermediate files default to `~/Pictures/Wallpapers/Starship`; override with `STARSHIP_OUTPUT_DIR`. The original `build.sh` exports the Starship stills alone, and `build-roadster.sh` exports the nine Roadster stills. No source photography or generated HEIC is committed to Git.
