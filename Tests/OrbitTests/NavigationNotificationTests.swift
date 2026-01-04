/// Orbit Navigation Notification Tests
///
/// Unit tests for Notification.Name extensions used for AI sidebar integration

import XCTest
@testable import Orbit

final class NavigationNotificationTests: XCTestCase {
    
    // MARK: - Notification Name Value Tests
    
    func testWebViewDidFinishNavigationName() {
        XCTAssertEqual(
            Notification.Name.webViewDidFinishNavigation.rawValue,
            "com.orbit.webViewDidFinishNavigation"
        )
    }
    
    func testWebViewDidStartNavigationName() {
        XCTAssertEqual(
            Notification.Name.webViewDidStartNavigation.rawValue,
            "com.orbit.webViewDidStartNavigation"
        )
    }
    
    // MARK: - Notification Names Are Distinct
    
    func testNavigationNotificationNamesAreDistinct() {
        XCTAssertNotEqual(
            Notification.Name.webViewDidFinishNavigation,
            Notification.Name.webViewDidStartNavigation
        )
    }
    
    // MARK: - Notification Name Usability Tests
    
    func testNotificationNamesCanBeUsedWithNotificationCenter() {
        // Verify the names can be used to post and observe notifications
        let expectation = XCTestExpectation(description: "Notification received")
        
        let observer = NotificationCenter.default.addObserver(
            forName: .webViewDidFinishNavigation,
            object: nil,
            queue: .main
        ) { notification in
            expectation.fulfill()
        }
        
        NotificationCenter.default.post(name: .webViewDidFinishNavigation, object: nil)
        
        wait(for: [expectation], timeout: 1.0)
        NotificationCenter.default.removeObserver(observer)
    }
    
    func testStartNavigationNotificationCanBePosted() {
        let expectation = XCTestExpectation(description: "Start navigation notification received")
        
        let observer = NotificationCenter.default.addObserver(
            forName: .webViewDidStartNavigation,
            object: nil,
            queue: .main
        ) { notification in
            expectation.fulfill()
        }
        
        NotificationCenter.default.post(name: .webViewDidStartNavigation, object: nil)
        
        wait(for: [expectation], timeout: 1.0)
        NotificationCenter.default.removeObserver(observer)
    }
    
    // MARK: - Notification UserInfo Tests
    
    func testFinishNavigationNotificationCanIncludeUserInfo() {
        let expectation = XCTestExpectation(description: "Notification with userInfo received")
        let testURL = URL(string: "https://example.com")!
        let testTitle = "Example Page"
        
        let observer = NotificationCenter.default.addObserver(
            forName: .webViewDidFinishNavigation,
            object: nil,
            queue: .main
        ) { notification in
            let userInfo = notification.userInfo
            XCTAssertEqual(userInfo?["url"] as? URL, testURL)
            XCTAssertEqual(userInfo?["title"] as? String, testTitle)
            expectation.fulfill()
        }
        
        NotificationCenter.default.post(
            name: .webViewDidFinishNavigation,
            object: nil,
            userInfo: ["url": testURL, "title": testTitle]
        )
        
        wait(for: [expectation], timeout: 1.0)
        NotificationCenter.default.removeObserver(observer)
    }
    
    func testStartNavigationNotificationCanIncludeURL() {
        let expectation = XCTestExpectation(description: "Start notification with URL received")
        let testURL = URL(string: "https://example.com/page")!
        
        let observer = NotificationCenter.default.addObserver(
            forName: .webViewDidStartNavigation,
            object: nil,
            queue: .main
        ) { notification in
            let userInfo = notification.userInfo
            XCTAssertEqual(userInfo?["url"] as? URL, testURL)
            expectation.fulfill()
        }
        
        NotificationCenter.default.post(
            name: .webViewDidStartNavigation,
            object: nil,
            userInfo: ["url": testURL]
        )
        
        wait(for: [expectation], timeout: 1.0)
        NotificationCenter.default.removeObserver(observer)
    }
}
