// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "SwiftMarkdownHtml",
    products: [
        .library(name: "MarkdownHtml", targets: ["MarkdownHtml"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-markdown.git", .branch("main")),
    ],
    targets: [
        .target(name: "MarkdownHtml", dependencies: [
                    .product(name: "Markdown", package: "swift-markdown"),
                ], path: "Sources"),
        .testTarget(name: "MarkdownHtmlTests", dependencies: ["MarkdownHtml"])
    ]
)
