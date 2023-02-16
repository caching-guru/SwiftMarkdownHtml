//
//  File.swift
//  
//
//  Created by Ralph Küpper on 2/15/23.
//

import Foundation
import Markdown
import SwiftSoup

// Hopefully you hardly ever find these in markdown :)
let emptyElementTagNames = ["img", "hr", "input", "link", "meta", "br", "area", "base", "col", "embed", "param", "source", "track", "wbr", "title"]

public extension String {
    struct MarkdownHtmlConfig {
        enum HTMLTagConfig {
            case hide
            case renderAsIs
            case renderWrapped
        }
        var renderHtmlTags: HTMLTagConfig
        
        public static var defaultConfig = MarkdownHtmlConfig(renderHtmlTags: .renderWrapped)
    }
    func renderMarkdownToXML(_ config:MarkdownHtmlConfig = .defaultConfig) -> String {
        let document = Document(parsing: self)
        return self.renderChildXML(document, config: config)
    }
    private func renderChildXML(_ p: Markup, config: MarkdownHtmlConfig) -> String {
        var ret = ""
        if let para = p as? Paragraph {
            ret = "<p>"
        }
        else if let para = p as? Markdown.Document {
            // nothing to do
        }
        else if let text = p as? Text {
            ret = ret + text.plainText
        }
        else if let break1 = p as? SoftBreak {
            ret = ret + "<br />"
        }
        else if let ul = p as? UnorderedList {
            ret = ret + "<ul>"
        }
        else if let ol = p as? OrderedList {
            ret = ret + "<ol>"
        }
        else if let li = p as? ListItem {
            ret = ret + "<li>"
        }
        else if let strong = p as? Strong {
            ret = ret + "<strong>"
        }
        else if let strikethrough = p as? Strikethrough {
            ret = ret + "<s>"
        }
        else if let blockQuote = p as? BlockQuote {
            ret = ret + "<blockquote>"
        }
        else if let thematicBreak = p as? ThematicBreak {
            ret = ret + "<hr />"
       }
        else if let table = p as? Table {
            ret = ret + "<table>"
       }
        else if let tableHead = p as? Table.Head {
            ret = ret + "<thead>"
       }
        else if let tableBody = p as? Table.Body {
            ret = ret + "<tbody>"
       }
        else if let tableRow = p as? Table.Row {
            ret = ret + "<tr>"
       }
        else if let tableCell = p as? Table.Cell {
            ret = ret + "<td>"
       }
        else if let html = p as? InlineHTML {
            
            switch config.renderHtmlTags {
            case .hide:
                return ret
            case .renderAsIs:
                ret = ret + "\(html.rawHTML)"
            case .renderWrapped:
                // Not ideal yet, but the markdown parser doesn't help much.
                if html.rawHTML.prefix(2) == "</" {
                    ret = ret + "\(html.rawHTML)</htmltag>"
                }
                else {
                    ret = ret + "<htmltag>\(html.rawHTML)"
                    var singleTag = false
                    if html.rawHTML.suffix(2) == "/>" {
                        singleTag = true
                    }
                    else {
                        var tagName = String(html.rawHTML.suffix(html.rawHTML.count-1))
                        if tagName.contains(" ") {
                            tagName = String(tagName.substring(to: tagName.index(of: " ")!))
                        }
                        else if tagName.contains(">") {
                            tagName = String(tagName.substring(to: tagName.index(of: ">")!))
                        }
                        
                        if emptyElementTagNames.contains(tagName.lowercased()) {
                            singleTag = true
                        }
                    }
                    if singleTag {
                        ret = ret + "</htmltag>"
                    }
                }
            }
        }
        else if let ul = p as? Emphasis {
            ret = ret + "<i>"
        } else if let inlineCode = p as? InlineCode {
            ret = ret + "<code class=\"inline language-javascript\">\(inlineCode.code)</code>"
            return ret
        } else if let link = p as? Link, let d = link.destination {
            ret = ret + "<a href=\"\(d)\">"
        } else if let image = p as? Image, let source = image.source {
            if let title = image.title {
                ret = ret + "<img src=\"\(source)\" title=\"\(title)\" />"
            } else {
                ret = ret + "<img src=\"\(source)\" />"
            }
            return ret
        } else if let codeBlock = p as? CodeBlock {
            if codeBlock.language == "box" {
                ret = ret + "<div class=\"box\">"
            } else if codeBlock.language == "info" {
                ret = ret + "<div class=\"alert show alert-info fade\">"
            } else if codeBlock.language == "url" {
                ret = ret + "<div class=\"url\">"
            } else if let language = codeBlock.language {
                ret = ret + "<pre><code class=\"language-\(language)\">\(codeBlock.code)</code></pre>"
                // we do not want to parse the code haha
                return ret
            }
            let c = Document(parsing: codeBlock.code)
            ret = ret + self.renderChildXML(c, config: config)
        } else if let h = p as? Heading {
            if h.level == 1 {
                ret = ret + "<h1>"
            } else if h.level == 2 {
                ret = ret + "<h2>"
            } else if h.level == 3 {
                ret = ret + "<h3>"
            } else if h.level == 4 {
                ret = ret + "<h4>"
            } else if h.level == 5 {
                ret = ret + "<h5>"
            } else if h.level == 6 {
                ret = ret + "<h6>"
            }
        }
        else {
            // In a final product we would not need this.
            // As the markdown library has not released any official releases yet
            // I'll leave it in until we know thre won't be any more.
            // PR's welcome
            #if DEBUG
                print("unkown element1: ", type(of: p))
            #endif
        }
        
        for c in p.children {
            ret = ret + self.renderChildXML(c, config: config)
        }

        if let h = p as? Heading {
            if h.level == 1 {
                ret = ret + "</h1>"
            } else if h.level == 2 {
                ret = ret + "</h2>"
            } else if h.level == 3 {
                ret = ret + "</h3>"
            } else if h.level == 4 {
                ret = ret + "</h4>"
            } else if h.level == 5 {
                ret = ret + "</h5>"
            } else if h.level == 6 {
                ret = ret + "</h6>"
            }
        }
        else if let link = p as? Link {
            ret = ret + "</a>"
        }
        else if let codeBlock = p as? CodeBlock {
            ret = ret + "</div>"
        }
        else if let li = p as? ListItem {
            ret = ret + "</li>"
        }
        else if let inlindeCode = p as? InlineCode {
            ret = ret + "</code>"
        }
        else if let strong = p as? Strong {
            ret = ret + "</strong>"
        }
        else if let i = p as? Emphasis {
            ret = ret + "</i>"
        }
        else if let blockQuote = p as? BlockQuote {
            ret = ret + "</blockquote>"
        }
        else if let strikethrough = p as? Strikethrough {
            ret = ret + "</s>"
        }
        else if let ul = p as? UnorderedList {
            ret = ret + "</ul>"
        }
        else if let ol = p as? OrderedList {
            ret = ret + "</ol>"
        }
        else if let table = p as? Table {
            ret = ret + "</table>"
       }
        else if let tableHead = p as? Table.Head {
            ret = ret + "</thead>"
       }
        else  if let tableBody = p as? Table.Body {
           ret = ret + "</tbody>"
      }
        else if let tableRow = p as? Table.Row {
            ret = ret + "</tr>"
       }
        else if let tableCell = p as? Table.Cell {
            ret = ret + "</td>"
       }
        else if let para = p as? Paragraph {
            ret = ret + "</p>"
        }
        return ret
    }
       
}

