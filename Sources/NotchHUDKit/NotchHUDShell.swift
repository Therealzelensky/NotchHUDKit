import AppKit
import QuartzCore

@MainActor
public final class NotchHUDShell {
    private let height: CGFloat
    private let ignoresMouseEvents: Bool
    private var panel: NotchHUDPanel?
    private var effectView: NSVisualEffectView?
    private var hostedContent: NSView?
    public private(set) var isVisible = false

    public init(height: CGFloat = 42, ignoresMouseEvents: Bool = true) {
        self.height = height
        self.ignoresMouseEvents = ignoresMouseEvents
    }

    /// Application-owned content hosted inside the blur capsule.
    public var contentView: NSView? {
        get { hostedContent }
        set {
            hostedContent?.removeFromSuperview()
            hostedContent = newValue
            guard let effectView, let newValue else { return }
            newValue.frame = effectView.bounds
            newValue.autoresizingMask = [.width, .height]
            effectView.addSubview(newValue)
        }
    }

    public func present(size: NSSize, on screen: NSScreen?) {
        guard let screen else { return }
        if isVisible {
            update(size: size, on: screen)
            return
        }
        ensurePanel()
        guard let panel else { return }

        let target = NotchHUDLayout.islandFrame(size: size, on: screen)
        let tucked = NotchHUDLayout.tuckedInFrame(around: target, on: screen)

        panel.setFrame(tucked, display: true)
        panel.alphaValue = 0
        panel.orderFrontRegardless()
        isVisible = true

        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.38
            ctx.timingFunction = CAMediaTimingFunction(controlPoints: 0.16, 1.0, 0.3, 1.0)
            panel.animator().setFrame(target, display: true)
            panel.animator().alphaValue = 1
        }
    }

    public func update(size: NSSize, on screen: NSScreen?) {
        guard let screen, isVisible, let panel else { return }
        let target = NotchHUDLayout.islandFrame(size: size, on: screen)
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.22
            ctx.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            panel.animator().setFrame(target, display: true)
            panel.animator().alphaValue = 1
        }
    }

    public func dismiss(completion: (() -> Void)? = nil) {
        guard let panel, let screen = NSScreen.main, isVisible else {
            completion?()
            return
        }
        let tucked = NotchHUDLayout.tuckedOutFrame(from: panel.frame, on: screen)
        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.duration = 0.28
            ctx.timingFunction = CAMediaTimingFunction(name: .easeIn)
            panel.animator().setFrame(tucked, display: true)
            panel.animator().alphaValue = 0
        }, completionHandler: {
            DispatchQueue.main.async {
                panel.orderOut(nil)
                self.isVisible = false
                panel.alphaValue = 1
                completion?()
            }
        })
    }

    private func ensurePanel() {
        if panel != nil { return }
        let radius = height / 2
        let mask = CapsuleMask.image(cornerRadius: radius)
        let p = NotchHUDPanel(cornerRadius: radius)
        p.shapeMaskImage = mask
        p.ignoresMouseEvents = ignoresMouseEvents

        let effect = NSVisualEffectView(frame: .zero)
        effect.autoresizingMask = [.width, .height]
        effect.material = .hudWindow
        effect.blendingMode = .behindWindow
        effect.state = .active
        effect.maskImage = mask
        p.contentView = effect

        if let hostedContent {
            hostedContent.frame = effect.bounds
            hostedContent.autoresizingMask = [.width, .height]
            effect.addSubview(hostedContent)
        }

        effectView = effect
        panel = p
    }
}
