import SwiftUI

struct HomeView: View {
    @EnvironmentObject var data: AppDataManager
    @State private var showDailyChallenge = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    headerBanner
                    dailyChallengeButton
                    quickAccessGrid
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
            .navigationTitle("Cricken Broadway 🐔")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: — Header

    private var headerBanner: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(
                colors: [.orange, .yellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(24)

            VStack(alignment: .leading, spacing: 6) {
                Text("Good morning! 👋")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))

                Text("\(data.playerName) 🐔")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)

                HStack {
                    Label("\(data.streakDays) Day Streak!", systemImage: "flame.fill")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.25))
                        .cornerRadius(12)

                    Spacer()

                    Label("\(data.coins)", systemImage: "circle.fill")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.yellow)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.white.opacity(0.25))
                        .cornerRadius(12)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("🐔")
                .font(.system(size: 60))
                .opacity(0.3)
                .offset(x: -16, y: 8)
        }
        .frame(height: 140)
        .padding(.horizontal)
    }

    // MARK: — Daily Challenge

    private var dailyChallengeButton: some View {
        Button(action: { showDailyChallenge = true }) {
            HStack(spacing: 14) {
                Text("⚡").font(.system(size: 32))

                VStack(alignment: .leading, spacing: 3) {
                    Text("Daily Challenge")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("3 challenges await — earn up to 90 🪙")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [.red, .orange],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(18)
            .padding(.horizontal)
        }
        .sheet(isPresented: $showDailyChallenge) {
            DailyChallengeView()
        }
    }

    // MARK: — Quick Access Grid

    private var quickAccessGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 12
        ) {
            QuickCard(emoji: "🥚", title: "Egg Run",
                      subtitle: "Best: \(data.highScoreEggRun) pts", color: .orange)
            QuickCard(emoji: "🧺", title: "Egg Catcher",
                      subtitle: "Best: \(data.highScoreEggCatcher) pts", color: .yellow)
            QuickCard(emoji: "❓", title: "Cluck Quiz",
                      subtitle: "\(QuizQuestion.bank.count) questions", color: .green)
            QuickCard(emoji: "🃏", title: "My Farm",
                      subtitle: "\(data.unlockedChickens.count)/\(Chicken.all.count) chickens", color: .purple)
        }
        .padding(.horizontal)
    }
}
