import Foundation
import Combine

class AppDataManager: ObservableObject {
    @Published var hasCompletedOnboarding: Bool
    @Published var playerName: String
    @Published var coins: Int
    @Published var streakDays: Int
    @Published var lastOpenedDate: Date?
    @Published var unlockedChickens: [UUID]
    @Published var highScoreEggRun: Int
    @Published var highScoreEggCatcher: Int
    @Published var totalQuizCorrect: Int
    @Published var chestsAvailable: Int
    @Published var dailyChallenges: [DailyChallenge]

    private let defaults = UserDefaults.standard

    init() {
        hasCompletedOnboarding  = defaults.bool(forKey: "onboardingDone")
        playerName               = defaults.string(forKey: "playerName") ?? "Farmer Alex"
        coins                   = defaults.integer(forKey: "coins")
        streakDays              = defaults.integer(forKey: "streak")
        highScoreEggRun         = defaults.integer(forKey: "highScore")
        highScoreEggCatcher     = defaults.integer(forKey: "highScoreCatcher")
        totalQuizCorrect        = defaults.integer(forKey: "quizCorrect")
        chestsAvailable         = max(defaults.integer(forKey: "chests"), 1)
        lastOpenedDate          = defaults.object(forKey: "lastOpened") as? Date
        dailyChallenges         = DailyChallenge.todaysChallenges()

        if let saved = defaults.array(forKey: "unlockedChickens") as? [String] {
            unlockedChickens = saved.compactMap { UUID(uuidString: $0) }
        } else {
            unlockedChickens = Chicken.all.filter(\.isUnlocked).map(\.id)
        }

        updateStreak()
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        defaults.set(true, forKey: "onboardingDone")
    }

    func updatePlayerName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        playerName = trimmed
        defaults.set(trimmed, forKey: "playerName")
    }

    func addCoins(_ amount: Int) {
        coins += amount
        defaults.set(coins, forKey: "coins")
    }

    func spendCoins(_ amount: Int) -> Bool {
        guard coins >= amount else { return false }
        coins -= amount
        defaults.set(coins, forKey: "coins")
        return true
    }

    func updateHighScoreEggRun(_ score: Int) {
        if score > highScoreEggRun {
            highScoreEggRun = score
            defaults.set(score, forKey: "highScore")
        }
    }

    func updateHighScoreEggCatcher(_ score: Int) {
        if score > highScoreEggCatcher {
            highScoreEggCatcher = score
            defaults.set(score, forKey: "highScoreCatcher")
        }
    }

    func recordCorrectAnswer() {
        totalQuizCorrect += 1
        defaults.set(totalQuizCorrect, forKey: "quizCorrect")
    }

    func addChest() {
        chestsAvailable += 1
        defaults.set(chestsAvailable, forKey: "chests")
    }

    func openChest() -> Chicken? {
        guard chestsAvailable > 0 else { return nil }
        chestsAvailable -= 1
        defaults.set(chestsAvailable, forKey: "chests")

        let locked = Chicken.all.filter { !unlockedChickens.contains($0.id) }
        guard !locked.isEmpty else { return nil }

        let rand = Double.random(in: 0...1)
        let pool: [Chicken]
        if rand < 0.03        { pool = locked.filter { $0.rarity == .legendary }
        } else if rand < 0.15 { pool = locked.filter { $0.rarity == .epic }
        } else if rand < 0.40 { pool = locked.filter { $0.rarity == .rare }
        } else                { pool = locked.filter { $0.rarity == .common } }

        let winner = (pool.isEmpty ? locked : pool).randomElement()
        if let w = winner {
            unlockedChickens.append(w.id)
            defaults.set(unlockedChickens.map(\.uuidString), forKey: "unlockedChickens")
        }
        return winner
    }

    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = lastOpenedDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if diff == 1      { streakDays += 1 }
            else if diff > 1  { streakDays = 1 }
        } else {
            streakDays = 1
        }
        lastOpenedDate = Date()
        defaults.set(streakDays, forKey: "streak")
        defaults.set(Date(), forKey: "lastOpened")
    }

    func completeChallenge(id: UUID) {
        if let idx = dailyChallenges.firstIndex(where: { $0.id == id }) {
            dailyChallenges[idx].isCompleted = true
            addCoins(dailyChallenges[idx].reward)
        }
    }

    var allChallengesCompleted: Bool {
        dailyChallenges.allSatisfy(\.isCompleted)
    }
}
