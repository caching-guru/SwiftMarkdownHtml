// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SwiftMarkdownHtml",
    products: [
        .library(name: "MarkdownHtml", targets: ["MarkdownHtml"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", .branch("main")),
        .package(url: "https://github.com/Kitura/swift-html-entities.git", from: "3.0.0")
    ],
    targets: [
        .target(name: "MarkdownHtml", dependencies: [
                    .product(name: "Markdown", package: "swift-markdown"),
                    .product(name: "HTMLEntities", package: "swift-html-entities"),
                ], path: "Sources"),
        .testTarget(name: "MarkdownHtmlTests", dependencies: ["MarkdownHtml"])
    ]
)
