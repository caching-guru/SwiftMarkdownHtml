//
//  MarkdownTest.swift
//  MarkdownHtml
//
//  Created by Ralph Kuepper on 02/15/23.
//  Copyright © 2023 Ralph Kuepper. All rights reserved.
//

import XCTest
@testable import MarkdownHtml



class MarkdownTest: XCTestCase {
    func testCodeInContext() {
        let article = """

        In this example, we have imported the React Helmet library and used it to add a title and description meta tag to our website. The <title> tag sets the title of the page, which will be displayed in the browser's title bar. The <meta> tag sets the page's description, which search engines will use to summarize the content.

        ## Keyword Meta Tag

        The keyword meta tag is used to provide a list of keywords that describe the content of your website. Search engines use this information to determine the relevancy of your website to specific keywords.
        Here's an example of how to use React Helmet to add a keyword meta tag to your React website:

        ```javascript

        import React from "react";
        import { Helmet } from "react-helmet";

        function MyApp() {
          return (
            <div>
              <Helmet>
                <title>My React Website</title>
                <meta name="description" content="A website built with React" />
                <meta name="keywords" content="React, JavaScript, Web Development" />
              </Helmet>
              {/* Your component code here */}
            </div>
          );
        }

        export default MyApp;
        ```

        In this example, we have added a <meta name="keywords"> tag to provide a list of keywords that describe the content of our website. It is important to note that the keyword meta tag is less important than it used to be, and some search engines may ignore it. However, it is still a good practice to include it, and it can help improve the relevancy of your website for specific keywords.
        Meta Tag for Social Media

        """
        var config = MarkdownXMLConfig()
        config.escapeCodeBlocks = true
        let xml = article.renderMarkdownToXML(config)
        print("\n\nxml: \n", xml)
    }
    func testHtmlTag() {
        let md = """
        In this example, we have imported the React Helmet library and used it to add a title and description meta tag to our website. The <title> tag sets the title of the page, which will be displayed in the browser's title bar. The <meta> tag sets the page's description, which search engines will use to summarize the content.
        """
        let xml = md.renderMarkdownToXML()
        print("xml:\n", xml)
    }
    func testInlineCode() {
        let md = "testing `<title>`-tag feature"
        var c = MarkdownXMLConfig()
        c.escapeCodeBlocks = true
        let xml = md.renderMarkdownToXML(c)
        print("xml: ", xml)
    }

    func testInlineHtml() {
        XCTAssertEqual("<p>and <htmltag><del>tags</del></htmltag> supported</p>", " and <del>tags</del> supported".renderMarkdownToXML())
    }

    func testHeadlines() {
        XCTAssertEqual("<h1>h1 headline</h1>", "# h1 headline".renderMarkdownToXML())
        XCTAssertEqual("<h2>h2 headline</h2>", "## h2 headline".renderMarkdownToXML())
        XCTAssertEqual("<h3>h3 headline</h3>", "### h3 headline".renderMarkdownToXML())
        XCTAssertEqual("<h4>h4 headline</h4>", "#### h4 headline".renderMarkdownToXML())
        XCTAssertEqual("<h5>h5 headline</h5>", "##### h5 headline".renderMarkdownToXML())
        XCTAssertEqual("<h6>h6 headline</h6>", "###### h6 headline".renderMarkdownToXML())
        XCTAssertEqual("<h1>Alt-H1</h1>", """
                Alt-H1
                ======
                """.renderMarkdownToXML())
        XCTAssertEqual("<h2>Alt-H2</h2>", """
                Alt-H2
                ------
                """.renderMarkdownToXML())
        XCTAssertEqual("<h6>h6 headline</h6>", "###### h6 headline".renderMarkdownToXML())
        

        
    }
    
    func testTexts() {
        XCTAssertEqual("<p>Emphasis, aka italics, with <i>asterisks</i> or <i>underscores</i>.</p>", "Emphasis, aka italics, with *asterisks* or _underscores_.".renderMarkdownToXML())
        XCTAssertEqual("<p>Strong emphasis, aka bold, with <strong>asterisks</strong> or <strong>underscores</strong>.</p>", "Strong emphasis, aka bold, with **asterisks** or __underscores__.".renderMarkdownToXML())
        XCTAssertEqual("<p>Combined emphasis with <strong>asterisks and <i>underscores</i></strong>.</p>", "Combined emphasis with **asterisks and _underscores_**.".renderMarkdownToXML())
        XCTAssertEqual("<p><s>Scratch this.</s></p>", "~~Scratch this.~~".renderMarkdownToXML())
        XCTAssertEqual("<p><strong>This is bold text</strong></p>", "**This is bold text**".renderMarkdownToXML())
        XCTAssertEqual("<p><strong>This is bold text</strong></p>", "__This is bold text__".renderMarkdownToXML())
        
        XCTAssertEqual("<p><i>This is italic text</i></p>", "*This is italic text*".renderMarkdownToXML())
        XCTAssertEqual("<p><i>This is italic text</i></p>", "_This is italic text_".renderMarkdownToXML())
        XCTAssertEqual("<p><s>Strikethrough</s></p>", "~~Strikethrough~~".renderMarkdownToXML())
        XCTAssertEqual("<ol><li><p>First ordered list item</p></li><li><p>Another item</p></li></ol>", """
1. First ordered list item
2. Another item
""".renderMarkdownToXML())
        XCTAssertEqual("<ul><li><p>Unordered sub-list.</p></li><li><p>And another item.</p></li></ul>", """
        * Unordered sub-list.
        * And another item.
        """.renderMarkdownToXML())
        
        XCTAssertEqual("<p>regular text</p>", "regular text".renderMarkdownToXML())
        
    }
    
    func testLargeMarkdown() {
        let markdownTest = """
        # h1 Heading 8-)
        ## h2 Heading
        ### h3 Heading
        #### h4 Heading
        ##### h5 Heading
        ###### h6 Heading

        Alternatively, for H1 and H2, an underline-ish style:

        Alt-H1
        ======

        Alt-H2
        ------

        Emphasis, aka italics, with *asterisks* or _underscores_.

        Strong emphasis, aka bold, with **asterisks** or __underscores__.

        Combined emphasis with **asterisks and _underscores_**.

        Strikethrough uses two tildes. ~~Scratch this.~~

        **This is bold text**

        __This is bold text__

        *This is italic text*

        _This is italic text_

        ~~Strikethrough~~

        1. First ordered list item
        2. Another item
        * Unordered sub-list.
        * And another item.

        ⋅⋅⋅You can have properly indented paragraphs within list items. Notice the blank line above, and the leading spaces (at least one, but we'll use three here to also align the raw Markdown).

        ⋅⋅⋅To have a line break without a paragraph, you will need to use two trailing spaces.⋅⋅
        ⋅⋅⋅Note that this line is separate, but within the same paragraph.⋅⋅
        ⋅⋅⋅(This is contrary to the typical GFM line break behaviour, where trailing spaces are not required.)

        * Unordered list can use asterisks
        - Or minuses
        + Or pluses

        1. Make my changes
            1. Fix bug
            2. Improve formatting
                - Make the headings bigger
        2. Push my commits to GitHub
        3. Open a pull request
            * Describe my changes
            * Mention all the members of my team
                * Ask for feedback

        + Create a list by starting a line with `+`, `-`, or `*`
        + Sub-lists are made by indenting 2 spaces:
          - Marker character change forces new list start:
            * Ac tristique libero volutpat at
            + Facilisis in pretium nisl aliquet
            - Nulla volutpat aliquam velit
        + Very easy!

        - [x] Finish my changes
        - [ ] Push my commits to GitHub
        - [ ] Open a pull request
        - [x] @mentions, #refs, [links](), **formatting**, and <del>tags</del> supported
        - [x] list syntax required (any unordered or ordered list supported)
        - [x] this is a complete item
        - [ ] this is an incomplete item

        [I'm an inline-style link](https://www.google.com)

        [I'm an inline-style link with title](https://www.google.com "Google's Homepage")

        [I'm a reference-style link][Arbitrary case-insensitive reference text]

        [I'm a relative reference to a repository file](../blob/master/LICENSE)

        [You can use numbers for reference-style link definitions][1]

        Or leave it empty and use the [link text itself].

        URLs and URLs in angle brackets will automatically get turned into links.
        http://www.example.com or <http://www.example.com> and sometimes
        example.com (but not on Github, for example).

        Some text to show that the reference links can follow later.

        [arbitrary case-insensitive reference text]: https://www.mozilla.org
        [1]: http://slashdot.org
        [link text itself]: http://www.reddit.com

        Here's our logo (hover to see the title text):

        Inline-style:
        ![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")

        Reference-style:
        ![alt text][logo]

        [logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"

        ![Minion](https://octodex.github.com/images/minion.png)
        ![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")

        Like links, Images also have a footnote style syntax

        ![Alt text][id]

        With a reference later in the document defining the URL location:

        [id]: https://octodex.github.com/images/dojocat.jpg  "The Dojocat"

        Footnote 1 link[^first].

        Footnote 2 link[^second].

        Inline footnote^[Text of inline footnote] definition.

        Duplicated footnote reference[^second].

        [^first]: Footnote **can have markup**

            and multiple paragraphs.

        [^second]: Footnote text.

        Colons can be used to align columns.

        | Tables        | Are           | Cool  |
        | ------------- |:-------------:| -----:|
        | col 3 is      | right-aligned | $1600 |
        | col 2 is      | centered      |   $12 |
        | zebra stripes | are neat      |    $1 |

        There must be at least 3 dashes separating each header cell.
        The outer pipes (|) are optional, and you don't need to make the
        raw Markdown line up prettily. You can also use inline Markdown.

        Markdown | Less | Pretty
        --- | --- | ---
        *Still* | `renders` | **nicely**
        1 | 2 | 3

        | First Header  | Second Header |
        | ------------- | ------------- |
        | Content Cell  | Content Cell  |
        | Content Cell  | Content Cell  |

        | Command | Description |
        | --- | --- |
        | git status | List all new or modified files |
        | git diff | Show file differences that haven't been staged |

        | Command | Description |
        | --- | --- |
        | `git status` | List all *new or modified* files |
        | `git diff` | Show file differences that **haven't been** staged |

        | Left-aligned | Center-aligned | Right-aligned |
        | :---         |     :---:      |          ---: |
        | git status   | git status     | git status    |
        | git diff     | git diff       | git diff      |

        | Name     | Character |
        | ---      | ---       |
        | Backtick | `         |


        > Blockquotes are very handy in email to emulate reply text.
        > This line is part of the same quote.

        Quote break.

        > This is a very long line that will still be quoted properly when it wraps. Oh boy let's keep writing to make sure this is long enough to actually wrap for everyone. Oh, you can *put* **Markdown** into a blockquote.

        > Blockquotes can also be nested...
        >> ...by using additional greater-than signs right next to each other...
        > > > ...or with spaces between arrows.


        ```javascript

        console.log("this is now english but should also stay english");
        ```

        `this inline code should stay the same too`

        Three or more...

        ---

        Hyphens

        ***

        Asterisks

        ___

        Underscores

        [![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](http://www.youtube.com/watch?v=YOUTUBE_VIDEO_ID_HERE)

        Finish

        """
        let res = markdownTest.renderMarkdownToXML()
        XCTAssert(res.count>100)
    }


}

