// VietnameseModeHUD.swift
// HUD nổi nhỏ gọn hiển thị tạm thời khi chuyển đổi chế độ Tiếng Việt ↔ Tiếng Anh (VNI luôn bật).

import AppKit

enum VietnameseModeHUD {
    private static var panel: NSPanel?
    private static var dismissTimer: Timer?

    static func show(vietnamese: Bool) {
        DispatchQueue.main.async {
            dismissTimer?.invalidate()
            let p = panel ?? makePanel()
            panel = p
            if let label = p.contentView as? NSTextField {
                label.stringValue = vietnamese ? "Tiếng Việt (Telex + VNI)" : "Tiếng Anh (VNI luôn bật)"
            }
            if let screen = NSScreen.main {
                let frame = screen.visibleFrame
                let pSize = p.frame.size
                let x = frame.midX - pSize.width / 2
                let y = frame.midY - pSize.height / 2 + 120
                p.setFrameOrigin(NSPoint(x: x, y: y))
            }
            p.alphaValue = 0.95
            p.orderFrontRegardless()
            dismissTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false) { _ in
                NSAnimationContext.runAnimationGroup({ ctx in
                    ctx.duration = 0.25
                    p.animator().alphaValue = 0
                }, completionHandler: {
                    p.orderOut(nil)
                })
            }
        }
    }

    private static func makePanel() -> NSPanel {
        let p = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 230, height: 42),
                        styleMask: [.borderless, .nonactivatingPanel],
                        backing: .buffered, defer: false)
        p.isOpaque = false
        p.backgroundColor = NSColor.black.withAlphaComponent(0.8)
        p.hasShadow = true
        p.level = .floating
        p.ignoresMouseEvents = true
        let label = NSTextField(labelWithString: "")
        label.alignment = .center
        label.font = NSFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.frame = p.contentView!.bounds
        label.autoresizingMask = [.width, .height]
        p.contentView = label
        return p
    }
}
