// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "Scratchpad",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "Scratchpad", targets: ["Scratchpad"])
    ],
    targets: [
        .executableTarget(
            name: "Scratchpad",
            swiftSettings: [.swiftLanguageMode(.v6)]
        )
    ]
)
