// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DietTrackingCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(name: "DietTrackingDomain", targets: ["DietTrackingDomain"]),
        .library(name: "DietTrackingStorage", targets: ["DietTrackingStorage"]),
        .library(name: "DietTrackingAnalysis", targets: ["DietTrackingAnalysis"]),
        .library(name: "DietTrackingLogging", targets: ["DietTrackingLogging"])
    ],
    targets: [
        .target(
            name: "DietTrackingDomain"
        ),
        .target(
            name: "DietTrackingStorage",
            dependencies: ["DietTrackingDomain"]
        ),
        .target(
            name: "DietTrackingAnalysis",
            dependencies: ["DietTrackingDomain"]
        ),
        .target(
            name: "DietTrackingLogging",
            dependencies: [
                "DietTrackingDomain",
                "DietTrackingStorage"
            ]
        ),
        .testTarget(
            name: "DietTrackingCoreTests",
            dependencies: [
                "DietTrackingDomain",
                "DietTrackingStorage",
                "DietTrackingAnalysis",
                "DietTrackingLogging"
            ]
        )
    ]
)
