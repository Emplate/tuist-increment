// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "tuist-increment",
    platforms: [.macOS(.v11)],
    products: [
        .executable(
            name: "tuist-increment",
            targets: ["TuistIncrement"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.0.0")),
    ],
    targets: [
        .executableTarget(
            name: "TuistIncrement",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)
