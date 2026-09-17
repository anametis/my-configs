import AppKit

// Render native artwork into one image, so a workspace still owns one window.
let args = Array(CommandLine.arguments.dropFirst())
guard args.count >= 6, let slot = Double(args[1]), let height = Double(args[2]),
      let scale = Double(args[3]), let padding = Double(args[4]),
      let overflow = Int(args[5]), slot > 0, height > 0, scale > 0, padding >= 0,
      overflow >= 0 else { exit(1) }
let apps = Array(args.dropFirst(6))
let width = Double(apps.count) * (slot + padding * 2) + (overflow > 0 ? 24 : 0)
guard width > 0, width < 4096, height < 256 else { exit(1) }
let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(ceil(width * 2)),
    pixelsHigh: Int(ceil(height * 2)), bitsPerSample: 8, samplesPerPixel: 4,
    hasAlpha: true, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
bitmap.size = NSSize(width: width, height: height)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
for (index, identifier) in apps.enumerated() {
    let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: identifier)
        ?? NSWorkspace.shared.fullPath(forApplication: identifier).map { URL(fileURLWithPath: $0) }
    let icon = url.map { NSWorkspace.shared.icon(forFile: $0.path) }
        ?? NSImage(named: NSImage.applicationIconName)!
    // SketchyBar's native app images use a 32pt source image.
    let size = min(32 * scale, height)
    let x = Double(index) * (slot + padding * 2) + padding + (slot - size) / 2
    icon.draw(in: NSRect(x: x, y: (height - size) / 2, width: size, height: size))
}
if overflow > 0 {
    let text = "+\(overflow)" as NSString
    text.draw(at: NSPoint(x: width - 24, y: (height - 13) / 2), withAttributes: [
        .font: NSFont.systemFont(ofSize: 10.5, weight: .semibold),
        .foregroundColor: NSColor(calibratedWhite: 0.9, alpha: 1)])
}
NSGraphicsContext.restoreGraphicsState()
guard let data = bitmap.representation(using: .png, properties: [:]) else { exit(1) }
do { try data.write(to: URL(fileURLWithPath: args[0]), options: .atomic) }
catch { fputs("App icon strip: \(error)\n", stderr); exit(1) }
