import Foundation

@MainActor
final class MeetingDetector {
    enum State: Sendable {
        case idle
        case inMeeting
    }

    private(set) var state: State = .idle
    private var timer: Timer?
    private let pollInterval: TimeInterval = 1.0
    private let processNames = ["CptHost", "zCCIMeetingHost"]

    var onMeetingEnded: (() -> Void)?

    func start() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.poll()
            }
        }
        poll()
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func poll() {
        let isRunning = processNames.contains { isProcessRunning(name: $0) }

        switch (state, isRunning) {
        case (.idle, true):
            state = .inMeeting
        case (.inMeeting, false):
            state = .idle
            onMeetingEnded?()
        default:
            break
        }
    }

    private func isProcessRunning(name: String) -> Bool {
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0]
        var size: Int = 0

        guard sysctl(&mib, UInt32(mib.count), nil, &size, nil, 0) == 0 else {
            return false
        }

        let count = size / MemoryLayout<kinfo_proc>.stride
        var procs = [kinfo_proc](repeating: kinfo_proc(), count: count)

        guard sysctl(&mib, UInt32(mib.count), &procs, &size, nil, 0) == 0 else {
            return false
        }

        let actualCount = size / MemoryLayout<kinfo_proc>.stride

        for i in 0..<actualCount {
            let comm = procs[i].kp_proc.p_comm
            let procName = withUnsafePointer(to: comm) { ptr in
                ptr.withMemoryRebound(to: CChar.self, capacity: Int(MAXCOMLEN)) { cstr in
                    String(cString: cstr)
                }
            }
            if procName == name {
                return true
            }
        }

        return false
    }
}
