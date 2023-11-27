// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Features",
  platforms: [.iOS(.v16)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(name: "Features", targets: ["Features"]),
    .library(name: "ContentBlockerService", targets: ["ContentBlockerService"])
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.5.0"),
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.1")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "Features",
      dependencies: [.contentBlockerService, .tca]
    ),
    .testTarget(
      name: "FeaturesTests",
      dependencies: ["Features", .tca]
    ),
    .target(
      name: "ContentBlockerService",
      dependencies: [.dependencies]
    )
  ]
)

// First-party
extension Target.Dependency {
  static let contentBlockerService: Self = "ContentBlockerService"
}

// Third-party
extension Target.Dependency {
  static let tca = Self.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
  static let dependencies = Self.product(name: "Dependencies", package: "swift-dependencies")
}
