import SwiftUI

// MARK: — QuickCard (Home grid)

struct QuickCard: View {
    let emoji: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(emoji).font(.system(size: 32))

            Text(title)
                .font(.system(size: 15, weight: .black, design: .rounded))

            Text(subtitle)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1.5)
        )
        .cornerRadius(16)
    }
}

// MARK: — PowerUpButton (Egg Run)

struct PowerUpButton: View {
    let emoji: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(emoji).font(.title2)
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: — ChickenCard (Collection grid)

struct ChickenCard: View {
    let chicken: Chicken
    let isUnlocked: Bool

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(chicken.rarity.color.opacity(0.12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(chicken.rarity.color.opacity(0.4), lineWidth: 1.5)
                    )

                Text(isUnlocked ? chicken.emoji : "🔒")
                    .font(.system(size: 36))
                    .grayscale(isUnlocked ? 0 : 1)
                    .opacity(isUnlocked ? 1 : 0.4)
            }
            .frame(height: 72)

            Text(isUnlocked ? chicken.name : "???")
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundColor(.primary)
                .lineLimit(1)

            Text(isUnlocked ? chicken.rarity.rawValue : "Locked")
                .font(.system(size: 9, weight: .bold, design: .rounded))
                .foregroundColor(chicken.rarity.color)
        }
    }
}

// MARK: — FilterPill (Collection filter bar)

struct FilterPill: View {
    let label: String
    let color: Color
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isActive ? color : color.opacity(0.1))
                .foregroundColor(isActive ? .white : color)
                .cornerRadius(12)
        }
    }
}

// MARK: — StatRow (Profile)

struct StatRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(icon)
            Text(label)
                .font(.system(size: 15, design: .rounded))
            Spacer()
            Text(value)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: — AchievementRow (Profile)

struct AchievementRow: View {
    let emoji: String
    let title: String
    let desc: String
    let done: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(emoji)
                .font(.title2)
                .grayscale(done ? 0 : 1)
                .opacity(done ? 1 : 0.4)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .black, design: .rounded))
                Text(desc)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }

            Spacer()

            if done {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
}
