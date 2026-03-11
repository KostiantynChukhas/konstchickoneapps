import SwiftUI

struct GamesHubView: View {
    @EnvironmentObject var data: AppDataManager
    @State private var selected: GameType? = nil

    enum GameType: String, Identifiable {
        case eggRun     = "Egg Run"
        case eggCatcher = "Egg Catcher"
        var id: String { rawValue }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Choose your game:")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    gameCard(
                        type: .eggRun,
                        emoji: "🥚",
                        title: "Egg Run",
                        description: "Jump over obstacles, collect eggs, run as far as you can!",
                        color: .orange,
                        best: "Best: \(data.highScoreEggRun) pts",
                        badge: "Runner"
                    )

                    gameCard(
                        type: .eggCatcher,
                        emoji: "🧺",
                        title: "Egg Catcher",
                        description: "Move your basket to catch falling eggs. Dodge the bombs!",
                        color: .yellow,
                        best: "Best: \(data.highScoreEggCatcher) pts",
                        badge: "Catcher"
                    )
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Games 🎮")
            .fullScreenCover(item: $selected) { type in
                if type == .eggRun {
                    EggRunGameView()
                        .environmentObject(data)
                } else {
                    EggCatcherGameView()
                        .environmentObject(data)
                }
            }
        }
    }

    private func gameCard(
        type: GameType,
        emoji: String,
        title: String,
        description: String,
        color: Color,
        best: String,
        badge: String
    ) -> some View {
        Button(action: { selected = type }) {
            HStack(spacing: 16) {
                // Big emoji
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(color.opacity(0.18))
                        .frame(width: 72, height: 72)
                    Text(emoji)
                        .font(.system(size: 42))
                }

                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(title)
                            .font(.system(size: 20, weight: .black, design: .rounded))
                            .foregroundColor(.primary)
                        Spacer()
                        Text(badge)
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(color.opacity(0.15))
                            .cornerRadius(8)
                    }

                    Text(description)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(best)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(color)
                }

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(color)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(22)
            .shadow(color: color.opacity(0.15), radius: 12, x: 0, y: 4)
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}
