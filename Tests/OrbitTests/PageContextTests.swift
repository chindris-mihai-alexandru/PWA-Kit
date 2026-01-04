/// Orbit PageContext Tests
///
/// Unit tests for PageContext struct and related functionality

import XCTest
@testable import Orbit

final class PageContextTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testPageContextDefaultInit() {
        let context = PageContext()
        
        XCTAssertNil(context.url)
        XCTAssertNil(context.title)
        XCTAssertNil(context.selectedText)
        XCTAssertNil(context.pageContent)
    }
    
    func testPageContextWithAllProperties() {
        let url = URL(string: "https://example.com")!
        let context = PageContext(
            url: url,
            title: "Example Page",
            selectedText: "Selected text here",
            pageContent: "Full page content"
        )
        
        XCTAssertEqual(context.url, url)
        XCTAssertEqual(context.title, "Example Page")
        XCTAssertEqual(context.selectedText, "Selected text here")
        XCTAssertEqual(context.pageContent, "Full page content")
    }
    
    func testPageContextWithPartialProperties() {
        let context = PageContext(
            url: URL(string: "https://test.com"),
            title: "Test"
        )
        
        XCTAssertNotNil(context.url)
        XCTAssertEqual(context.title, "Test")
        XCTAssertNil(context.selectedText)
        XCTAssertNil(context.pageContent)
    }
    
    // MARK: - hasContent Tests
    
    func testHasContentWithNoContent() {
        let context = PageContext()
        XCTAssertFalse(context.hasContent)
    }
    
    func testHasContentWithOnlyURLAndTitle() {
        let context = PageContext(
            url: URL(string: "https://example.com"),
            title: "Title"
        )
        XCTAssertFalse(context.hasContent)
    }
    
    func testHasContentWithSelectedText() {
        let context = PageContext(selectedText: "Some selected text")
        XCTAssertTrue(context.hasContent)
    }
    
    func testHasContentWithPageContent() {
        let context = PageContext(pageContent: "Page content here")
        XCTAssertTrue(context.hasContent)
    }
    
    func testHasContentWithBothTextAndContent() {
        let context = PageContext(
            selectedText: "Selected",
            pageContent: "Content"
        )
        XCTAssertTrue(context.hasContent)
    }
    
    func testHasContentWithEmptyStringsIsNilNotEmpty() {
        // Empty strings would be nil from the extractor
        let context = PageContext(
            selectedText: nil,
            pageContent: nil
        )
        XCTAssertFalse(context.hasContent)
    }
    
    // MARK: - URL Handling Tests
    
    func testPageContextWithHTTPSURL() {
        let url = URL(string: "https://secure.example.com/path?query=1")!
        let context = PageContext(url: url)
        
        XCTAssertEqual(context.url?.scheme, "https")
        XCTAssertEqual(context.url?.host, "secure.example.com")
        XCTAssertEqual(context.url?.path, "/path")
    }
    
    func testPageContextWithFileURL() {
        let url = URL(fileURLWithPath: "/Users/test/file.html")
        let context = PageContext(url: url)
        
        XCTAssertTrue(context.url?.isFileURL ?? false)
    }
    
    func testPageContextWithDataURL() {
        let url = URL(string: "data:text/html,<h1>Test</h1>")!
        let context = PageContext(url: url)
        
        XCTAssertEqual(context.url?.scheme, "data")
    }
}
