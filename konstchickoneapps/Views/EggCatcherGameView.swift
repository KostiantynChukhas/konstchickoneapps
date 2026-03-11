import SwiftUI

// MARK: — Falling item
struct CatcherItem: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let type: ItemType
    var speed: CGFloat

    enum ItemType {
        case egg, goldenEgg, bomb, feather

        var emoji: String {
            switch self {
            case .egg:       return "🥚"
            case .goldenEgg: return "✨"
            case .bomb:      return "💣"
            case .feather:   return "🪶"
            }
        }
        var size: CGFloat {
            switch self {
            case .goldenEgg: return 36
            case .bomb:      return 34
            default:         return 30
            }
        }
        var points: Int {
            switch self {
            case .egg:       return 5
            case .goldenEgg: return 25
            case .bomb:      return 0
            case .feather:   return 3
            }
        }
    }
}

struct EggCatcherGameView: View {
    @EnvironmentObject var data: AppDataManager
    @Environment(\.dismiss) var dismiss

    // State
    @State private var phase: Phase = .idle
    @State private var score: Int = 0
    @State private var lives: Int = 3
    @State private var items: [CatcherItem] = []
    @State private var basketX: CGFloat = 0
    @State private var timeLeft: Int = 45
    @State private var hitFlash = false
    @State private var catchFlash = false
    @State private var scorePopups: [ScorePopup] = []

    // Timers
    @State private var gameLoop: Timer?
    @State private var spawnTimer: Timer?
    @State private var countdownTimer: Timer?

    @State private var arenaSize: CGSize = .zero

    // Combo
    @State private var combo: Int = 0
    @State private var lastCatchTime: Date = .distantPast

    enum Phase { case idle, playing, dead, timeUp }

    struct ScorePopup: Identifiable {
        let id = UUID()
        let text: String
        var x: CGFloat
        var y: CGFloat
        var opacity: Double = 1
    }

    private let basketW: CGFloat = 80
    private let basketH: CGFloat = 40
    private let tickInterval = 1.0 / 60.0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                hud
                arenaView
                    .frame(maxHeight: .infinity)
                controlArea
            }
            .navigationTitle("Egg Catcher 🧺")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: — HUD

    private var hud: some View {
        HStack(spacing: 0) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            // Score
            Label("\(score)", systemImage: "star.fill")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundColor(.yellow)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Timer
            ZStack {
                Capsule()
                    .fill(timeLeft <= 10 ? Color.red.opacity(0.15) : Color.green.opacity(0.15))
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                    Text("\(timeLeft)s")
                }
                .font(.system(size: 16, weight: .black, design: .rounded))
                .foregroundColor(timeLeft <= 10 ? .red : .green)
            }
            .frame(width: 80, height: 32)

            // Lives
            HStack(spacing: 3) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < lives ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            // Combo
            if combo >= 2 {
                Text("x\(combo)🔥")
                    .font(.system(size: 13, weight: .black, design: .rounded))
                    .foregroundColor(.orange)
                    .padding(.leading, 6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
    }

    // MARK: — Arena

    private var arenaView: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Background
                LinearGradient(
                    colors: [Color(red: 1.0, green: 0.95, blue: 0.75),
                             Color(red: 1.0, green: 0.85, blue: 0.5)],
                    startPoint: .top, endPoint: .bottom
                )

                // Barn-like bg stripes
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.orange.opacity(0.06))
                            .frame(width: w / 8)
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: w / 8)
                    }
                }

                // Falling items
                ForEach(items) { item in
                    Text(item.type.emoji)
                        .font(.system(size: item.type.size))
                        .position(x: item.x, y: item.y)
                }

                // Score popups
                ForEach(scorePopups) { popup in
                    Text(popup.text)
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(.orange)
                        .opacity(popup.opacity)
                        .position(x: popup.x, y: popup.y)
                }

                // Basket
                ZStack {
                    // Basket body
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(colors: [Color(red: 0.7, green: 0.4, blue: 0.1),
                                                    Color(red: 0.5, green: 0.25, blue: 0.05)],
                                           startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: basketW, height: basketH)
                    // Weave pattern
                    VStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { row in
                            HStack(spacing: 4) {
                                ForEach(0..<4, id: \.self) { _ in
                                    Rectangle()
                                        .fill(Color.brown.opacity(0.4))
                                        .frame(width: 14, height: 6)
                                        .cornerRadius(2)
                                }
                            }
                        }
                    }
                    Text("🧺")
                        .font(.system(size: 44))
                }
                .position(
                    x: max(basketW/2, min(basketX, w - basketW/2)),
                    y: h - basketH/2 - 8
                )
                .opacity(hitFlash ? 0.3 : 1)
                .animation(.easeInOut(duration: 0.06), value: hitFlash)

                // Overlay
                if phase != .playing {
                    overlayView()
                }
            }
            .onAppear {
                arenaSize = geo.size
                basketX = geo.size.width / 2
            }
            .onChange(of: geo.size) {
                arenaSize = $1
                basketX = $1.width / 2
            }
            // Drag basket left/right
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { val in
                        if phase == .playing {
                            basketX = val.location.x
                        }
                    }
            )
        }
    }

    // MARK: — Control area

    private var controlArea: some View {
        HStack(spacing: 0) {
            // Left arrow
            Button(action: { moveBasket(-30) }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .background(Color(.systemGray6))

            Divider()

            // Right arrow
            Button(action: { moveBasket(30) }) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .background(Color(.systemGray6))
        }
        .frame(height: 52)
    }

    // MARK: — Overlay

    @ViewBuilder
    private func overlayView() -> some View {
        ZStack {
            Color.black.opacity(0.5)
            VStack(spacing: 18) {
                if phase == .timeUp {
                    Text("⏰ Time's Up!")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Final Score: \(score)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    if score > data.highScoreEggCatcher {
                        Text("🏆 New High Score!")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundColor(.yellow)
                    }
                } else if phase == .dead {
                    Text("💣 Boom!")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("You ran out of lives! Score: \(score)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                } else {
                    Text("🧺 Egg Catcher")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    VStack(spacing: 6) {
                        Text("• Slide or tap arrows to move basket")
                        Text("• Catch 🥚 eggs (+5) and ✨ golden eggs (+25)")
                        Text("• Catch 🪶 feathers for bonus!")
                        Text("• Avoid 💣 bombs — lose a life!")
                        Text("• Build combos for extra points!")
                    }
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
                    if data.highScoreEggCatcher > 0 {
                        Text("Best: \(data.highScoreEggCatcher) pts")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                    }
                }

                let isEnd = (phase == .dead || phase == .timeUp)
                Button(isEnd ? "Play Again 🔄" : "Start Game 🧺") {
                    startGame()
                }
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(Color(red:0.15,green:0.1,blue:0.05))
                .padding(.horizontal, 36)
                .padding(.vertical, 14)
                .background(Color.yellow)
                .cornerRadius(20)
                .shadow(color: .yellow.opacity(0.7), radius: 12, y: 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 50)
        }
    }

    // MARK: — Start / Stop

    private func startGame() {
        stopTimers()
        score = 0
        lives = 3
        items = []
        scorePopups = []
        timeLeft = 45
        combo = 0
        phase = .playing

        let w = arenaSize.width
        basketX = w / 2

        // Physics tick
        gameLoop = Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { _ in
            tick()
        }

        // Spawn items
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            spawnItem()
        }

        // Countdown
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                endGame(reason: .timeUp)
            }
        }
    }

    private func stopTimers() {
        gameLoop?.invalidate(); gameLoop = nil
        spawnTimer?.invalidate(); spawnTimer = nil
        countdownTimer?.invalidate(); countdownTimer = nil
    }

    // MARK: — Tick

    private func tick() {
        guard phase == .playing, arenaSize.height > 0 else { return }
        let h = arenaSize.height
        let w = arenaSize.width
        let basketBaseY = h - basketH/2 - 8
        let clampedBX = max(basketW/2, min(basketX, w - basketW/2))

        var toRemove: [UUID] = []

        for i in items.indices {
            items[i].y += items[i].speed

            let itemX = items[i].x
            let itemY = items[i].y
            let sz    = items[i].type.size / 2

            // Check catch / miss
            let inBasketX = abs(itemX - clampedBX) < (basketW/2 + sz * 0.5)
            let inBasketY = itemY + sz >= basketBaseY - basketH/2 &&
                            itemY - sz <= basketBaseY + basketH/2

            if inBasketX && inBasketY {
                // Hit!
                if items[i].type == .bomb {
                    toRemove.append(items[i].id)
                    bombHit(at: CGPoint(x: itemX, y: itemY))
                } else {
                    let pts = catchItem(items[i])
                    addPopup("+\(pts)", at: CGPoint(x: itemX, y: itemY - 20))
                    toRemove.append(items[i].id)
                }
            } else if itemY > h + 40 {
                // Missed — only eggs/golden cost combo reset
                if items[i].type == .egg || items[i].type == .goldenEgg {
                    combo = 0
                }
                toRemove.append(items[i].id)
            }
        }

        items.removeAll { toRemove.contains($0.id) }

        // Fade popups
        for i in scorePopups.indices {
            scorePopups[i].y -= 1.5
            scorePopups[i].opacity -= 0.02
        }
        scorePopups.removeAll { $0.opacity <= 0 }
    }

    // MARK: — Spawn

    private func spawnItem() {
        guard phase == .playing, arenaSize.width > 0 else { return }
        let w = arenaSize.width
        let progress = Double(45 - timeLeft) / 45.0

        let x = CGFloat.random(in: 20...(w - 20))
        let baseSpeed = CGFloat.random(in: 3.5...5.5)
        let spd = baseSpeed + CGFloat(progress) * 3

        // Item type weights that evolve with time
        let roll = Double.random(in: 0...1)
        let bombChance = 0.12 + progress * 0.08
        let goldenChance = 0.08 + progress * 0.04
        let featherChance = 0.12

        let type: CatcherItem.ItemType
        if roll < bombChance         { type = .bomb }
        else if roll < bombChance + goldenChance { type = .goldenEgg }
        else if roll < bombChance + goldenChance + featherChance { type = .feather }
        else                         { type = .egg }

        items.append(CatcherItem(x: x, y: -20, type: type, speed: spd))

        // Sometimes spawn a second item
        if progress > 0.4 && Bool.random() {
            let x2 = CGFloat.random(in: 20...(w-20))
            items.append(CatcherItem(x: x2, y: -50, type: .egg, speed: baseSpeed))
        }
    }

    // MARK: — Catch logic

    private func catchItem(_ item: CatcherItem) -> Int {
        let now = Date()
        if now.timeIntervalSince(lastCatchTime) < 0.8 {
            combo += 1
        } else {
            combo = 1
        }
        lastCatchTime = now

        let multiplier = combo >= 3 ? 2 : 1
        let pts = item.type.points * multiplier
        score += pts
        return pts
    }

    // MARK: — Bomb hit

    private func bombHit(at point: CGPoint) {
        lives -= 1
        hitFlash = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { hitFlash = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { hitFlash = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { hitFlash = false }
        combo = 0
        addPopup("💥", at: point)
        if lives <= 0 { endGame(reason: .dead) }
    }

    // MARK: — Helpers

    private func moveBasket(_ delta: CGFloat) {
        guard phase == .playing, arenaSize.width > 0 else { return }
        basketX = max(basketW/2, min(basketX + delta, arenaSize.width - basketW/2))
    }

    private func addPopup(_ text: String, at point: CGPoint) {
        scorePopups.append(ScorePopup(text: text, x: point.x, y: point.y))
    }

    private func endGame(reason: Phase) {
        stopTimers()
        data.updateHighScoreEggCatcher(score)
        data.addCoins(score / 8)
        phase = reason
    }
}

// MARK: — Preview

#Preview("Idle State") {
    EggCatcherGameView()
        .environmentObject(AppDataManager())
}

#Preview("Playing State") {
    let view = EggCatcherGameView()
    return view
        .environmentObject(AppDataManager())
        .onAppear {
            // Симуляция игрового состояния
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Note: В реальном preview состояние будет idle
                // Для полного тестирования запустите приложение
            }
        }
}
