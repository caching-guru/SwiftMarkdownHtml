
# MarkdownHtml for Swift
This library is an attempt to allow for easy markdown to HTML conversion. 

## Concepts & Usage

It's built as a `string` extension to allow for easy conversions:
```swift
let html = "# my markdown text".renderMarkdownToXML()
```

## Config
The following config options are available:
### HTML Tags
The only config we have thus far is that you can pick how to render HTML tags from the Markdown.

You can pick between:
* `hide`: Does not render the HTML at all. (safest)
* `renderAsIs`: Renders the tag as is.
* `renderWrapped`: Renders the tag wrapped in an `htmltag`-Tag (this is to allow XML conversion)

## License
MIT

## Development
This package is not fully tested or developed yet. Partially because the underlying library from Apple is not fully released yet either. But this may be a great starting point for your own implementation.

## Usage
This package is used by [caching.guru](https://caching.guru) in production.
