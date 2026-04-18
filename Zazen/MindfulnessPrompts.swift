import Foundation

enum Tradition: String, CaseIterable, Sendable {
    case zen
    case theravada
    case tibetan
    case secular
    case pureLand
    case chan
    case prompt
}

struct MindfulnessPrompt: Sendable {
    let text: String
    let tradition: Tradition
    let attribution: String?
}

enum MindfulnessPrompts {
    static let all: [MindfulnessPrompt] = [

        // — Zen —

        MindfulnessPrompt(
            text: "Sitting quietly, doing nothing, spring comes, and the grass grows by itself.",
            tradition: .zen,
            attribution: "— Matsuo Bashō"
        ),
        MindfulnessPrompt(
            text: "When you do something, you should burn yourself up completely, like a good bonfire, leaving no trace of yourself.",
            tradition: .zen,
            attribution: "— Shunryu Suzuki"
        ),
        MindfulnessPrompt(
            text: "In the beginner's mind there are many possibilities. In the expert's mind there are few.",
            tradition: .zen,
            attribution: "— Shunryu Suzuki"
        ),
        MindfulnessPrompt(
            text: "The only thing that is ultimately real about your journey is the step that you are taking at this moment.",
            tradition: .zen,
            attribution: "— Alan Watts"
        ),
        MindfulnessPrompt(
            text: "Before enlightenment, chop wood, carry water. After enlightenment, chop wood, carry water.",
            tradition: .zen,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "When walking, walk. When eating, eat.",
            tradition: .zen,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "No snowflake ever falls in the wrong place.",
            tradition: .zen,
            attribution: nil
        ),

        // — Theravada / Vipassana —

        MindfulnessPrompt(
            text: "Nothing is to be clung to as I, me, or mine.",
            tradition: .theravada,
            attribution: "— The Buddha"
        ),
        MindfulnessPrompt(
            text: "Peace comes from within. Do not seek it without.",
            tradition: .theravada,
            attribution: "— The Buddha"
        ),
        MindfulnessPrompt(
            text: "Feelings come and go like clouds in a windy sky. Conscious breathing is my anchor.",
            tradition: .theravada,
            attribution: "— Thich Nhat Hanh"
        ),
        MindfulnessPrompt(
            text: "Smile, breathe, and go slowly.",
            tradition: .theravada,
            attribution: "— Thich Nhat Hanh"
        ),
        MindfulnessPrompt(
            text: "The present moment is filled with joy and happiness. If you are attentive, you will see it.",
            tradition: .theravada,
            attribution: "— Thich Nhat Hanh"
        ),
        MindfulnessPrompt(
            text: "You are not your thoughts. You are the awareness behind them.",
            tradition: .theravada,
            attribution: nil
        ),

        // — Tibetan —

        MindfulnessPrompt(
            text: "If you want others to be happy, practice compassion. If you want to be happy, practice compassion.",
            tradition: .tibetan,
            attribution: "— Dalai Lama"
        ),
        MindfulnessPrompt(
            text: "Happiness is not something ready-made. It comes from your own actions.",
            tradition: .tibetan,
            attribution: "— Dalai Lama"
        ),
        MindfulnessPrompt(
            text: "The mind is everything. What you think, you become.",
            tradition: .tibetan,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Let this moment dissolve like mist.",
            tradition: .tibetan,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "In this gap, everything is possible.",
            tradition: .tibetan,
            attribution: nil
        ),

        // — Chan —

        MindfulnessPrompt(
            text: "To understand everything is to forgive everything.",
            tradition: .chan,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "The obstacle is the path.",
            tradition: .chan,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Still water. Clear mind.",
            tradition: .chan,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "The meeting is over. Who remains?",
            tradition: .chan,
            attribution: nil
        ),

        // — Pure Land —

        MindfulnessPrompt(
            text: "Each encounter is a once-in-a-lifetime meeting.",
            tradition: .pureLand,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Return to this moment with gratitude.",
            tradition: .pureLand,
            attribution: nil
        ),

        // — Secular / General Buddhist —

        MindfulnessPrompt(
            text: "What you are is what you have been. What you'll be is what you do now.",
            tradition: .secular,
            attribution: "— The Buddha"
        ),
        MindfulnessPrompt(
            text: "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.",
            tradition: .secular,
            attribution: "— The Buddha"
        ),
        MindfulnessPrompt(
            text: "Every morning we are born again. What we do today is what matters most.",
            tradition: .secular,
            attribution: nil
        ),

        // — Body / Breath Prompts —

        MindfulnessPrompt(
            text: "Take a deep breath.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Feel your body.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Smile.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Relax your jaw.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Drop your shoulders.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Feel your feet on the ground.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Soften your eyes.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Unclench your hands.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Three slow breaths.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Notice the sounds around you.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "You are here. That is enough.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Stand up. Stretch.",
            tradition: .prompt,
            attribution: nil
        ),
        MindfulnessPrompt(
            text: "Drink some water.",
            tradition: .prompt,
            attribution: nil
        ),
    ]

    static func random() -> MindfulnessPrompt {
        all.randomElement()!
    }
}
