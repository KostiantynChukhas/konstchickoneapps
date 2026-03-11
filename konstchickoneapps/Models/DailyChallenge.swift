import Foundation

struct DailyChallenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let emoji: String
    let reward: Int
    let type: ChallengeType
    var isCompleted: Bool = false

    enum ChallengeType {
        case game, quiz, collection, streak
    }

    static func todaysChallenges() -> [DailyChallenge] {
        let all: [DailyChallenge] = [
            DailyChallenge(
                title: "Egg Collector",
                description: "Collect 20 eggs in Egg Run",
                emoji: "🥚", reward: 50, type: .game
            ),
            DailyChallenge(
                title: "Quiz Master",
                description: "Answer 5 quiz questions correctly",
                emoji: "🧠", reward: 30, type: .quiz
            ),
            DailyChallenge(
                title: "New Friend",
                description: "Open a Mystery Chest",
                emoji: "📦", reward: 25, type: .collection
            ),
            DailyChallenge(
                title: "Daily Check-in",
                description: "Open the app today",
                emoji: "🔥", reward: 10, type: .streak
            ),
            DailyChallenge(
                title: "High Scorer",
                description: "Score over 500 points in Egg Run",
                emoji: "🏆", reward: 40, type: .game
            ),
            DailyChallenge(
                title: "Cluck-tastic",
                description: "Complete a full quiz round",
                emoji: "🎓", reward: 35, type: .quiz
            ),
        ]
        return Array(all.shuffled().prefix(3))
    }
}
