// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "W3SKeystore",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
    ],
    products: [
        .library(name: "W3SKeystore", targets: ["W3SKeystore"]),
    ],
    dependencies: [
        .package(name: "Web3", url: "https://github.com/1inch/Web3.swift.git", from: "0.6.11"),
    ],
    targets: [
        .target(
            name: "W3SKeystore",
            dependencies: [
                .product(name: "Web3", package: "Web3"),
            ]
        ),
        .testTarget(
            name: "W3SKeystoreTests",
            dependencies: [
                .target(name: "W3SKeystore"),
            ]
        ),
    ]
)
