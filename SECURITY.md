# Security Policy

## Supported Versions

We actively support the following versions with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 0.x.x   | :white_check_mark: |
| < 0.1   | :x:                |

**Note**: As this project is in early development (pre-1.0), security support is limited to the latest development branch. Once we reach v1.0, we will maintain security updates for the latest stable release.

---

## What This Project Does

WebKitForge is an open-source WebKit-based site-specific browser (SSB) framework for macOS. It allows users to create lightweight, native-feeling web applications.

### **Security Scope**

**WebKitForge DOES:**
- Build standalone macOS application bundles (`.app`)
- Use Apple's WebKit framework for rendering web content
- Provide JavaScript bridging between web content and native code
- Store app configurations and preferences locally
- Access system resources as granted by macOS permissions

**WebKitForge DOES NOT:**
- Modify system files or frameworks
- Require root/administrator privileges (except for optional code signing)
- Collect telemetry or analytics
- Send data off your machine without explicit user action
- Install background services or launch agents without consent
- Bypass macOS security features (Gatekeeper, SIP, sandboxing)

---

## Security Considerations

### **1. Web Content Security**

WebKitForge uses Apple's **WebKit framework**, which provides:
- ✅ Same rendering engine as Safari
- ✅ Process-level sandboxing
- ✅ Modern web security standards (CORS, CSP, etc.)
- ✅ Regular security updates from Apple via macOS

**User Responsibility**:
- Created apps load web content from URLs you specify
- Apps inherit the same security model as Safari
- Be cautious with JavaScript injection and custom scripts
- Only create apps for trusted websites

### **2. Code Signing & Notarization**

**Current Status (v0.x - Development)**:
- ❌ Apps are **unsigned** (requires manual Gatekeeper bypass)
- ❌ Framework is **unsigned**
- ⚠️ Users must run: `xattr -cr YourApp.app` or right-click → Open

**Future Status (v1.0+)**:
- ✅ Framework will be code-signed
- ✅ Apps will be notarized
- ✅ No Gatekeeper warnings for end users

**Security Impact**:
- Unsigned apps can be modified by attackers if you download from untrusted sources
- **Always build from source** or download official releases from GitHub
- Verify SHA256 checksums of downloads

### **3. JavaScript Bridge Security**

WebKitForge provides a JavaScript bridge for communication between web content and native code.

**Potential Risks**:
- Malicious websites could exploit bridge APIs if improperly exposed
- Custom scripts could access native functionality

**Mitigations**:
- ✅ Bridge APIs are **explicitly allowed** (no automatic exposure)
- ✅ Apps run in macOS sandbox (limited file system access)
- ✅ User must grant permissions for camera, microphone, location, etc.
- ⏳ v1.0 will add configurable API restrictions per app

**Best Practices**:
- Only inject JavaScript you trust and understand
- Review example apps before using their scripts
- Avoid exposing sensitive APIs to untrusted web content

### **4. File System Access**

**What WebKitForge Can Access**:
- ✅ Read/Write: `~/Library/Application Support/org.webkitforge.*`
- ✅ Read/Write: `~/Library/Caches/org.webkitforge.*`
- ✅ Read/Write: User-selected files (via file picker dialogs)
- ✅ Read: Public web URLs

**What WebKitForge CANNOT Access** (without user consent):
- ❌ System directories (`/System`, `/Library`, etc.)
- ❌ Other users' home directories
- ❌ Files outside app sandbox (unless user picks them)

**Sandboxing**:
- Apps created by WebKitForge inherit macOS sandbox restrictions
- File access limited by macOS permissions system
- No access to sensitive data without explicit user approval

### **5. Network Security**

**Default Behavior**:
- Apps can access any public URL (same as Safari)
- HTTPS enforced by WebKit (no downgrade to HTTP without user override)
- Certificate validation enabled by default

**Custom Configuration**:
- Apps can specify allowed/blocked domains (optional)
- Users can enable/disable JavaScript per app
- Network traffic is NOT logged or monitored by WebKitForge

### **6. Privacy**

**Data Collection**:
- ❌ NO telemetry
- ❌ NO analytics
- ❌ NO crash reporting (unless user opts in via macOS)
- ❌ NO data sent to external servers

**Local Storage**:
- Apps store cookies, localStorage, IndexedDB locally
- Stored in `~/Library/WebKit/org.webkitforge.<AppName>/`
- Same privacy model as Safari

**Permissions**:
- WebKitForge requests macOS permissions as needed:
  - Camera/Microphone (for video calls)
  - Location (for mapping apps)
  - Notifications (for alerts)
- User can revoke permissions anytime in System Settings

---

## Known Security Limitations

### **Pre-1.0 Development Releases**

| Limitation | Impact | Mitigation |
|------------|--------|------------|
| **Unsigned builds** | macOS Gatekeeper warnings | Build from source or use `xattr -cr` |
| **No automatic updates** | Security fixes require manual download | Watch GitHub releases for updates |
| **Limited security audit** | Potential undiscovered vulnerabilities | Open-source allows community review |
| **Experimental JS bridge** | API surface not fully hardened | Only use with trusted websites |

### **Inherent Risks (Any SSB Framework)**

| Risk | Description | User Action |
|------|-------------|-------------|
| **Web content vulnerabilities** | Apps load untrusted web content | Only create apps for sites you trust |
| **XSS attacks** | Websites may have security flaws | Keep macOS updated for WebKit patches |
| **Malicious scripts** | Custom JS injection can be exploited | Only inject code you wrote/reviewed |

---

## Reporting a Vulnerability

We take security seriously. If you discover a vulnerability:

### **For Critical Vulnerabilities** (RCE, data leaks, privilege escalation):
1. **DO NOT** open a public GitHub issue
2. Email: **chindris.mihai.alexandru@gmail.com**
3. Subject: "SECURITY: [Brief Description]"
4. Include:
   - Vulnerability description
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### **For Non-Critical Issues** (UI bugs, minor leaks):
1. Open a GitHub issue with `[SECURITY]` prefix
2. Provide reproduction steps
3. Tag with `security` label

### **Response Timeline**:
- **Critical**: Response within 48 hours, patch within 1 week
- **High**: Response within 1 week, patch within 2 weeks
- **Medium/Low**: Response within 2 weeks, patch in next release

### **Disclosure Policy**:
- We follow **coordinated disclosure**
- Security fixes released before public disclosure
- Credit given to reporters (if desired)
- CVE assigned for critical vulnerabilities (v1.0+)

---

## Security Best Practices for Users

### **When Creating Apps**:
1. ✅ Only create apps for websites you trust
2. ✅ Review JavaScript injection code before using
3. ✅ Use HTTPS URLs whenever possible
4. ✅ Limit app permissions to minimum required
5. ✅ Regularly update WebKitForge to latest version

### **When Running Apps**:
1. ✅ Keep macOS updated (for WebKit security patches)
2. ✅ Review app permissions in System Settings
3. ✅ Delete apps you no longer use
4. ✅ Be cautious with apps requesting camera/microphone access
5. ✅ Log out of sensitive apps when not in use

### **When Distributing Apps**:
1. ✅ Code-sign apps if distributing to others
2. ✅ Clearly document what the app does
3. ✅ Warn users if app requires special permissions
4. ✅ Provide source URL so users can verify legitimacy
5. ✅ Include privacy policy if collecting user data

---

## Security Audit Status

**Current Status (v0.x - Pre-Release)**:
- ⏳ **No formal security audit completed**
- ✅ Code is open-source (community-auditable)
- ✅ Uses Apple's audited WebKit framework
- ✅ Follows macOS sandboxing guidelines

**Planned (v1.0+)**:
- ⏳ Third-party security audit (if funding available)
- ⏳ Penetration testing of JavaScript bridge
- ⏳ Static analysis with multiple tools
- ⏳ Fuzzing of input handling

**Community Contributions**:
- 🙏 Security researchers welcome to audit code
- 🙏 Bug bounty program considered for v1.0+
- 🙏 Hall of Fame for responsible disclosures

---

## Dependencies & Supply Chain Security

WebKitForge depends on:

| Dependency | Source | Security Model |
|------------|--------|----------------|
| **WebKit** | Apple (system framework) | Audited by Apple, updated via macOS |
| **Swift** | Apple (open-source) | Audited by Apple + community |
| **swift-argument-parser** | Apple (GitHub) | Official Apple library |
| **JavaScriptCore** | Apple (system framework) | Audited by Apple |

**Supply Chain Mitigations**:
- ✅ Dependencies pinned to specific versions (Package.resolved)
- ✅ Official Apple frameworks only (no third-party WebKit builds)
- ✅ GitHub Actions uses official Apple runners
- ⏳ v1.0 will add dependency checksum verification

---

## Compliance & Certifications

**Current Status**:
- ❌ Not GDPR-compliant (no data collection, so not applicable)
- ❌ Not SOC2/ISO27001 certified
- ✅ Follows Apple Developer Guidelines
- ✅ GPL-3.0 license compliant

**For Enterprise Users**:
- Apps created with WebKitForge inherit your website's security model
- Review your organization's security policies before deploying
- Consider code-signing all apps with your enterprise certificate
- Conduct your own security audit if required

---

## Security Roadmap

### **v0.1-0.5 (Current - Development)**:
- ✅ Basic sandboxing
- ✅ WebKit security baseline
- ⏳ Security documentation (this file)

### **v1.0 (Stable Release)**:
- ⏳ Code signing + notarization
- ⏳ Automated security testing in CI
- ⏳ Third-party security audit
- ⏳ Configurable API restrictions
- ⏳ Security-focused settings UI

### **v2.0 (Future)**:
- ⏳ Content Security Policy enforcement
- ⏳ Network request filtering
- ⏳ Enhanced JavaScript bridge isolation
- ⏳ Automated vulnerability scanning

---

## Acknowledgments

Security best practices informed by:
- [Apple Secure Coding Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/SecureCodingGuide/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [WebKit Security](https://webkit.org/security/)
- [macOS Security Compliance Project](https://github.com/usnistgov/macos_security)

Special thanks to security researchers who have contributed (none yet, you could be first!).

---

## Contact

**Security Team**: chindris.mihai.alexandru@gmail.com  
**General Issues**: [GitHub Issues](https://github.com/chindris-mihai-alexandru/MacPin/issues)  
**GPG Key**: (to be added in v1.0)

---

**Last Updated**: November 15, 2025  
**Next Review**: January 1, 2026 (after v0.1 release)
