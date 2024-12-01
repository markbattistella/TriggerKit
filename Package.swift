// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TriggerKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
        .visionOS(.v1),
        .macCatalyst(.v14),
    ],
    products: [
        .library(
            name: "TriggerKit",
            targets: ["TriggerKit"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TriggerKit",
            dependencies: [],
            exclude: []
        )
    ]
)
