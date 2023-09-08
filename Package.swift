// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "Lightning",
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
