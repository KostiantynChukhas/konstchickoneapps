import SwiftUI

struct CollectionView: View {
    @EnvironmentObject var data: AppDataManager

    @State private var selectedRarity: Rarity? = nil
    @State private var showChestResult = false
    @State private var wonChicken: Chicken? = nil

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    private var displayed: [Chicken] {
        Chicken.all.filter { selectedRarity == nil || $0.rarity == selectedRarity }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                rarityFilter
                if data.chestsAvailable > 0 { chestBanner }
                collectionInfo
                chickenGrid
            }
            .navigationTitle("My Farm 🃏")
            .sheet(isPresented: $showChestResult) {
                ChestResultView(chicken: wonChicken)
            }
        }
    }

    // MARK: — Rarity Filter

    private var rarityFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterPill(label: "All", color: .orange, isActive: selectedRarity == nil) {
                    selectedRarity = nil
                }
                ForEach(Rarity.allCases, id: \.self) { r in
                    FilterPill(label: r.rawValue, color: r.color, isActive: selectedRarity == r) {
                        selectedRarity = r
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

    // MARK: — Chest Banner

    private var chestBanner: some View {
        Button(action: openChest) {
            HStack(spacing: 12) {
                Text("📦").font(.system(size: 32))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Open Mystery Chest!")
                        .font(.system(size: 15, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("\(data.chestsAvailable) chest\(data.chestsAvailable > 1 ? "s" : "") available")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(14)
            .background(
                LinearGradient(
                    colors: [.purple, .indigo],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .padding(.horizontal)
        }
    }

    // MARK: — Collection Info

    private var collectionInfo: some View {
        HStack {
            Text("\(data.unlockedChickens.count)/\(Chicken.all.count) collected")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }

    // MARK: — Grid

    private var chickenGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(displayed) { chicken in
                    ChickenCard(
                        chicken: chicken,
                        isUnlocked: data.unlockedChickens.contains(chicken.id)
                    )
                }
            }
            .padding()
        }
    }

    // MARK: — Actions

    private func openChest() {
        wonChicken = data.openChest()
        showChestResult = true
    }
}

// MARK: — Chest Result Sheet

struct ChestResultView: View {
    let chicken: Chicken?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("📦").font(.system(size: 80))

            if let c = chicken {
                Text("You got:")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)

                Image(c.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Text(c.name)
                    .font(.system(size: 28, weight: .black, design: .rounded))

                Text(c.rarity.rawValue)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(c.rarity.color)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(c.rarity.color.opacity(0.12))
                    .cornerRadius(12)

                Text(c.description)
                    .font(.system(size: 14, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                Text("😅 You have all chickens!")
                    .font(.system(size: 20, weight: .black, design: .rounded))
            }

            Spacer()

            Button("Awesome! 🎉") { dismiss() }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
                .font(.system(size: 18, weight: .black, design: .rounded))
        }
        .padding()
    }
}
