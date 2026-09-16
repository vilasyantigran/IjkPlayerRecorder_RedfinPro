// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "IjkPlayerRecorderRedfinPro",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "IJKMediaFramework",
            targets: ["IJKMediaFramework"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "IJKMediaFramework",
            url: "https://github.com/vilasyantigran/IjkPlayerRecorder_RedfinPro/releases/download/redfinpro-ijk-0.1.0/IJKMediaFramework.xcframework.zip",
            checksum: "356efcb431f602f44533061fef24cec376deecdceb59b3ec8adccdffcf4ef9ba"
        )
    ]
)
