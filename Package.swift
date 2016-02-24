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
            name: "SQL",
            dependencies: [.Target(name: "PostgreSQL")]),
        Target(
            name: "PostgreSQL",
            dependencies: [.Target(name: "Core")]),
        Target(
            name: "Core")
    ],
  dependencies: [
    .Package(url: libpqPackage().url, majorVersion: libpqPackage().major)
  ]
)