import AVFoundation

@MainActor
final class BellPlayer {
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var buffers: [AVAudioPCMBuffer] = []
    private var connectedFormat: AVAudioFormat?

    private(set) var volume: Float = 0.7

    func prepare() {
        engine.attach(playerNode)

        let soundsURL = Bundle.main.resourceURL!.appendingPathComponent("Sounds")
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: soundsURL,
            includingPropertiesForKeys: nil
        ) else {
            NSLog("Zazen: no sound files found in bundle")
            return
        }

        let wavFiles = files.filter { $0.pathExtension.lowercased() == "wav" }.sorted { $0.lastPathComponent < $1.lastPathComponent }

        for url in wavFiles {
            do {
                let file = try AVAudioFile(forReading: url)
                guard let buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length)) else { continue }
                try file.read(into: buffer)
                buffers.append(buffer)
            } catch {
                NSLog("Zazen: failed to load \(url.lastPathComponent): \(error)")
            }
        }

        guard let firstBuffer = buffers.first else {
            NSLog("Zazen: no buffers loaded")
            return
        }

        connectedFormat = firstBuffer.format
        engine.connect(playerNode, to: engine.mainMixerNode, format: firstBuffer.format)

        do {
            try engine.start()
        } catch {
            NSLog("Zazen: failed to start audio engine: \(error)")
        }
    }

    func play() {
        guard let buffer = buffers.randomElement() else { return }

        if let connectedFormat, buffer.format != connectedFormat {
            engine.disconnectNodeOutput(playerNode)
            engine.connect(playerNode, to: engine.mainMixerNode, format: buffer.format)
            self.connectedFormat = buffer.format
        }

        if !engine.isRunning {
            do {
                try engine.start()
            } catch {
                NSLog("Zazen: failed to start audio engine: \(error)")
                return
            }
        }

        playerNode.stop()
        playerNode.volume = volume
        playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        playerNode.play()
    }

    func setVolume(_ v: Float) {
        volume = min(max(v, 0), 1)
        playerNode.volume = volume
    }
}
