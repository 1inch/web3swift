// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "W3SKeystore",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(name: "W3SKeystore", targets: ["W3SKeystore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/1inch/NewWeb3.swift", from: "0.8.8-oi.7"),
    ],
    targets: [
        .target(
            name: "W3SKeystore",
            dependencies: [
                .product(name: "Web3", package: "NewWeb3.swift"),
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
