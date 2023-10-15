// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "MacroUtils",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [
        .library(
            name: "MacroUtils",
            targets: ["MacroUtils"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .target(
            name: "MacroUtils",
            dependencies: ["MacroLib"]
        ),
        .macro(
            name: "MacroLib",
            dependencies: [
                .product(
                    name: "SwiftSyntaxMacros",
                    package: "swift-syntax"
                ),
                .product(
                    name: "SwiftCompilerPlugin",
                    package: "swift-syntax"
                ),
            ]
            ),
        .testTarget(
            name: "MacroLibTests",
            dependencies: [
                "MacroLib",
                .product(
                    name: "SwiftSyntaxMacrosTestSupport",
                    package: "swift-syntax"
                ),
            ]
        ),
    ]
)
