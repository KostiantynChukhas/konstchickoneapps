import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var data: AppDataManager
    @State private var showEditName = false
    @State private var editingName = ""

    var body: some View {
        NavigationView {
            List {
                profileHeader
                statsSection
                achievementsSection
            }
            .navigationTitle("Profile 👤")
            .sheet(isPresented: $showEditName) {
                EditNameSheet(name: $editingName) {
                    data.updatePlayerName(editingName)
                }
            }
        }
    }

    // MARK: — Header

    private var profileHeader: some View {
        Section {
            VStack(spacing: 14) {
                // Avatar circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(colors: [.orange, .yellow],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .frame(width: 80, height: 80)
                    Text("🐔")
                        .font(.system(size: 44))
                }

                // Name + edit button
                HStack(spacing: 8) {
                    Text(data.playerName)
                        .font(.system(size: 22, weight: .black, design: .rounded))

                    Button(action: {
                        editingName = data.playerName
                        showEditName = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                    }
                }

                Text("Chicken Enthusiast 🌾")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)

                // Quick stats row
                HStack(spacing: 0) {
                    quickStat(value: "\(data.streakDays)", label: "Streak", icon: "🔥")
                    Divider().frame(height: 36)
                    quickStat(value: "\(data.coins)", label: "Coins", icon: "🪙")
                    Divider().frame(height: 36)
                    quickStat(value: "\(data.unlockedChickens.count)/\(Chicken.all.count)", label: "Farm", icon: "🃏")
                }
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(14)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
    }

    private func quickStat(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 3) {
            Text(icon).font(.system(size: 18))
            Text(value)
                .font(.system(size: 16, weight: .black, design: .rounded))
            Text(label)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: — Stats

    private var statsSection: some View {
        Section("📊 Stats") {
            StatRow(icon: "🔥", label: "Streak",              value: "\(data.streakDays) days")
            StatRow(icon: "🪙", label: "Coins",               value: "\(data.coins)")
            StatRow(icon: "🥚", label: "Egg Run Best",        value: "\(data.highScoreEggRun) pts")
            StatRow(icon: "🧺", label: "Egg Catcher Best",    value: "\(data.highScoreEggCatcher) pts")
            StatRow(icon: "🧠", label: "Quiz Correct",        value: "\(data.totalQuizCorrect)")
            StatRow(icon: "🃏", label: "Collection",          value: "\(data.unlockedChickens.count)/\(Chicken.all.count)")
        }
    }

    // MARK: — Achievements

    private var achievementsSection: some View {
        Section("🏆 Achievements") {
            AchievementRow(
                emoji: "🥚", title: "First Egg",
                desc: "Play Egg Run for the first time",
                done: data.highScoreEggRun > 0
            )
            AchievementRow(
                emoji: "🧺", title: "Catcher!",
                desc: "Score 50+ in Egg Catcher",
                done: data.highScoreEggCatcher >= 50
            )
            AchievementRow(
                emoji: "🔥", title: "On Fire!",
                desc: "Reach a 7-day streak",
                done: data.streakDays >= 7
            )
            AchievementRow(
                emoji: "📚", title: "Trivia Master",
                desc: "Answer 50 questions correctly",
                done: data.totalQuizCorrect >= 50
            )
            AchievementRow(
                emoji: "👑", title: "Legendary Farmer",
                desc: "Unlock a Legendary chicken",
                done: data.unlockedChickens.contains(where: { id in
                    Chicken.all.first(where: { $0.id == id })?.rarity == .legendary
                })
            )
            AchievementRow(
                emoji: "🌈", title: "Full Flock",
                desc: "Collect all chickens",
                done: data.unlockedChickens.count >= Chicken.all.count
            )
        }
    }
}

// MARK: — Edit Name Sheet

struct EditNameSheet: View {
    @Binding var name: String
    let onSave: () -> Void
    @Environment(\.dismiss) var dismiss
    @FocusState private var focused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 28) {
                Text("🐔")
                    .font(.system(size: 72))
                    .padding(.top, 20)

                VStack(spacing: 8) {
                    Text("Your Farmer Name")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                    Text("How should the chickens call you?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }

                TextField("Enter name...", text: $name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(16)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.orange.opacity(0.5), lineWidth: 2)
                    )
                    .padding(.horizontal, 32)
                    .focused($focused)
                    .onAppear { focused = true }

                Text("\(name.count)/20 characters")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(name.count > 20 ? .red : .secondary)

                Button(action: {
                    onSave()
                    dismiss()
                }) {
                    Text("Save 💾")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(name.trimmingCharacters(in: .whitespaces).isEmpty || name.count > 20
                            ? Color.gray : Color.orange)
                        .cornerRadius(18)
                        .padding(.horizontal, 32)
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || name.count > 20)

                Spacer()
            }
            .navigationTitle("Edit Name")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancel") { dismiss() })
        }
    }
}
