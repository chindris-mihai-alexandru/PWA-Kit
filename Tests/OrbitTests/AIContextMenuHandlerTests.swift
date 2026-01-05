// Orbit AI Sidecar - AI Context Menu Handler Tests
//
// Tests for AIContextMenuHandler and context menu integration

import XCTest
@testable import Orbit

final class AIContextMenuHandlerTests: XCTestCase {
    
    // MARK: - Notification Name Tests
    
    func testAskOrbitAINotificationNameExists() {
        let name = Notification.Name.askOrbitAI
        XCTAssertEqual(name.rawValue, "com.orbit.askOrbitAI")
    }
    
    // MARK: - AI Context Menu Action Tests
    
    func testAIContextMenuActionExplain() {
        let action = AIContextMenuAction.explain
        XCTAssertEqual(action.rawValue, "explain")
    }
    
    func testAIContextMenuActionSummarize() {
        let action = AIContextMenuAction.summarize
        XCTAssertEqual(action.rawValue, "summarize")
    }
    
    func testAIContextMenuActionTranslate() {
        let action = AIContextMenuAction.translate
        XCTAssertEqual(action.rawValue, "translate")
    }
    
    func testAIContextMenuActionDefine() {
        let action = AIContextMenuAction.define
        XCTAssertEqual(action.rawValue, "define")
    }
    
    func testAIContextMenuActionAsk() {
        let action = AIContextMenuAction.ask
        XCTAssertEqual(action.rawValue, "ask")
    }
    
    // MARK: - Handler Singleton Tests
    
    func testAIContextMenuHandlerSharedInstance() {
        let handler = AIContextMenuHandler.shared
        XCTAssertNotNil(handler)
    }
    
    func testAIContextMenuTargetSharedInstance() {
        let target = AIContextMenuTarget.shared
        XCTAssertNotNil(target)
    }
    
    func testAIContextMenuTargetIsSingleton() {
        let target1 = AIContextMenuTarget.shared
        let target2 = AIContextMenuTarget.shared
        XCTAssertTrue(target1 === target2)
    }
}
