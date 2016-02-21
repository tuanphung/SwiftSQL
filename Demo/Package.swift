import PackageDescription

let package = Package(
  name: "demo",
  dependencies: [
    .Package(url: "https://github.com/tuanphung/SwiftSQL", majorVersion: 1)
  ]
)