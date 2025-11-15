# WebKitForge Strategic Decisions

**Date**: November 15, 2025  
**Status**: Phase 1 Complete, Transitioning to Phase 2

---

## Critical Decisions Made

### 1. **Project Naming: Keep "MacPin" for Now, Rebrand Later** ✅

**Decision**: Keep GitHub fork as `chindris-mihai-alexandru/MacPin` until v0.5+

**Reasoning**:
- Original MacPin has **339 stars** and brand recognition
- Renaming fork now loses discoverability (people searching "MacPin alternative")
- Better SEO: "MacPin modernized" > "WebKitForge unknown project"
- Gradual transition strategy:
  - **v0.1-0.4**: Market as "MacPin Modernized Edition"
  - **v0.5+**: Soft rebrand as "WebKitForge (formerly MacPin)"
  - **v1.0**: Full rebrand with new repo, archive old one

**Internal Use**:
- Local directory: `<project-root>/` (easier to remember)
- Code namespace: Still `MacPin` module (avoid breaking changes)
- Marketing: "WebKitForge" in docs/website (test market receptivity)

**Action Items**:
- ✅ Keep `Package.swift` name as "MacPin"
- ✅ Update README.md to mention "WebKitForge modernization project"
- ⏳ Register `webkitforge.org` domain (placeholder landing page)
- ⏳ Create Twitter/social accounts as @WebKitForge (brand building)

---

### 2. **Upstream Strategy: NO Pull Requests to Original MacPin** ✅

**Decision**: Maintain independent fork, do NOT submit PRs to kfix/MacPin

**Reasoning**:
1. **Original repo is inactive** (last commit Nov 2022, 3 years old)
2. **No maintenance**: Owner (kfix) hasn't responded to issues in 2+ years
3. **Different goals**: 
   - MacPin = educational project
   - WebKitForge = production-ready PWA creator
4. **Our changes are too extensive**:
   - macOS 11 → 14 (breaks backward compat intentionally)
   - Swift 5.4 → 5.10 → 6.0 (major language changes)
   - Architectural changes planned (SwiftUI builder, modular design)

**Alternative Actions**:
- ✅ Credit MacPin in README and LICENSE
- ✅ Link to original repo prominently
- ⏳ Open GitHub Discussion in original repo: "Modernized fork available at..."
  - Not an issue (respectful)
  - Informs community without demanding maintainer action
  - Drives traffic to our fork
- ⏳ Email kfix@github personally (one-time, polite FYI)

**License Compliance**:
- ✅ Keep GPL-3.0 license
- ✅ Maintain copyright attributions
- ✅ Document all changes in CHANGELOG.md
- ✅ Prominently state "Based on MacPin by kfix" in all docs

---

### 3. **Repository Cleanup Strategy** ✅

**Decision**: Restructure `<legacy-dir>/` immediately

**Current Mess**:
```
<legacy-dir>/
├── WebKitForge/           # Active project
├── UniteFixKit.m          # Old Unite hack (REMOVE)
├── UniteFixKit.dylib      # Old Unite hack (REMOVE)
├── VERSION.txt            # Old Unite hack (REMOVE)
├── USER_GUIDE.txt         # Old Unite hack (REMOVE)
├── RELEASE_NOTES_*.txt    # Old Unite hack (REMOVE)
└── ... other cruft ...
```

**Clean Structure**:
```
<projects-dir>/
└── WebKitForge/           # Single project directory
    ├── .git/
    ├── Package.swift
    ├── ROADMAP.md
    ├── DECISIONS.md       # This file
    ├── Sources/
    ├── Tools/
    ├── sites/
    └── build/
```

**Migration Plan**:
```bash
# Step 1: Move WebKitForge out of UniteFixKit
cd <parent-dir>
mkdir -p Projects
mv UniteFixKit/WebKitForge Projects/WebKitForge

# Step 2: Archive old UniteFixKit work (don't delete, might learn from it)
mkdir -p Archives/UniteFixKit-Archive-2025-11-15
mv UniteFixKit/* Archives/UniteFixKit-Archive-2025-11-15/
rmdir UniteFixKit

# Step 3: Uninstall Unite & Coherence from system
# (Done manually via user action)

# Step 4: Update git remote if needed (should still work)
cd Projects/WebKitForge
git remote -v  # Verify still points to GitHub
```

**Benefits**:
- Clean mental model: One project = one directory
- No confusion between old failed iterations and current work
- Easier to navigate
- Professional structure for contributors

---

### 4. **Swift Version Strategy: 5.10 Now, 6.0 in Phase 1.5** ✅

**Decision**: Ship v0.1-0.3 with Swift 5.10, adopt 6.0 in Phase 1.5 (after GUI builder works)

**Rationale** (from best practices analysis):
- Swift 6 strict concurrency is **correct** but **time-consuming** to fix
- Better to ship working MVP fast than perfect code slowly
- Users care about functionality, not Swift version
- Community can help fix concurrency issues once interested

**Phase 1.5 Plan** (2-3 weeks after Phase 2 starts):
1. Add `@MainActor` to all UI classes properly
2. Fix `AppScriptRuntime.shared` singleton with proper isolation
3. Mark `Geolocator`, `WebNotifier` as `@MainActor` classes
4. Use `nonisolated(unsafe)` sparingly, document why
5. Run with `-warnings-as-errors` to catch new issues
6. Update `Package.swift` to `swift-tools-version:6.0`

---

### 5. **Memory Optimization Priority: Phase 2, Not Phase 1** ✅

**Decision**: Get GUI builder working FIRST, then optimize memory

**Why**:
- Users need to CREATE apps before they care about RAM usage
- Can't measure "is it better than Safari?" without apps to test
- Marketing copy needs real benchmarks ("uses 60% less RAM" requires proof)

**Memory Baseline Plan** (Week 3-4):
1. Build 5 test apps (Gmail, Slack, Twitter, Reddit, Discord)
2. Launch all 5 simultaneously
3. Measure RAM in Activity Monitor + Instruments
4. Compare to:
   - Safari (5 windows open to same sites)
   - Unite (if still have it installed)
   - Raw numbers (800MB total = excellent, 1.5GB = acceptable, 2GB+ = bad)
5. Document findings in `docs/benchmarks/memory-usage.md`
6. Use findings to guide optimizations in Phase 2

**Target Metrics**:
- Per-app baseline: <100MB idle, <150MB active browsing
- Shared framework overhead: <50MB
- Total for 5 apps: <800MB (vs Safari's ~1.5GB)

---

### 6. **Distribution Strategy: Homebrew + DMG, No App Store** ✅

**Decision**: Distribute via Homebrew Cask initially, add DMG download later

**Homebrew Formula** (v0.1+):
```ruby
cask "webkitforge" do
  version "0.1.0"
  sha256 "..."

  url "https://github.com/chindris-mihai-alexandru/MacPin/releases/download/v#{version}/WebKitForge-#{version}.dmg"
  name "WebKitForge"
  desc "Lightweight open-source PWA creator for macOS"
  homepage "https://webkitforge.org"

  app "WebKitForge.app"
  
  zap trash: [
    "~/Library/Application Support/org.webkitforge.WebKitForge",
    "~/Library/Caches/org.webkitforge.WebKitForge",
  ]
end
```

**Why No App Store**:
- Requires $99/year (no budget yet)
- GPL license conflicts with App Store terms
- Review process slow (2+ weeks per update)
- Can't distribute generated PWAs via App Store anyway

**Code Signing Strategy** (v0.1-0.5):
- Build unsigned for early adopters
- Document workaround: `xattr -cr WebKitForge.app`
- Add to README as "Known Issue: macOS Gatekeeper warning"

**Code Signing Strategy** (v1.0+):
- Pay $99/year from sponsorships/donations
- Notarize all releases
- Distribute signed DMG
- Update Homebrew cask to use signed version

---

### 7. **GUI App Builder Tech Stack: SwiftUI + Combine** ✅

**Decision**: Pure SwiftUI for app builder UI (Phase 2)

**Why SwiftUI**:
- ✅ Modern, declarative, less code
- ✅ Native macOS 14+ integration
- ✅ Live preview in Xcode
- ✅ Easier for contributors (less AppKit boilerplate)
- ✅ Future iOS version uses same code

**Why NOT AppKit**:
- ❌ Verbose (NIBs, outlets, delegates)
- ❌ Harder to test
- ❌ Can't share code with iOS

**Architecture**:
```swift
// AppBuilderView.swift (SwiftUI)
struct AppBuilderView: View {
    @StateObject var config = AppConfiguration()
    
    var body: some View {
        Form {
            Section("Basic") { /* URL, name, icon */ }
            Section("Advanced") { /* JS injection, CSS */ }
        }
        .toolbar {
            Button("Create App") { createApp(config) }
        }
    }
}

// AppConfiguration.swift (Combine)
@MainActor
class AppConfiguration: ObservableObject {
    @Published var url: String = ""
    @Published var name: String = ""
    @Published var icon: NSImage?
    @Published var customJS: String = ""
    
    var isValid: Bool {
        !url.isEmpty && !name.isEmpty
    }
}

// AppBundleBuilder.swift (async/await)
actor AppBundleBuilder {
    func createApp(config: AppConfiguration) async throws -> URL {
        // Build .app bundle off main thread
        let bundleURL = try await buildBundle(config)
        return bundleURL
    }
}
```

---

### 8. **Testing Strategy: Manual First, Automated Later** ⏳

**Decision**: Ship v0.1 with manual testing only, add automated tests in v0.2+

**v0.1 Testing Checklist** (Manual):
- [ ] Can create a basic PWA (Gmail test)
- [ ] App launches without crash
- [ ] JavaScript bridge works (basic `alert()` test)
- [ ] Tabs work (no visibility bugs)
- [ ] Memory usage reasonable (<150MB per app)
- [ ] macOS 14 + 15 tested

**v0.2+ Automated Testing**:
```swift
// Tests/WebKitForgeTests/AppBuilderTests.swift
class AppBuilderTests: XCTestCase {
    func testCreateBasicApp() async throws {
        let config = AppConfiguration()
        config.url = "https://gmail.com"
        config.name = "Gmail"
        
        let builder = AppBundleBuilder()
        let bundleURL = try await builder.createApp(config)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: bundleURL.path))
        XCTAssertTrue(bundleURL.pathExtension == "app")
    }
}
```

---

### 9. **Community Building Strategy** ⏳

**Launch Timeline**:
- **Week 1 (v0.1)**: Hacker News post
  - Title: "WebKitForge: Open-source PWA creator for macOS (60% less RAM than Safari)"
  - Lead with benchmarks
  - HN guidelines: technical, no hype, honest about limitations
- **Week 2**: Reddit (`r/macapps`, `r/programming`, `r/swift`)
- **Week 3**: Product Hunt (soft launch)
- **Week 4**: Reach out to Mac bloggers (9to5Mac, MacRumors forums)

**GitHub Setup** (Before v0.1 launch):
- [ ] Enable GitHub Discussions
- [ ] Add issue templates:
  - Bug report
  - Feature request
  - Question
- [ ] Add `CONTRIBUTING.md`
- [ ] Add `CODE_OF_CONDUCT.md` (Contributor Covenant)
- [ ] Add `SECURITY.md` (vulnerability disclosure)
- [ ] Pin issues: "v0.1 Roadmap", "Known Issues", "FAQ"

---

### 10. **Key Performance Indicators (KPIs)** 📊

**Success Metrics**:
- **v0.1 (Week 4)**: 50+ GitHub stars
- **v0.3 (Week 8)**: 200+ stars, 5+ community PRs
- **v0.5 (Week 12)**: 500+ stars, featured in Mac blog
- **v1.0 (Week 24)**: 1,000+ stars, 50+ community contributors, sustainable

**Failure Indicators** (pivot if these happen):
- <20 stars after HN launch → marketing problem, need better pitch
- 0 community PRs after 2 months → code too complex, need better docs
- High RAM usage (>200MB per app) → architecture problem, need redesign

---

## Next Immediate Actions

### Today (Nov 15, 2025):
1. ✅ Complete this DECISIONS.md
2. ⏳ Move repository to clean location
3. ⏳ Test example app build and launch
4. ⏳ Double-check all modernization changes
5. ⏳ Push to GitHub

### This Week:
1. Start GUI App Builder (SwiftUI prototype)
2. Design app configuration data model
3. Implement basic "Create App" flow (no icon generation yet)
4. Test end-to-end: Builder → .app bundle → Launch → Works

### Next Week:
1. Add icon generation (favicon fetching)
2. Add live preview in builder
3. Memory usage baseline testing
4. Prepare v0.1 release notes

---

## Questions to Revisit

1. **Electron-style APIs**: Should we provide Electron-compatible APIs for easier migration?
   - Decision deferred to community feedback
   
2. **Windows/Linux support**: Worth the effort?
   - Decision: macOS-only until v1.0, then re-evaluate
   
3. **Plugin system**: Allow third-party extensions?
   - Decision: Not until v2.0 (keep MVP simple)

---

**Last Updated**: November 15, 2025  
**Next Review**: December 1, 2025 (after v0.1 launch)
