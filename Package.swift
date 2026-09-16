// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "IjkPlayerRecorderRedfinPro",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "IjkPlayerRecorderSource",
            targets: ["IjkPlayerRecorderSource"]
        )
    ],
    targets: [
        .target(
            name: "IjkPlayerRecorderSource",
            path: "Sources/IjkPlayerRecorderSource"
        )
    ]
)
