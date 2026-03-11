import Foundation

struct Chicken: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let emoji: String        // Placeholder until real assets loaded
    let imageName: String    // Asset catalog name
    let rarity: Rarity
    let description: String
    var isUnlocked: Bool

    static let all: [Chicken] = [
        // MARK: Common
        Chicken(
            id: UUID(), name: "Clucky",
            emoji: "🐔", imageName: "chicken_common_clucky",
            rarity: .common,
            description: "The OG chicken. Simple. Classic. Clucky.",
            isUnlocked: true
        ),
        Chicken(
            id: UUID(), name: "Baby Chick",
            emoji: "🐣", imageName: "chicken_common_chick",
            rarity: .common,
            description: "Just hatched! Still wearing its eggshell hat.",
            isUnlocked: true
        ),
        Chicken(
            id: UUID(), name: "Red Hen",
            emoji: "🐓", imageName: "chicken_common_red",
            rarity: .common,
            description: "A hard-working hen. Bakes bread on weekends.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Fluffy",
            emoji: "🐤", imageName: "chicken_common_fluffy",
            rarity: .common,
            description: "Unusually fluffy. Like a cloud with a beak.",
            isUnlocked: false
        ),

        // MARK: Rare
        Chicken(
            id: UUID(), name: "Rooster Rex",
            emoji: "🐓", imageName: "chicken_rare_rooster",
            rarity: .rare,
            description: "King of the yard. Wakes everyone at 5am. Unapologetic.",
            isUnlocked: true
        ),
        Chicken(
            id: UUID(), name: "Electric Blue",
            emoji: "⚡", imageName: "chicken_rare_blue",
            rarity: .rare,
            description: "Charged with lightning energy. Do not lick.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Parrot Hen",
            emoji: "🦜", imageName: "chicken_rare_parrot",
            rarity: .rare,
            description: "Speaks 3 languages. All of them squawking.",
            isUnlocked: false
        ),

        // MARK: Epic
        Chicken(
            id: UUID(), name: "Ninja Cluck",
            emoji: "🥷", imageName: "chicken_epic_ninja",
            rarity: .epic,
            description: "Silent. Deadly. Loves mealworms.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Astronaut Hen",
            emoji: "🚀", imageName: "chicken_epic_astronaut",
            rarity: .epic,
            description: "First chicken on the moon. Planted an egg flag.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Chef Poulet",
            emoji: "👨‍🍳", imageName: "chicken_epic_chef",
            rarity: .epic,
            description: "Ironic career choice. World-class omelette maker.",
            isUnlocked: false
        ),

        // MARK: Legendary
        Chicken(
            id: UUID(), name: "Golden Hen",
            emoji: "✨", imageName: "chicken_legendary_gold",
            rarity: .legendary,
            description: "Lays golden eggs. Very smug about it.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Dragon Cluck",
            emoji: "🐉", imageName: "chicken_legendary_dragon",
            rarity: .legendary,
            description: "Half chicken, half dragon. 100% terrifying.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Rainbow Chick",
            emoji: "🌈", imageName: "chicken_legendary_rainbow",
            rarity: .legendary,
            description: "Pure magic. Leaves a rainbow trail wherever it goes.",
            isUnlocked: false
        ),
    ]
}
