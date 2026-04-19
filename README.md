# Zazen

A macOS menu bar app that plays a singing bowl and shows a mindfulness prompt when your Zoom meeting ends.

Zazen (座禅) means "seated meditation" in Japanese — the core practice of Zen Buddhism. The app borrows the tradition of using a bell to mark transitions between sitting periods, repurposing it for the transition between a video call and whatever comes next.

## What it does

When a Zoom meeting ends, Zazen:

1. Plays a random singing bowl tone (16 variations across 4 bowls)
2. Shows a full-screen overlay with a mindfulness prompt and zen imagery
3. Fades out after 18 seconds (or click to dismiss)

Prompts are drawn from Zen, Theravada, Tibetan, Chan, and Pure Land traditions, plus simple body-awareness cues like "Relax your jaw" or "Three slow breaths."

You can also trigger the bell manually with **⌃⌥⌘M** or from the menu bar dropdown.

## Installation

### Build from source

Requires Xcode 15+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```bash
brew install xcodegen
git clone https://github.com/ltgreena/zazen.git
cd zazen
make build
```

The built app will be at `build/Release/Zazen.app`. Drag it to your Applications folder.

### Download

Check [Releases](https://github.com/ltgreena/zazen/releases) for a pre-built .app.

> **Note:** The app is not signed or notarized with an Apple Developer certificate. macOS will block it on first launch. To open it: right-click the app, choose "Open", and confirm in the dialog. You only need to do this once.

## Menu bar controls

| Option | Description |
|--------|-------------|
| **Enabled** | Toggle meeting detection on/off |
| **Launch at Login** | Start Zazen when you log in |
| **Volume** | Adjust bell volume |
| **Play Bell Now** | Trigger immediately |
| **⌃⌥⌘M** | Global keyboard shortcut |

## How it works

Zazen polls the macOS process list once per second, looking for Zoom's meeting-specific processes (`CptHost`, `zCCIMeetingHost`). When those processes disappear, it plays the bell.

There is no network access, no analytics, no telemetry, and no data collection of any kind. The app uses only native macOS frameworks:

- **AppKit** — menu bar UI and overlay window
- **AVFoundation** — audio playback
- **Carbon.HIToolbox** — global hotkey registration
- **ServiceManagement** — launch at login

No third-party dependencies.

## Requirements

- macOS 14.0 (Sonoma) or later
- Zoom desktop client (for meeting detection)

## Security and privacy

Zazen has a minimal footprint:

- **No network access.** The app makes zero HTTP requests. It doesn't phone home, check for updates, or communicate with any server.
- **No file system writes.** It reads only from its own app bundle (sounds and images). It writes nothing to disk.
- **No user data.** No data collection, no analytics, no telemetry, no crash reporting.
- **No entitlements.** The app requires no special permissions — no accessibility access, no screen recording, no microphone.
- **Process detection is read-only.** Meeting detection uses `sysctl` to list running processes by name. This is a standard macOS API that doesn't require elevated privileges.
- **~800 lines of Swift.** The entire codebase is small enough to read in one sitting.

The codebase is ~800 lines of Swift with zero external dependencies — small enough to read in one sitting. If you don't trust a pre-built binary (reasonable!), build from source and see for yourself.

## How this was made

*(This part was written by a human.)*

I vibe-coded this using [Claude Code](https://claude.ai/code) (Opus 4.6, 1M context window). I had the general idea, and Claude helped me to refine the specific product definition. We spent a bit of time in plan mode, then Claude was able to implement in essentially one shot. I spent most of the time trying to get the vibes right — improving the bell sounds, getting better imagery, better quotes, expanding to full screen, tweaking how long the bell and overlay last.

I haven't reviewed any of the code personally — but the app is small and self-contained and I'm pretty confident the security blast radius here is minimal. Feedback welcome — although you're also encouraged to just grab the code and customize it yourself.

I hope you enjoy and that it helps improve your work day.

## License

[MIT](LICENSE)
