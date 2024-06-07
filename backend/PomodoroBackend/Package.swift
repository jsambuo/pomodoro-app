// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "PomodoroBackend",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.92.4"),
        .package(url: "https://github.com/vapor/jwt.git", from: "5.0.0-beta"),
        .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "0.44.0"),
        .package(url: "https://github.com/vapor-community/vapor-aws-lambda-runtime", from: "0.6.2"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift"),
                .product(name: "VaporAWSLambdaRuntime", package: "vapor-aws-lambda-runtime"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
] }
