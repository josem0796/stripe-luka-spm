// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StripeLukaSdk",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "StripeLukaSdk",
            targets: ["StripeLukaSdk"]),
    ],
    dependencies: [
      .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
      .package(url: "https://github.com/stripe/stripe-ios-spm", .upToNextMajor(from: "23.27.2"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "StripeLukaSdk",
            dependencies: [
              "Alamofire",
            ]
        ),
        .testTarget(
            name: "StripeLukaSdkTests",
            dependencies: ["StripeLukaSdk"]),
    ]
)
