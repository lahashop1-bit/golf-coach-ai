// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pose",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        .library(name: "pose", targets: ["pose"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Pinned commit of master (MediaPipe ships SPM by branch/revision only).
        .package(
            url: "https://github.com/google-ai-edge/mediapipe",
            revision: "02ca022d573c004c463d8c61eb3f8ce17e95a7fc"
        ),
    ],
    targets: [
        .target(
            name: "pose",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "MediaPipeTasksVision", package: "mediapipe"),
            ],
            resources: [
                // If your plugin requires a privacy manifest, for example if it uses any required
                // reason APIs, update the PrivacyInfo.xcprivacy file to describe your plugin's
                // privacy impact, and then uncomment these lines. For more information, see
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),

                // If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ]
        )
    ]
)
