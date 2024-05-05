// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CBSGame",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        // .library(
        //     name: "CBSGame",
        //     targets: ["CBSGame", "CBSPlayer", "DDD"]),
    ],
    dependencies: [
        .package(url: "https://github.com/dannys42/Causality.git", from: "0.0.6")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(name: "Executor", dependencies: ["CBSGame", "CBSPlayer"]),
        .target(
            name: "DDD"),
        .target(
            name: "CardGame"),
        .target(
            name: "CBSGame", dependencies: [
                "DDD",
                "CBSPlayer",
                "CardGame",
                .product(name: "Causality", package: "causality")
            ]),
        .target(
            name: "CBSPlayer", dependencies: [
                "DDD",
                "CardGame"
            ]),
        
        .testTarget(
            name: "CBSGameTests",
            dependencies: ["CBSGame", "CBSPlayer", "DDD"]),
        .testTarget(
            name: "CBSGamePlayerTests",
            dependencies: ["CBSPlayer"]),
    ]
)
