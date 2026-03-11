import SwiftUI

enum Rarity: String, CaseIterable, Codable {
    case common    = "Common"
    case rare      = "Rare"
    case epic      = "Epic"
    case legendary = "Legendary"

    var color: Color {
        switch self {
        case .common:    return .gray
        case .rare:      return .blue
        case .epic:      return .purple
        case .legendary: return .yellow
        }
    }

    var dropChance: Double {
        switch self {
        case .common:    return 0.60
        case .rare:      return 0.25
        case .epic:      return 0.12
        case .legendary: return 0.03
        }
    }
}
