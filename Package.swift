// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "TriggerKit",
  platforms: [
    .iOS(.v14),
    .macOS(.v11),
    .macCatalyst(.v14),
    .tvOS(.v14),
    .watchOS(.v7),
    .visionOS(.v1),
  ],
  products: [
    .library(
      name: "TriggerKit",
      targets: ["TriggerKit"]
    )
  ],
  targets: [
    .target(
      name: "TriggerKit",
      dependencies: [],
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
    .testTarget(
      name: "TriggerKitTests",
      dependencies: ["TriggerKit"],
      swiftSettings: [
        .swiftLanguageMode(.v6)
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
