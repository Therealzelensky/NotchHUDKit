# NotchHUDKit

Shared AppKit shell for macOS Dynamic Island / notch HUDs under the menu bar.

## Install (SwiftPM)

```swift
dependencies: [
    .package(url: "https://github.com/Therealzelensky/NotchHUDKit.git", from: "1.0.0")
]
```

## Geometry canon

| State | Y |
|---|---|
| Expanded | `visibleFrame.maxY - height - 5` |
| Tuck in | `frame.maxY - 4` |
| Tuck out | `frame.maxY + 6` |

## Minimal usage

```swift
import AppKit
import NotchHUDKit

@MainActor
final class MyHUD {
    private let shell = NotchHUDShell()

    func show(title: String) {
        let label = NSTextField(labelWithString: title)
        label.alignment = .center
        shell.contentView = label
        let size = NSSize(width: 200, height: 42)
        shell.present(size: size, on: NSScreen.main)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            self.shell.dismiss()
        }
    }
}
```

Content (icons, tint, copy) stays in the app. Auto-hide is the app's job.
