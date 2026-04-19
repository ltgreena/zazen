import AppKit
import Carbon.HIToolbox
import ServiceManagement

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusBar = StatusBarController()
    private let detector = MeetingDetector()
    private let bell = BellPlayer()
    private let overlay = PromptOverlay()

    private var hotKeyRef: EventHotKeyRef?

    func applicationDidFinishLaunching(_ notification: Notification) {
        bell.prepare()
        overlay.prepare()

        statusBar.setup()
        statusBar.onToggleEnabled = { [weak self] enabled in
            guard let self else { return }
            if enabled {
                detector.start()
            } else {
                detector.stop()
            }
        }
        statusBar.onPlayBell = { [weak self] in
            self?.playBellAndShowPrompt()
        }
        statusBar.onVolumeChanged = { [weak self] volume in
            self?.bell.setVolume(volume)
        }
        statusBar.onToggleLaunchAtLogin = {
            let service = SMAppService.mainApp
            do {
                if service.status == .enabled {
                    try service.unregister()
                } else {
                    try service.register()
                }
            } catch {
                NSLog("Zazen: launch at login toggle failed: \(error)")
            }
        }
        statusBar.isLaunchAtLogin = SMAppService.mainApp.status == .enabled

        detector.onMeetingEnded = { [weak self] in
            guard let self, statusBar.isEnabled else { return }
            playBellAndShowPrompt()
        }

        detector.start()
        registerGlobalHotKey()
    }

    private func playBellAndShowPrompt() {
        bell.play()
        let prompt = MindfulnessPrompts.random()
        overlay.show(prompt: prompt)
    }

    func applicationWillTerminate(_ notification: Notification) {
        detector.stop()
    }

    // MARK: - Global Hotkey (Ctrl+Option+Cmd+M)

    private func registerGlobalHotKey() {
        let hotKeyID = EventHotKeyID(signature: OSType(0x5A415A4E), id: 1)
        let modifiers: UInt32 = UInt32(controlKey | optionKey | cmdKey)
        let keyCode: UInt32 = UInt32(kVK_ANSI_M)

        var ref: EventHotKeyRef?
        let status = RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &ref)
        if status == noErr {
            hotKeyRef = ref
        }

        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetApplicationEventTarget(), { _, _, _ -> OSStatus in
            MainActor.assumeIsolated {
                if let delegate = NSApp.delegate as? AppDelegate {
                    delegate.playBellAndShowPrompt()
                }
            }
            return noErr
        }, 1, &eventType, nil, nil)
    }
}
