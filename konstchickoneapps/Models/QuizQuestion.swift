import Foundation

struct QuizQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
    let funFact: String
    let category: QuizCategory

    enum QuizCategory: String, CaseIterable {
        case facts   = "🐔 Chicken Facts"
        case science = "🔬 Egg Science"
        case farm    = "🌾 Farm Life"
        case culture = "🌍 Culture"
        case silly   = "😂 Silly"
    }

    static let bank: [QuizQuestion] = [
        QuizQuestion(
            question: "How many eggs does a hen lay per year on average?",
            options: ["Around 50", "250–300", "100–150", "Over 500"],
            correctIndex: 1,
            funFact: "Modern laying hens can produce 250–300 eggs per year — nearly one per day!",
            category: .facts
        ),
        QuizQuestion(
            question: "How long does it take to hatch a chicken egg?",
            options: ["14 days", "21 days", "28 days", "7 days"],
            correctIndex: 1,
            funFact: "It takes exactly 21 days for a chicken egg to hatch at 37.5°C.",
            category: .science
        ),
        QuizQuestion(
            question: "What is a group of chickens called?",
            options: ["A pack", "A herd", "A flock", "A colony"],
            correctIndex: 2,
            funFact: "A group of chickens is called a flock. A group of hens specifically is a clutch.",
            category: .facts
        ),
        QuizQuestion(
            question: "Which country has the most chickens in the world?",
            options: ["USA", "Brazil", "China", "India"],
            correctIndex: 2,
            funFact: "China has over 5 billion chickens — more than any other country!",
            category: .culture
        ),
        QuizQuestion(
            question: "Can chickens fly?",
            options: ["No, not at all", "Yes, but only short distances", "Yes, like eagles", "Only at night"],
            correctIndex: 1,
            funFact: "Chickens can fly, but only short distances — usually to roost or escape danger.",
            category: .facts
        ),
        QuizQuestion(
            question: "What do you call a male chicken?",
            options: ["A hen", "A rooster", "A pullet", "A gander"],
            correctIndex: 1,
            funFact: "A male chicken is called a rooster (or cock). A female is a hen. A baby is a chick.",
            category: .facts
        ),
        QuizQuestion(
            question: "What color can chicken eggs be? (Pick the WRONG one)",
            options: ["White", "Brown", "Blue-green", "Purple"],
            correctIndex: 3,
            funFact: "Araucana chickens lay blue-green eggs! But no chicken lays purple eggs... yet.",
            category: .science
        ),
        QuizQuestion(
            question: "Why did the chicken cross the road?",
            options: ["To lay an egg", "To get to the other side", "To find wifi", "To attend Cluck School"],
            correctIndex: 1,
            funFact: "The classic joke dates back to 1847. Still no satisfactory answer from chickens.",
            category: .silly
        ),
        QuizQuestion(
            question: "What is the scientific name for the domestic chicken?",
            options: ["Gallus gallus domesticus", "Aves domesticus", "Pollo vulgaris", "Feather rex"],
            correctIndex: 0,
            funFact: "The domestic chicken, Gallus gallus domesticus, was domesticated around 8,000 years ago!",
            category: .science
        ),
        QuizQuestion(
            question: "How many bones does a chicken have?",
            options: ["Over 200", "Around 120", "About 60", "Exactly 33"],
            correctIndex: 1,
            funFact: "Chickens have around 120 bones. Some fuse together as they grow, like in human babies.",
            category: .science
        ),
    ]
}
