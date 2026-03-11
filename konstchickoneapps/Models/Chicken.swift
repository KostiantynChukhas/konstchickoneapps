import Foundation

struct Chicken: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let imageName: String    // Placeholder until real assets loaded
    let rarity: Rarity
    let description: String
    var isUnlocked: Bool

    static let all: [Chicken] = [
        // MARK: Common
        Chicken(
            id: UUID(), name: "Clucky",
             imageName: "chicken_common_clucky",
            rarity: .common,
            description: "The OG chicken. Simple. Classic. Clucky.",
            isUnlocked: true
        ),
        Chicken(
            id: UUID(), name: "Baby Chick",
             imageName: "chicken_common_chick",
            rarity: .common,
            description: "Just hatched! Still wearing its eggshell hat.",
            isUnlocked: true
        ),
        Chicken(
            id: UUID(), name: "Red Hen",
            imageName: "chicken_common_red",
            rarity: .common,
            description: "A hard-working hen. Bakes bread on weekends.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Fluffy",
            imageName: "chicken_common_fluffy",
            rarity: .common,
            description: "Unusually fluffy. Like a cloud with a beak.",
            isUnlocked: false
        ),

        // MARK: Rare
        Chicken(
            id: UUID(), name: "Rooster Rex",
            imageName: "chicken_rare_rooster",
            rarity: .rare,
            description: "King of the yard. Wakes everyone at 5am. Unapologetic.",
            isUnlocked: true
        ),
        Chicken(
            id: UUID(), name: "Electric Blue",
            imageName: "chicken_rare_blue",
            rarity: .rare,
            description: "Charged with lightning energy. Do not lick.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Parrot Hen",
            imageName: "chicken_rare_parrot",
            rarity: .rare,
            description: "Speaks 3 languages. All of them squawking.",
            isUnlocked: false
        ),

        // MARK: Epic
        Chicken(
            id: UUID(), name: "Ninja Cluck",
            imageName: "chicken_epic_ninja",
            rarity: .epic,
            description: "Silent. Deadly. Loves mealworms.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Astronaut Hen",
            imageName: "chicken_epic_astronaut",
            rarity: .epic,
            description: "First chicken on the moon. Planted an egg flag.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Chef Poulet",
             imageName: "chicken_epic_chef",
            rarity: .epic,
            description: "Ironic career choice. World-class omelette maker.",
            isUnlocked: false
        ),

        // MARK: Legendary
        Chicken(
            id: UUID(), name: "Golden Hen",
             imageName: "chicken_legendary_gold",
            rarity: .legendary,
            description: "Lays golden eggs. Very smug about it.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Dragon Cluck",
            imageName: "chicken_legendary_dragon",
            rarity: .legendary,
            description: "Half chicken, half dragon. 100% terrifying.",
            isUnlocked: false
        ),
        Chicken(
            id: UUID(), name: "Rainbow Chick",
             imageName: "chicken_legendary_rainbow",
            rarity: .legendary,
            description: "Pure magic. Leaves a rainbow trail wherever it goes.",
            isUnlocked: false
        ),
    ]
}
