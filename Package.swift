// swift-tools-version: 6.0

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "DependencyList",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "DependencyList",
            targets: ["DependencyList"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.7.0"),
    ],
    targets: [
        .executableTarget(
            name: "source-packages-parser",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/SourcePackagesParser",
            swiftSettings: swiftSettings
        ),
        .plugin(
            name: "PrepareDependencyList",
            capability: .buildTool(),
            dependencies: ["source-packages-parser"]
        ),
        .target(
            name: "DependencyList",
            resources: [.process("Resources")],
            swiftSettings: swiftSettings,
            plugins: ["PrepareDependencyList"]
        ),
    ]
)
