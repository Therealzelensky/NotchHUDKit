// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NotchHUDKit",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "NotchHUDKit", targets: ["NotchHUDKit"])
    ],
    targets: [
        .target(name: "NotchHUDKit"),
        .testTarget(
            name: "NotchHUDKitTests",
            dependencies: ["NotchHUDKit"]
        )
    ]
)
