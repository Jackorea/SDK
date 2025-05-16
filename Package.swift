// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BioSignalSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "BioSignalSDK", targets: ["BioSignalSDK"]),
    ],
    targets: [
        .target(
            name: "BioSignalSDK",
            dependencies: [],
            path: "Sources/BioSignalSDK"
        )
    ]
)
