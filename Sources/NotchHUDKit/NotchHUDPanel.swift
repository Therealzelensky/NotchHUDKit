import AppKit

public final class NotchHUDPanel: NSPanel {
    public var shapeMaskImage: NSImage?

    public init(cornerRadius: CGFloat) {
        let size = NSSize(width: cornerRadius * 2, height: cornerRadius * 2)
        super.init(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        shapeMaskImage = CapsuleMask.image(cornerRadius: cornerRadius)
        isFloatingPanel = true
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.statusWindow)) + 2)
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        hidesOnDeactivate = false
        animationBehavior = .none
    }

    public override var canBecomeKey: Bool { false }
    public override var canBecomeMain: Bool { false }

    @objc(_cornerMask)
    func cornerMask() -> NSImage? {
        shapeMaskImage
    }
}
