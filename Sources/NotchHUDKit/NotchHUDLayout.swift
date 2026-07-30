import AppKit

public enum NotchHUDLayout {
    public static let edgeGap: CGFloat = 5

    /// Expanded banner under menu bar (visibleFrame), centered on screen.
    public static func islandFrame(
        size: NSSize,
        screenFrame: CGRect,
        visibleFrame: CGRect
    ) -> NSRect {
        NSRect(
            x: screenFrame.midX - size.width / 2,
            y: visibleFrame.maxY - size.height - edgeGap,
            width: size.width,
            height: size.height
        )
    }

    public static func islandFrame(size: NSSize, on screen: NSScreen) -> NSRect {
        islandFrame(size: size, screenFrame: screen.frame, visibleFrame: screen.visibleFrame)
    }

    /// Start frame for tuck-in (physical top of screen).
    public static func tuckedInFrame(around target: NSRect, screenFrame: CGRect) -> NSRect {
        NSRect(
            x: target.midX - 60,
            y: screenFrame.maxY - 4,
            width: 120,
            height: 28
        )
    }

    public static func tuckedInFrame(around target: NSRect, on screen: NSScreen) -> NSRect {
        tuckedInFrame(around: target, screenFrame: screen.frame)
    }

    /// End frame for tuck-out (slightly above physical top).
    public static func tuckedOutFrame(from current: NSRect, screenFrame: CGRect) -> NSRect {
        NSRect(
            x: current.midX - 52,
            y: screenFrame.maxY + 6,
            width: 104,
            height: 24
        )
    }

    public static func tuckedOutFrame(from current: NSRect, on screen: NSScreen) -> NSRect {
        tuckedOutFrame(from: current, screenFrame: screen.frame)
    }
}
