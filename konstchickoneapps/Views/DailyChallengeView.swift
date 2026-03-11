import SwiftUI

struct DailyChallengeView: View {
    @EnvironmentObject var data: AppDataManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text("Today's Challenges")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                ) {
                    ForEach(data.dailyChallenges) { challenge in
                        ChallengeRow(challenge: challenge) {
                            data.completeChallenge(id: challenge.id)
                        }
                    }
                }

                Section(
                    header: Text("Rewards")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                ) {
                    HStack {
                        Text("🔥").font(.title2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Complete all 3 challenges")
                                .font(.system(size: 14, weight: .black, design: .rounded))
                            Text("Earn a bonus Mystery Chest!")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("📦")
                            .font(.title2)
                            .opacity(data.allChallengesCompleted ? 1 : 0.3)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Daily Challenges ⚡")
            .navigationBarItems(
                trailing: Button("Done") { dismiss() }
                    .font(.system(size: 15, weight: .bold, design: .rounded))
            )
        }
    }
}

// MARK: — Challenge Row

struct ChallengeRow: View {
    let challenge: DailyChallenge
    let onComplete: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Text(challenge.emoji).font(.title2)

            VStack(alignment: .leading, spacing: 3) {
                Text(challenge.title)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                Text(challenge.description)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(spacing: 2) {
                Text("+\(challenge.reward)")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundColor(.yellow)
                Text("🪙").font(.caption)
            }

            if challenge.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Button("Go!") { onComplete() }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .controlSize(.mini)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
        }
        .padding(.vertical, 6)
        .opacity(challenge.isCompleted ? 0.5 : 1)
    }
}
