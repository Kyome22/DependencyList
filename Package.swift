// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DependencyList",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SourcePackagesParserKit",
            targets: ["SourcePackagesParserKit"]),
        .executable(
            name: "source-packages-parser",
            targets: ["source-packages-parser"]),
        .plugin(
            name: "PrepareDependencyList",
            targets: ["PrepareDependencyList"]),
        .library(
            name: "DependencyList",
            targets: ["DependencyList"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            exact: "1.2.0")
    ],
    targets: [
        .target(
            name: "SourcePackagesParserKit"),
        .executableTarget(
            name: "source-packages-parser",
            dependencies: [
                .target(
                    name: "SourcePackagesParserKit"),
                .product(
                    name: "ArgumentParser",
                    package: "swift-argument-parser")
            ],
            path: "Sources/SourcePackagesParser"
        ),
        .plugin(
            name: "PrepareDependencyList",
            capability: .buildTool(),
            dependencies: [
                .target(name: "source-packages-parser")
            ]),
        .target(
            name: "DependencyList",
            resources: [
                .process("Resources")
            ]),
        .testTarget(
            name: "DependencyListTests",
            dependencies: ["DependencyList"])
    ]
)
