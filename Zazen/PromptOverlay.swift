import AppKit

@MainActor
final class PromptOverlay {
    private var panel: NSPanel?
    private var dismissTimer: Timer?
    private var imageNames: [String] = []

    func prepare() {
        let imagesURL = Bundle.main.resourceURL!.appendingPathComponent("Images")
        if let files = try? FileManager.default.contentsOfDirectory(
            at: imagesURL,
            includingPropertiesForKeys: nil
        ) {
            imageNames = files
                .filter { ["jpg", "jpeg", "png"].contains($0.pathExtension.lowercased()) }
                .map { $0.lastPathComponent }
                .sorted()
        }
    }

    func show(prompt: MindfulnessPrompt) {
        dismiss(animated: false)

        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.frame

        let panelWidth = screenFrame.width
        let panelHeight = screenFrame.height

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: panelWidth, height: panelHeight),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isOpaque = true
        panel.backgroundColor = .black
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.hasShadow = true
        panel.isMovableByWindowBackground = false
        panel.ignoresMouseEvents = false

        let contentView = OverlayContentView(
            prompt: prompt,
            imageName: imageNames.randomElement(),
            frame: NSRect(x: 0, y: 0, width: panelWidth, height: panelHeight),
            onDismiss: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
        panel.contentView = contentView

        let x = screenFrame.midX - panelWidth / 2
        let y = screenFrame.midY - panelHeight / 2
        panel.setFrameOrigin(NSPoint(x: x, y: y))

        panel.alphaValue = 0
        panel.orderFrontRegardless()

        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.8
            ctx.timingFunction = CAMediaTimingFunction(name: .easeOut)
            panel.animator().alphaValue = 1.0
        }

        self.panel = panel

        dismissTimer = Timer.scheduledTimer(withTimeInterval: 18.0, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated {
                self?.dismiss(animated: true)
            }
        }
    }

    func dismiss(animated: Bool) {
        dismissTimer?.invalidate()
        dismissTimer = nil

        guard let panel = panel else { return }
        self.panel = nil

        if animated {
            NSAnimationContext.runAnimationGroup({ ctx in
                ctx.duration = 2.0
                ctx.timingFunction = CAMediaTimingFunction(name: .easeIn)
                panel.animator().alphaValue = 0
            }, completionHandler: {
                panel.orderOut(nil)
            })
        } else {
            panel.orderOut(nil)
        }
    }
}

private final class OverlayContentView: NSView {
    private let imageView: NSImageView
    private let darkenLayer: NSView
    private let promptLabel: NSTextField
    private let attributionLabel: NSTextField?
    private let traditionLabel: NSTextField
    private let onDismiss: () -> Void

    init(prompt: MindfulnessPrompt, imageName: String?, frame: NSRect, onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss

        imageView = NSImageView(frame: frame)
        imageView.imageScaling = .scaleAxesIndependently
        imageView.autoresizingMask = [.width, .height]

        if let imageName,
           let imagesURL = Bundle.main.resourceURL?.appendingPathComponent("Images").appendingPathComponent(imageName),
           let image = NSImage(contentsOf: imagesURL) {
            imageView.image = image
        }

        darkenLayer = NSView(frame: frame)
        darkenLayer.wantsLayer = true
        darkenLayer.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.35).cgColor
        darkenLayer.autoresizingMask = [.width, .height]

        promptLabel = NSTextField(wrappingLabelWithString: prompt.text)
        promptLabel.font = NSFont.systemFont(ofSize: 36, weight: .ultraLight)
        promptLabel.textColor = NSColor.white
        promptLabel.alignment = .center
        promptLabel.isSelectable = false
        promptLabel.maximumNumberOfLines = 0
        promptLabel.translatesAutoresizingMaskIntoConstraints = false

        if let attribution = prompt.attribution {
            let label = NSTextField(labelWithString: attribution)
            label.font = NSFont.systemFont(ofSize: 18, weight: .ultraLight).withTraits(.italic)
            label.textColor = NSColor.white.withAlphaComponent(0.7)
            label.alignment = .center
            label.isSelectable = false
            label.translatesAutoresizingMaskIntoConstraints = false
            attributionLabel = label
        } else {
            attributionLabel = nil
        }

        let traditionName: String
        switch prompt.tradition {
        case .zen: traditionName = "Zen"
        case .theravada: traditionName = "Theravada"
        case .tibetan: traditionName = "Tibetan"
        case .secular: traditionName = "Mindfulness"
        case .pureLand: traditionName = "Pure Land"
        case .chan: traditionName = "Chan"
        case .prompt: traditionName = ""
        }
        traditionLabel = NSTextField(labelWithString: traditionName)
        traditionLabel.isHidden = prompt.tradition == .prompt
        traditionLabel.font = NSFont.systemFont(ofSize: 12, weight: .medium)
        traditionLabel.textColor = NSColor.white.withAlphaComponent(0.4)
        traditionLabel.alignment = .center
        traditionLabel.isSelectable = false
        traditionLabel.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)
        wantsLayer = true
        layer?.cornerRadius = 0
        layer?.masksToBounds = true

        addSubview(imageView)
        addSubview(darkenLayer)
        addSubview(promptLabel)
        if let attributionLabel { addSubview(attributionLabel) }
        addSubview(traditionLabel)
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func mouseDown(with event: NSEvent) {
        onDismiss()
    }

    private func setupConstraints() {
        var constraints = [
            promptLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            promptLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            promptLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),

            traditionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            traditionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ]

        if let attributionLabel {
            constraints += [
                attributionLabel.topAnchor.constraint(equalTo: promptLabel.bottomAnchor, constant: 20),
                attributionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ]
        }

        NSLayoutConstraint.activate(constraints)
    }
}

private extension NSFont {
    func withTraits(_ traits: NSFontDescriptor.SymbolicTraits) -> NSFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return NSFont(descriptor: descriptor, size: pointSize) ?? self
    }
}
