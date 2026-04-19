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

If you don't trust a pre-built binary (reasonable!), build from source. The code is short and straightforward.

## How this was made

This app was built with substantial help from [Claude](https://claude.ai) (Anthropic's AI assistant). The initial version and subsequent features were developed in conversation with Claude Code, as reflected in the commit history.

I'm being upfront about this because I think transparency matters more than pretense. AI-assisted development is how a lot of software gets written now, and I'd rather be honest about it than hide the `Co-Authored-By` tags.

That said, "AI-assisted" doesn't mean "unreviewed." The codebase is ~800 lines of Swift with zero external dependencies — small enough that every line has been read and understood. The security properties listed above aren't marketing claims; they're verifiable by reading the source.

## License

[MIT](LICENSE)
