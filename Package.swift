import PackageDescription

func libpqPackage() -> (url: String, major: Int) {  
    #if os(Linux)
        return ("https://github.com/tuanphung/libpq.git", 1)
    #else
        return ("https://github.com/tuanphung/libpq-darwin.git", 1)
    #endif
}

let package = Package(
  name: "SwiftSQL",
  targets: [
  		Target(
            name: "Main",
            dependencies: [.Target(name: "SwiftSQL")])
    ],
  dependencies: [
    .Package(url: libpqPackage().url, majorVersion: libpqPackage().major)
  ],
  exclude: ["Main"]
)