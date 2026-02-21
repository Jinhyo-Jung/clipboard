// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "ClipboardApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "ClipboardApp", targets: ["ClipboardApp"])
    ],
    targets: [
        .executableTarget(
            name: "ClipboardApp"
        )
    ]
)
