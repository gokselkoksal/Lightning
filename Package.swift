// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "Lightning",
    platforms: [.macOS(.v10_12), .iOS(.v10), .tvOS(.v10), .watchOS(.v3)],
    products: [
        .library(
            name: "Lightning",
            targets: ["Lightning"]),
    ],
    targets: [
        .target(
            name: "Lightning",
            path: "Lightning")
    ]
)
