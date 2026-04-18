import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusBar = StatusBarController()
    private let detector = MeetingDetector()
    private let bell = BellPlayer()
    private let overlay = PromptOverlay()

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

        detector.onMeetingEnded = { [weak self] in
            guard let self, statusBar.isEnabled else { return }
            playBellAndShowPrompt()
        }

        detector.start()
    }

    private func playBellAndShowPrompt() {
        bell.play()
        let prompt = MindfulnessPrompts.random()
        overlay.show(prompt: prompt)
    }

    func applicationWillTerminate(_ notification: Notification) {
        detector.stop()
    }
}
