// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SwiftWasmConcat",
    products: [
        .executable(
            name: "SwiftWasmConcat",
            targets: ["SwiftWasmConcat"]),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SwiftWasmConcat",
            dependencies: []),
    ]
)