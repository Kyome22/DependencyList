// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "DependencyList",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "DependencyList",
            targets: ["DependencyList"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", exact: "1.3.0")
    ],
    targets: [
        .target(name: "SourcePackagesParserKit"),
        .executableTarget(
            name: "source-packages-parser",
            dependencies: [
                "SourcePackagesParserKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/SourcePackagesParser"
        ),
        .plugin(
            name: "PrepareDependencyList",
            capability: .buildTool(),
            dependencies: [
                "source-packages-parser"
            ]
        ),
        .target(
            name: "DependencyList",
            resources: [.process("Resources")],
            plugins: ["PrepareDependencyList"]
        ),
    ]
)
