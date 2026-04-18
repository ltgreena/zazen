import AppKit

@MainActor
final class StatusBarController: NSObject {
    private var statusItem: NSStatusItem?
    private var enabledMenuItem: NSMenuItem?
    private var launchAtLoginMenuItem: NSMenuItem?
    private var volumeSlider: NSSlider?

    private(set) var isEnabled = true

    var isLaunchAtLogin = false {
        didSet { launchAtLoginMenuItem?.state = isLaunchAtLogin ? .on : .off }
    }

    var onToggleEnabled: ((Bool) -> Void)?
    var onPlayBell: (() -> Void)?
    var onVolumeChanged: ((Float) -> Void)?
    var onToggleLaunchAtLogin: (() -> Void)?

    func setup() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            let config = NSImage.SymbolConfiguration(pointSize: 14, weight: .medium)
            button.image = NSImage(systemSymbolName: "bell.fill", accessibilityDescription: "Zazen")?
                .withSymbolConfiguration(config)
        }

        statusItem?.menu = buildMenu()
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()

        let title = NSMenuItem(title: "Zazen", action: nil, keyEquivalent: "")
        title.isEnabled = false
        if let font = NSFont.systemFont(ofSize: 13, weight: .semibold) as NSFont? {
            title.attributedTitle = NSAttributedString(string: "Zazen", attributes: [.font: font])
        }
        menu.addItem(title)
        menu.addItem(.separator())

        enabledMenuItem = NSMenuItem(title: "Enabled", action: #selector(toggleEnabled), keyEquivalent: "")
        enabledMenuItem?.target = self
        enabledMenuItem?.state = .on
        menu.addItem(enabledMenuItem!)

        launchAtLoginMenuItem = NSMenuItem(title: "Launch at Login", action: #selector(toggleLaunchAtLogin), keyEquivalent: "")
        launchAtLoginMenuItem?.target = self
        launchAtLoginMenuItem?.state = isLaunchAtLogin ? .on : .off
        menu.addItem(launchAtLoginMenuItem!)

        menu.addItem(.separator())

        let volumeLabel = NSMenuItem(title: "Volume", action: nil, keyEquivalent: "")
        volumeLabel.isEnabled = false
        menu.addItem(volumeLabel)

        let sliderItem = NSMenuItem()
        let sliderView = NSView(frame: NSRect(x: 0, y: 0, width: 200, height: 28))
        let slider = NSSlider(frame: NSRect(x: 20, y: 4, width: 160, height: 20))
        slider.minValue = 0
        slider.maxValue = 1
        slider.floatValue = 0.7
        slider.target = self
        slider.action = #selector(volumeChanged(_:))
        slider.isContinuous = true
        sliderView.addSubview(slider)
        sliderItem.view = sliderView
        volumeSlider = slider
        menu.addItem(sliderItem)
        menu.addItem(.separator())

        let playItem = NSMenuItem(title: "Play Bell Now", action: #selector(playBellTapped), keyEquivalent: "p")
        playItem.target = self
        menu.addItem(playItem)
        menu.addItem(.separator())

        let shortcutItem = NSMenuItem(title: "Shortcut: ⌃⌥⌘M", action: nil, keyEquivalent: "")
        shortcutItem.isEnabled = false
        menu.addItem(shortcutItem)

        menu.addItem(.separator())

        let quitItem = NSMenuItem(title: "Quit Zazen", action: #selector(quitTapped), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        return menu
    }

    @objc private func toggleEnabled() {
        isEnabled.toggle()
        enabledMenuItem?.state = isEnabled ? .on : .off
        onToggleEnabled?(isEnabled)
    }

    @objc private func toggleLaunchAtLogin() {
        onToggleLaunchAtLogin?()
        isLaunchAtLogin.toggle()
    }

    @objc private func volumeChanged(_ sender: NSSlider) {
        onVolumeChanged?(sender.floatValue)
    }

    @objc private func playBellTapped() {
        onPlayBell?()
    }

    @objc private func quitTapped() {
        NSApp.terminate(nil)
    }
}
