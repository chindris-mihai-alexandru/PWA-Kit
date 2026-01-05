// Orbit AI Sidecar - Context Menu Integration
//
// Adds "Ask Orbit AI" context menu item to WKWebView
// This enables users to right-click on selected text and ask AI about it.

#if os(OSX)
import AppKit
import WebKit

// MARK: - Context Menu Notification

public extension Notification.Name {
    /// Posted when user selects "Ask Orbit AI" from context menu
    /// Object: the WKWebView where the action was triggered
    /// UserInfo: ["selectedText": String, "action": String]
    static let askOrbitAI = Notification.Name("com.orbit.askOrbitAI")
}

// MARK: - AI Context Menu Actions

/// Available AI actions for the context menu
public enum AIContextMenuAction: String {
    case explain = "explain"
    case summarize = "summarize"
    case translate = "translate"
    case define = "define"
    case ask = "ask"
}

// MARK: - AI Context Menu Handler

/// Handles AI-related context menu items for WKWebView
public final class AIContextMenuHandler {
    
    public static let shared = AIContextMenuHandler()
    
    private init() {}
    
    // MARK: - Menu Item Creation
    
    /// Creates an "Ask Orbit AI" menu item
    /// - Parameter webView: The webView to associate with the action
    /// - Returns: NSMenuItem configured for AI action
    public func createAIMenuItem(for webView: WKWebView) -> NSMenuItem {
        let menuItem = NSMenuItem(
            title: "Ask Orbit AI",
            action: #selector(AIContextMenuTarget.askOrbitAI(_:)),
            keyEquivalent: ""
        )
        menuItem.image = NSImage(systemSymbolName: "brain.head.profile", accessibilityDescription: "Orbit AI")
        menuItem.representedObject = webView
        menuItem.target = AIContextMenuTarget.shared
        return menuItem
    }
    
    /// Creates a submenu with multiple AI actions
    /// - Parameter webView: The webView to associate with actions
    /// - Returns: NSMenuItem with submenu containing AI actions
    public func createAISubmenu(for webView: WKWebView) -> NSMenuItem {
        let submenu = NSMenu(title: "Orbit AI")
        
        // Explain action
        let explainItem = NSMenuItem(
            title: "Explain Selection",
            action: #selector(AIContextMenuTarget.explainWithOrbitAI(_:)),
            keyEquivalent: ""
        )
        explainItem.image = NSImage(systemSymbolName: "lightbulb", accessibilityDescription: "Explain")
        explainItem.representedObject = webView
        explainItem.target = AIContextMenuTarget.shared
        submenu.addItem(explainItem)
        
        // Define action
        let defineItem = NSMenuItem(
            title: "Define Selection",
            action: #selector(AIContextMenuTarget.defineWithOrbitAI(_:)),
            keyEquivalent: ""
        )
        defineItem.image = NSImage(systemSymbolName: "book", accessibilityDescription: "Define")
        defineItem.representedObject = webView
        defineItem.target = AIContextMenuTarget.shared
        submenu.addItem(defineItem)
        
        // Translate action
        let translateItem = NSMenuItem(
            title: "Translate Selection",
            action: #selector(AIContextMenuTarget.translateWithOrbitAI(_:)),
            keyEquivalent: ""
        )
        translateItem.image = NSImage(systemSymbolName: "globe", accessibilityDescription: "Translate")
        translateItem.representedObject = webView
        translateItem.target = AIContextMenuTarget.shared
        submenu.addItem(translateItem)
        
        submenu.addItem(NSMenuItem.separator())
        
        // General ask action
        let askItem = NSMenuItem(
            title: "Ask About Selection...",
            action: #selector(AIContextMenuTarget.askOrbitAI(_:)),
            keyEquivalent: ""
        )
        askItem.image = NSImage(systemSymbolName: "questionmark.circle", accessibilityDescription: "Ask")
        askItem.representedObject = webView
        askItem.target = AIContextMenuTarget.shared
        submenu.addItem(askItem)
        
        // Create parent menu item
        let parentItem = NSMenuItem(title: "Orbit AI", action: nil, keyEquivalent: "")
        parentItem.image = NSImage(systemSymbolName: "brain.head.profile", accessibilityDescription: "Orbit AI")
        parentItem.submenu = submenu
        
        return parentItem
    }
}

// MARK: - Context Menu Target

/// Target object for context menu actions
/// This needs to be a separate class because NSMenuItem targets need to be NSObject subclasses
@objc public final class AIContextMenuTarget: NSObject {
    
    public static let shared = AIContextMenuTarget()
    
    private override init() {
        super.init()
    }
    
    @objc func askOrbitAI(_ sender: NSMenuItem) {
        triggerAIAction(sender, action: .ask)
    }
    
    @objc func explainWithOrbitAI(_ sender: NSMenuItem) {
        triggerAIAction(sender, action: .explain)
    }
    
    @objc func defineWithOrbitAI(_ sender: NSMenuItem) {
        triggerAIAction(sender, action: .define)
    }
    
    @objc func translateWithOrbitAI(_ sender: NSMenuItem) {
        triggerAIAction(sender, action: .translate)
    }
    
    @objc func summarizeWithOrbitAI(_ sender: NSMenuItem) {
        triggerAIAction(sender, action: .summarize)
    }
    
    private func triggerAIAction(_ sender: NSMenuItem, action: AIContextMenuAction) {
        guard let webView = sender.representedObject as? WKWebView else { return }
        
        // Get selected text asynchronously
        Task { @MainActor in
            do {
                let selectedText = try await PageContextExtractor.extractSelectedText(from: webView) ?? ""
                
                // Post notification for AI sidebar to handle
                NotificationCenter.default.post(
                    name: .askOrbitAI,
                    object: webView,
                    userInfo: [
                        "selectedText": selectedText,
                        "action": action.rawValue
                    ]
                )
            } catch {
                print("[Orbit AI] Failed to get selected text: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - WKWebView Extension for Context Menu

public extension WKWebView {
    
    /// Override willOpenMenu to add AI menu items
    /// Call this from your WKWebView subclass
    func addAIContextMenuItems(to menu: NSMenu) {
        // Only add if there might be selected text
        // We add it unconditionally since checking selection is async
        
        // Find a good position - after "Look Up" if present, otherwise at the start
        var insertIndex = 0
        for (index, item) in menu.items.enumerated() {
            if item.title.contains("Look Up") || item.title.contains("Search with") {
                insertIndex = index + 1
                break
            }
        }
        
        // Insert separator if needed
        if insertIndex > 0 && insertIndex < menu.items.count {
            menu.insertItem(NSMenuItem.separator(), at: insertIndex)
            insertIndex += 1
        }
        
        // Add AI submenu
        let aiMenuItem = AIContextMenuHandler.shared.createAISubmenu(for: self)
        menu.insertItem(aiMenuItem, at: insertIndex)
        
        // Add separator after if there are more items
        if insertIndex < menu.items.count - 1 {
            menu.insertItem(NSMenuItem.separator(), at: insertIndex + 1)
        }
    }
}
#endif
