// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "W3SKeystore",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(name: "W3SKeystore", targets: ["W3SKeystore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/1inch/Web3.swift.git", from: "0.6.19"),
    ],
    targets: [
        .target(
            name: "W3SKeystore",
            dependencies: [
                .product(name: "Web3", package: "Web3.swift"),
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
