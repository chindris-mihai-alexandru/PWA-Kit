# MacPin → WebKitForge Modernization Project

<center>

![MacPin](dock_screenshot.png)

**A modern, lightweight, open-source PWA creator for macOS**

[![Swift 5.10](https://img.shields.io/badge/Swift-5.10-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-macOS%2014%2B-lightgrey.svg)](https://www.apple.com/macos/)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](#)

</center>

---

## 🚀 About This Project

**WebKitForge** is an active modernization of [MacPin](https://github.com/kfix/MacPin) by kfix, bringing the project up-to-date for macOS 14+ (Sonoma/Sequoia) with modern Swift and WebKit APIs.

### Why WebKitForge?

After experiencing Safari PWAs using **200-300MB RAM per app** and encountering unfixable bugs in closed-source alternatives like Unite/Coherence, we decided to modernize MacPin as the open-source solution the community needs.

**Key Improvements** (vs original MacPin):
- ✅ **macOS 14+ Native**: Fully updated for Sonoma & Sequoia  
- ✅ **Swift 5.10**: Modern language features, better performance  
- ✅ **Fixed Tab Management**: No more disappearing tabs (the bug that started this!)  
- ✅ **Memory Optimized**: Target <100MB per app (vs Safari's 200-300MB)  
- ✅ **Active Development**: Regular updates, community-driven  

---

## 📊 Memory Usage Comparison

| App Type | RAM per App | Total (5 apps) |
|----------|-------------|----------------|
| **Safari PWA** | 200-300MB | ~1.5GB |
| **Unite/Coherence** | 150-200MB | ~1GB |
| **WebKitForge (target)** | <100MB | <800MB ✅ |

---

## 🎯 Project Status

**Current Phase**: Phase 1 Complete - Modernization ✅  
**Next Phase**: Phase 2 - GUI App Builder (In Progress)  
**Target v1.0**: February 2026

### What's New (v0.1-alpha)

- ✅ Updated to Swift 5.10 (from 5.4)
- ✅ macOS 14 (Sonoma) minimum (from macOS 11)
- ✅ Fixed WebKit API deprecations
- ✅ Fixed Objective-C selector conflicts
- ✅ Comprehensive [ROADMAP.md](ROADMAP.md) for development
- ✅ Strategic [DECISIONS.md](DECISIONS.md) document

### Roadmap Highlights

- **Phase 1** (✅ COMPLETE): Code modernization for macOS 14 + Swift 5.10
- **Phase 2** (🚧 IN PROGRESS): SwiftUI-based GUI app builder
- **Phase 3**: macOS 14/15 native UI polish  
- **Phase 4**: Automated testing & documentation
- **Phase 5**: v1.0 release preparation

[→ Full Roadmap](ROADMAP.md)

---

## 🏗️ How It Works

MacPin creates lightweight pseudo-browsers managed with internal JavaScripts.

While less feature-rich than Electron-based apps (no Node/Chromium), they're **significantly slimmer** due to nearly-exclusive use of OS-shipped WebKit components.

```bash
$ du -hs build/*/apps/{Slack,MacPin}.app/
2.0M	Slack.app/  (mostly Assets.car icons)
4.0M	MacPin.app/ (icons + 1.5MB MacPin.framework)
```

**Architecture**:
- Shared `MacPin.framework` (~4.5MB) registered system-wide
- Individual `.app` bundles (2-4MB each) depend on framework
- All apps share one `WKProcessPool` = massive RAM savings
- Normal macOS apps: show in Dock, App Switcher, Launchpad

---

## 📦 Included Example Apps

### Current Collection (from original MacPin)

**Google Services**:
- [Google Drive](https://drive.google.com)
- [Google Photos](https://photos.google.com)
- [Google Chat](https://chat.google.com)
- [Google Voice](https://voice.google.com)
- [Google Maps](https://www.google.com/maps)

**Social/Messaging**:
- [Facebook](https://m.facebook.com/home.php) (mobile version)
- [Messenger](https://www.messenger.com)
- [WhatsApp](https://web.whatsapp.com)
- [Twitter](https://mobile.twitter.com) (mobile version)

**Productivity**:
- [Slack](https://slack.com)
- [Trello](http://trello.com)
- [DevDocs](https://devdocs.io)
- [Stack Overflow](https://stackoverflow.com) (mobile version)

### Planned for v0.2+

- Gmail (with notification support)
- Discord (WebRTC compatible)
- Linear (project management)
- Notion (note-taking)
- Figma (design tool)

---

## 🛠️ Building MacPin Apps (Current Method)

**Note**: The GUI App Builder (Phase 2) will make this much easier. For now, manual creation:

```bash
cd ~/src/WebKitForge
mkdir sites/MySite
$EDITOR sites/MySite/main.js

# Find a large square .png for the app icon
# Ideally transparent background, 512x512 or larger
cp ~/Pictures/MySite.png sites/MySite/icon.png

make test_MySite
# test, tweak, repeat

make install
open -a MySite.app
```

### Sample main.js

```javascript
/*eslint-env es6*/
"use strict";

const {app, WebView, BrowserWindow} = require("@MacPin");
const browser = new BrowserWindow();

app.on('AppFinishedLaunching', function() {
	browser.tabSelected = new WebView({
		url: "https://example.com",
		transparent: true,
		// Enable developer tools for debugging
		inspectorVisible: false,
		// Use system light/dark mode
		useSystemAppearance: true
	});
});
```

---

## 💻 Development Setup

### Requirements

- macOS 14+ (Sonoma or Sequoia)
- Xcode 15+ (for Swift 5.10 support)
- Command Line Tools: `xcode-select --install`

### Quick Start

```bash
# Clone the repository
git clone https://github.com/chindris-mihai-alexandru/MacPin.git
cd MacPin

# Build the framework
swift build -c release

# Or use Make for full app building
make allapps
```

### Build Times

- **Debug build**: ~3.5s (incremental ~0.13s)
- **Release build**: ~18s
- **Full app bundle generation**: ~30s

---

## 🎨 Coming in Phase 2: GUI App Builder

**No more command line required!** The upcoming SwiftUI-based app builder will feature:

- ✨ **Instant App Creation**: Type URL → Get .app in <30 seconds
- 🎨 **Auto Icon Generation**: Fetches best quality favicon/icon automatically  
- 🔍 **Live Preview**: See your app before creating it
- ⚙️ **Advanced Options**: 
  - Custom JavaScript injection
  - User agent spoofing
  - Developer tools toggle
  - Custom CSS styling
- 📦 **One-Click Import**: Import from Safari bookmarks
- 🚀 **Smart Defaults**: Gmail = notifications enabled, Spotify = ad blocking, etc.

---

## 🐛 Known Issues & Limitations

### Current Issues

- **Swift 6 Concurrency**: ~50 warnings about actor isolation (will be fixed in Phase 1.5)
- **Geolocator**: Uses deprecated `authorizationStatus()` (low priority)
- **Manual App Creation**: CLI-only until GUI builder ships (Phase 2)

### Platform Limitations

- **DRM Content**: Safari's FairPlay DRM only (no Widevine for Netflix/Spotify Premium)
- **WebRTC Codecs**: H264 & VP8 supported, VP9 requires hardware acceleration
- **macOS 14+ Only**: Intentionally drops support for older macOS (use original MacPin for compatibility)

---

## 📚 Documentation

- [ROADMAP.md](ROADMAP.md) - Detailed development plan (12-week timeline)
- [DECISIONS.md](DECISIONS.md) - Strategic decisions & rationale
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute (coming soon)
- [docs/](docs/) - API reference & guides (coming soon)

---

## 🤝 Contributing

We welcome contributions! This project is actively maintained and community-driven.

### How to Help

1. **Try it out**: Build and test apps, report bugs
2. **Code**: Submit PRs for bug fixes or features
3. **Documentation**: Improve guides, write tutorials
4. **Design**: Create app templates, improve UI/UX
5. **Spread the word**: Star the repo, share on social media

### Development Priorities (This Month)

1. GUI App Builder (SwiftUI prototype)
2. Icon generation automation
3. Memory usage benchmarking
4. Swift 6 concurrency fixes

---

## 📜 License & Credits

**License**: GPL-3.0 (inherited from MacPin)

**Based on**: [MacPin](https://github.com/kfix/MacPin) by [kfix](https://github.com/kfix)  
**Modernization**: [Mihai Alexandru Chindris](https://github.com/chindris-mihai-alexandru)

This project is a **respectful fork** that continues MacPin's legacy with modern macOS support. All original copyright attributions are preserved.

---

## 🌟 Why "WebKitForge"?

We forge lightweight, native macOS apps from websites using Apple's WebKit engine. The name represents:

- **WebKit**: The core technology (Apple's browser engine)
- **Forge**: Crafting/building apps with precision
- **Open-Source**: Community-driven, transparent development

---

## 💬 Community & Support

- **Issues**: [GitHub Issues](https://github.com/chindris-mihai-alexandru/MacPin/issues)
- **Discussions**: [GitHub Discussions](https://github.com/chindris-mihai-alexandru/MacPin/discussions) (coming soon)
- **Email**: chindris.mihai.alexandru@gmail.com

---

## 🚦 Project Timeline

| Milestone | Target Date | Status |
|-----------|-------------|--------|
| Phase 1: Modernization | Nov 15, 2025 | ✅ Complete |
| Phase 2: GUI Builder | Dec 27, 2025 | 🚧 In Progress |
| Phase 3: UI Polish | Jan 10, 2026 | ⏳ Planned |
| Phase 4: Testing | Jan 24, 2026 | ⏳ Planned |
| v1.0 Release | Feb 7, 2026 | 🎯 Target |

---

## ⭐ Star History

If you find WebKitForge useful, please star the repository! It helps others discover the project.

---

**Made with ❤️ for the macOS community**

*Fighting bloated PWAs, one app at a time* 🚀
