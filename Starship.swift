import AppKit
import ImageIO

let names = ["Liftoff-Light-Sunset-Dark-6K.heic", "Starship-Liftoff-6K.heic", "Starship-Sunset-6K.heic", "Starship-Engines-6K.heic", "Starship-Ascent-6K.heic", "Roadster-wall-ride-6K.heic", "Roadster-lineup-6K.heic", "Roadster-hover-6K.heic", "Roadster-ramp-6K.heic", "Roadster-inverted-6K.heic", "Roadster-rear-6K.heic", "Roadster-diffuser-6K.heic", "Roadster-studio-6K.heic", "Roadster-poster-6K.heic"]
let labels = ["Automatic · Liftoff / Sunset", "Starship · Liftoff", "Starship · Sunset", "Starship · Engines", "Starship · Ascent", "Roadster · Wall Ride", "Roadster · Lineup", "Roadster · Hover", "Roadster · Ramp", "Roadster · Inverted", "Roadster · Rear", "Roadster · Diffuser", "Roadster · Studio", "Roadster · Poster"]
let resources = Bundle.main.resourceURL!

if CommandLine.arguments.contains("--verify") {
    for name in names {
        let url = resources.appendingPathComponent(name)
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              CGImageSourceCreateImageAtIndex(source, 0, nil) != nil,
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any],
              properties[kCGImagePropertyPixelWidth as String] as? Int == 6016,
              properties[kCGImagePropertyPixelHeight as String] as? Int == 3384 else { fatalError("Invalid resource: \(name)") }
        if name == names[0] {
            guard CGImageSourceGetCount(source) == 2,
                  CGImageSourceCreateImageAtIndex(source, 1, nil) != nil,
                  let metadata = CGImageSourceCopyMetadataAtIndex(source, 0, nil),
                  let tag = CGImageMetadataCopyTagWithPath(metadata, nil, "apple_desktop:apr" as CFString),
                  let encoded = CGImageMetadataTagCopyValue(tag) as? String,
                  let data = Data(base64Encoded: encoded),
                  let appearance = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Int],
                  appearance["l"] == 0, appearance["d"] == 1 else { fatalError("Invalid appearance metadata") }
        }
        print("Verified \(name)")
    }
    exit(0)
}

class WallpaperApp: NSObject, NSApplicationDelegate {
    let files = FileManager.default
    let home = FileManager.default.homeDirectoryForCurrentUser
    var folder: URL { home.appendingPathComponent("Pictures/Wallpapers/Starship for Mac") }
    var backup: URL { home.appendingPathComponent("Library/Application Support/Starship for Mac/previous.plist") }

    func applicationDidFinishLaunching(_ notification: Notification) {
        do {
            try install()
            if !files.fileExists(atPath: backup.path) {
                try savePrevious()
                try apply(names[0])
                showInstalled()
            } else {
                showPicker()
            }
        } catch {
            let alert = NSAlert()
            alert.messageText = "Wallpaper could not be applied"
            alert.informativeText = error.localizedDescription
            alert.runModal()
        }
        NSApp.terminate(nil)
    }

    func install() throws {
        try files.createDirectory(at: folder, withIntermediateDirectories: true)
        for name in names {
            let destination = folder.appendingPathComponent(name)
            if files.fileExists(atPath: destination.path) { try files.removeItem(at: destination) }
            try files.copyItem(at: resources.appendingPathComponent(name), to: destination)
        }
        let applications = home.appendingPathComponent("Applications")
        try files.createDirectory(at: applications, withIntermediateDirectories: true)
        let installedApp = applications.appendingPathComponent("Starship for Mac.app")
        if Bundle.main.bundleURL.standardizedFileURL != installedApp.standardizedFileURL {
            let staged = applications.appendingPathComponent("Starship for Mac-update.app")
            if files.fileExists(atPath: staged.path) { try files.removeItem(at: staged) }
            try files.copyItem(at: Bundle.main.bundleURL, to: staged)
            if files.fileExists(atPath: installedApp.path) { try files.removeItem(at: installedApp) }
            try files.moveItem(at: staged, to: installedApp)
        }
    }

    func savePrevious() throws {
        guard !NSScreen.screens.isEmpty else { throw failure("No displays are available.") }
        let previous = NSScreen.screens.enumerated().compactMap { index, screen -> [String: Any]? in
            if let url = NSWorkspace.shared.desktopImageURL(for: screen) {
                return ["display": displayID(screen), "index": index, "url": url.absoluteString]
            }
            return nil
        }
        let data = try PropertyListSerialization.data(fromPropertyList: previous, format: .xml, options: 0)
        try files.createDirectory(at: backup.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: backup, options: .atomic)
    }

    func apply(_ name: String) throws {
        let url = folder.appendingPathComponent(name)
        guard !NSScreen.screens.isEmpty else { throw failure("No displays are available.") }
        for screen in NSScreen.screens {
            try NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [.imageScaling: NSImageScaling.scaleProportionallyUpOrDown.rawValue, .allowClipping: true])
        }
    }

    func restore() throws {
        let data = try Data(contentsOf: backup)
        let previous = try PropertyListSerialization.propertyList(from: data, format: nil) as? [[String: Any]] ?? []
        for (index, screen) in NSScreen.screens.enumerated() {
            if let entry = previous.first(where: { $0["display"] as? String == displayID(screen) }) ?? previous.first(where: { $0["index"] as? Int == index }),
               let path = entry["url"] as? String, let url = URL(string: path) {
                try NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [:])
            }
        }
    }

    func showInstalled() {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = "Starship is ready"
        alert.informativeText = "Liftoff in Light appearance. Sunset in Dark appearance. macOS handles switching automatically.\n\nStarship and Roadster wallpapers are installed in Pictures → Wallpapers → Starship for Mac. Open Starship for Mac in Applications anytime to choose a wallpaper or restore your previous desktop."
        alert.addButton(withTitle: "Done")
        alert.addButton(withTitle: "Choose a Wallpaper")
        if alert.runModal() == .alertSecondButtonReturn { showPicker() }
    }

    func showPicker() {
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = "Tesla & SpaceX Wallpapers for Mac"
        alert.informativeText = "Automatic follows your Mac’s Light or Dark appearance. Choose a Roadster or Starship image below."
        let choices = NSPopUpButton(frame: NSRect(x: 0, y: 0, width: 350, height: 28))
        choices.addItems(withTitles: labels + ["Restore Previous Wallpaper"])
        alert.accessoryView = choices
        alert.addButton(withTitle: "Apply")
        alert.addButton(withTitle: "Cancel")
        if alert.runModal() == .alertFirstButtonReturn {
            do {
                if choices.indexOfSelectedItem == names.count { try restore() }
                else { try apply(names[choices.indexOfSelectedItem]) }
            } catch {
                let errorAlert = NSAlert()
                errorAlert.messageText = "Wallpaper could not be changed"
                errorAlert.informativeText = error.localizedDescription
                errorAlert.runModal()
            }
        }
    }

    func displayID(_ screen: NSScreen) -> String {
        String(describing: screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] ?? screen.localizedName)
    }

    func failure(_ message: String) -> NSError {
        NSError(domain: "StarshipWallpaper", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
}

let app = NSApplication.shared
let delegate = WallpaperApp()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
