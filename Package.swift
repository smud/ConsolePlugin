import PackageDescription

let package = Package(
    name: "ConsolePlugin",
    dependencies: [
        .Package(url: "https://github.com/smud/Smud.git", majorVersion: 0),
        .Package(url: "https://github.com/smud/TextUserInterface.git", majorVersion: 0),
    ]
)
