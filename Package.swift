// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "GraphQLVapor",
    products: [
        .library(
            name: "GraphQLVapor",
            targets: ["GraphQLVapor"]
        ),
    ],
    targets: [
        .target(
            name: "GraphQLVapor"
        ),
        .testTarget(
            name: "GraphQLVaporTests",
            dependencies: ["GraphQLVapor"]
        ),
    ]
)
