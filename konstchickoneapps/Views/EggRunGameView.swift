import SwiftUI

// MARK: — Game constants
private enum C {
    static let groundY: CGFloat    = 80     // height of ground strip
    static let chickenX: CGFloat   = 80     // fixed X of the chicken
    static let chickenSize: CGFloat = 48
    static let eggSize: CGFloat    = 32
    static let foxSize: CGFloat    = 40
    static let jumpHeight: CGFloat = 130
    static let gravity: CGFloat    = 6.0
    static let foxSpeed: CGFloat   = 5.0
    static let tickInterval: Double = 1.0 / 60.0
}

// MARK: — EggRun obstacle
struct RunObstacle: Identifiable {
    let id = UUID()
    var x: CGFloat
    let type: ObstacleType
    enum ObstacleType { case fox, rock }
    var emoji: String { type == .fox ? "🦊" : "🪨" }
}

// MARK: — Main View
struct EggRunGameView: View {
    @EnvironmentObject var data: AppDataManager
    @Environment(\.dismiss) var dismiss

    // Game state
    @State private var phase: Phase = .idle
    @State private var score: Int = 0
    @State private var distance: Int = 0    // metres
    @State private var lives: Int = 3

    // Chicken physics
    @State private var chickenY: CGFloat = 0          // offset from ground, 0 = on ground
    @State private var velocityY: CGFloat = 0
    @State private var isOnGround = true

    // Collectibles + obstacles
    @State private var eggs: [RunEgg] = []
    @State private var obstacles: [RunObstacle] = []

    // Speed increases over time
    @State private var speed: CGFloat = C.foxSpeed

    // Timers
    @State private var gameLoop: Timer?
    @State private var spawnTimer: Timer?
    @State private var scoreTimer: Timer?

    // Hit flash
    @State private var hitFlash = false

    // Geometry
    @State private var arenaSize: CGSize = .zero

    enum Phase { case idle, playing, dead }

    struct RunEgg: Identifiable {
        let id = UUID()
        var x: CGFloat
        var y: CGFloat        // y from bottom of arena (above ground)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // ── HUD ──
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    
                    Label("\(score)", systemImage: "star.fill")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundColor(.yellow)
                    Spacer()
                    Text("📏 \(distance)m")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(.secondary)
                    Spacer()
                    HStack(spacing: 3) {
                        ForEach(0..<3, id: \.self) { i in
                            Image(systemName: i < lives ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(.systemBackground))

                // ── Arena ──
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height

                    ZStack {
                        // Sky gradient
                        LinearGradient(
                            colors: [Color(red: 0.53, green: 0.81, blue: 0.98),
                                     Color(red: 0.87, green: 0.95, blue: 1.0)],
                            startPoint: .top, endPoint: .bottom
                        )

                        // Clouds (decorative, static-ish)
                        Text("☁️").font(.system(size: 28)).position(x: w * 0.15, y: h * 0.15)
                        Text("☁️").font(.system(size: 20)).position(x: w * 0.55, y: h * 0.22)
                        Text("☁️").font(.system(size: 24)).position(x: w * 0.80, y: h * 0.10)

                        // Ground strip
                        VStack(spacing: 0) {
                            Spacer()
                            Rectangle()
                                .fill(
                                    LinearGradient(colors: [Color(red:0.3,green:0.7,blue:0.3),
                                                            Color(red:0.2,green:0.55,blue:0.2)],
                                                   startPoint: .top, endPoint: .bottom)
                                )
                                .frame(height: C.groundY)
                        }

                        // Fence stripes on ground
                        VStack {
                            Spacer()
                            HStack(spacing: 0) {
                                ForEach(0..<Int(w/40), id: \.self) { i in
                                    Rectangle()
                                        .fill(Color.brown.opacity(0.5))
                                        .frame(width: 3, height: 20)
                                    Spacer()
                                }
                            }
                            .padding(.bottom, C.groundY - 20)
                        }

                        // Eggs
                        ForEach(eggs) { egg in
                            Text("🥚")
                                .font(.system(size: C.eggSize))
                                .position(x: egg.x,
                                          y: h - C.groundY - egg.y - C.eggSize/2)
                        }

                        // Obstacles
                        ForEach(obstacles) { obs in
                            Text(obs.emoji)
                                .font(.system(size: C.foxSize))
                                .position(x: obs.x,
                                          y: h - C.groundY - C.foxSize/2)
                        }

                        // Chicken — y=0 means feet on ground
                        Text("🐔")
                            .font(.system(size: C.chickenSize))
                            .scaleEffect(x: 1, y: 1)
                            .position(
                                x: C.chickenX,
                                y: h - C.groundY - chickenY - C.chickenSize/2
                            )
                            .opacity(hitFlash ? 0.2 : 1)
                            .animation(.easeInOut(duration: 0.05), value: hitFlash)

                        // Overlay screens
                        if phase != .playing {
                            overlayView(w: w, h: h)
                        }
                    }
                    .onAppear { arenaSize = geo.size }
                    .onChange(of: geo.size) { arenaSize = $1 }
                    .contentShape(Rectangle())
                    .onTapGesture { handleTap() }
                }

                // ── Power-up bar ──
                if phase == .playing {
                    HStack(spacing: 0) {
                        powerBtn(emoji: "⚡", label: "Speed") { speed = min(speed + 1, 12) }
                        powerBtn(emoji: "🛡️", label: "Shield") { lives = min(lives + 1, 3) }
                        powerBtn(emoji: "🧲", label: "Magnet") { collectAllEggs() }
                    }
                    .background(Color(.systemBackground))
                }
            }
            .navigationTitle("Egg Run 🥚")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: — Overlay

    @ViewBuilder
    private func overlayView(w: CGFloat, h: CGFloat) -> some View {
        ZStack {
            Color.black.opacity(0.45)
            VStack(spacing: 18) {
                if phase == .dead {
                    Text("💀 Game Over!")
                        .font(.system(size: 30, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Text("Score: \(score)  •  \(distance)m")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                    if score > data.highScoreEggRun {
                        Text("🏆 New High Score!")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundColor(.yellow)
                    }
                } else {
                    Text("🥚 Egg Run")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    VStack(spacing: 6) {
                        Text("• TAP to jump")
                        Text("• Collect 🥚 eggs for points")
                        Text("• Dodge 🦊 foxes and 🪨 rocks")
                        Text("• Game speeds up over time!")
                    }
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
                    if data.highScoreEggRun > 0 {
                        Text("Best: \(data.highScoreEggRun) pts")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(.yellow)
                    }
                }

                Button(phase == .dead ? "Play Again 🔄" : "Start Game 🐔") {
                    startGame()
                }
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundColor(Color(red:0.15,green:0.1,blue:0.05))
                .padding(.horizontal, 36)
                .padding(.vertical, 14)
                .background(Color.orange)
                .cornerRadius(20)
                .shadow(color: .orange.opacity(0.7), radius: 12, y: 5)
            }
            .padding(28)
        }
    }

    // MARK: — Power-up button

    private func powerBtn(emoji: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Text(emoji).font(.system(size: 22))
                Text(label)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
    }

    // MARK: — Input

    private func handleTap() {
        guard phase == .playing else { return }
        jump()
    }

    private func jump() {
        guard isOnGround else { return }
        velocityY = 18
        isOnGround = false
    }

    // MARK: — Start / Stop

    private func startGame() {
        stopTimers()
        score = 0
        distance = 0
        lives = 3
        chickenY = 0
        velocityY = 0
        isOnGround = true
        eggs = []
        obstacles = []
        speed = C.foxSpeed
        phase = .playing

        // Main physics + collision loop at 60fps
        gameLoop = Timer.scheduledTimer(withTimeInterval: C.tickInterval, repeats: true) { _ in
            tick()
        }

        // Spawn eggs every 1.4s
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 1.4, repeats: true) { _ in
            spawnObjects()
        }

        // Distance counter
        scoreTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            distance += 1
            // Speed ramp every 10m
            if distance % 10 == 0 {
                speed = min(speed + 0.4, 14)
            }
        }
    }

    private func stopTimers() {
        gameLoop?.invalidate(); gameLoop = nil
        spawnTimer?.invalidate(); spawnTimer = nil
        scoreTimer?.invalidate(); scoreTimer = nil
    }

    // MARK: — Tick (physics + scroll + collision)

    private func tick() {
        let w = arenaSize.width
        guard w > 0, phase == .playing else { return }

        // ── Physics ──
        if !isOnGround {
            velocityY -= C.gravity * CGFloat(C.tickInterval) * 60 * 0.1
            chickenY += velocityY * CGFloat(C.tickInterval) * 60 * 0.35
            if chickenY <= 0 {
                chickenY = 0
                velocityY = 0
                isOnGround = true
            }
        }

        // ── Scroll eggs ──
        eggs = eggs
            .map { e in RunEgg(x: e.x - speed, y: e.y) }
            .filter { $0.x > -C.eggSize }

        // ── Scroll obstacles ──
        obstacles = obstacles
            .map { o in RunObstacle(x: o.x - speed, type: o.type) }
            .filter { $0.x > -C.foxSize }

        // ── Collect eggs ──
        let cxRange = (C.chickenX - 24)...(C.chickenX + 24)
        let h = arenaSize.height
        let chickenBottom = h - C.groundY - chickenY
        let chickenTop    = chickenBottom - C.chickenSize

        var collected: [UUID] = []
        for egg in eggs {
            let eggCX = egg.x
            let eggTop    = h - C.groundY - egg.y - C.eggSize
            let eggBottom = eggTop + C.eggSize
            if cxRange.contains(eggCX) && !(chickenBottom < eggTop || chickenTop > eggBottom) {
                collected.append(egg.id)
                score += 10
            }
        }
        if !collected.isEmpty {
            eggs.removeAll { collected.contains($0.id) }
        }

        // ── Hit obstacle ──
        for obs in obstacles {
            let obsCX = obs.x
            let obsTop    = h - C.groundY - C.foxSize
            let obsBottom = h - C.groundY
            let hitX = abs(obsCX - C.chickenX) < 28
            let hitY = !(chickenBottom < obsTop || chickenTop > obsBottom)
            if hitX && hitY {
                obstacles.removeAll { $0.id == obs.id }
                loseLife()
                return
            }
        }
    }

    // MARK: — Spawn

    private func spawnObjects() {
        guard phase == .playing, arenaSize.width > 0 else { return }
        let w = arenaSize.width

        // Spawn egg cluster or single egg
        let spawnEgg = Int.random(in: 0...2) != 0  // 2/3 chance
        if spawnEgg {
            let count = Int.random(in: 1...3)
            let baseX = w + 30
            for i in 0..<count {
                let yOff: CGFloat = [0, 30, 60, 90].randomElement()!
                eggs.append(RunEgg( x: baseX + CGFloat(i * 60), y: yOff + 10))
            }
        }

        // Spawn obstacle (less frequent early, more later)
        let obsChance = min(0.3 + Double(distance) * 0.008, 0.7)
        if Double.random(in: 0...1) < obsChance {
            let type: RunObstacle.ObstacleType = Bool.random() ? .fox : .rock
            obstacles.append(RunObstacle( x: w + 50, type: type))
        }
    }

    // MARK: — Life / Game Over

    private func loseLife() {
        lives -= 1
        hitFlash = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { hitFlash = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { hitFlash = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.30) { hitFlash = false }

        if lives <= 0 {
            stopTimers()
            data.updateHighScoreEggRun(score)
            data.addCoins(score / 5)
            phase = .dead
        }
    }

    private func collectAllEggs() {
        score += eggs.count * 10
        eggs = []
    }
}

// MARK: — Preview

#Preview("Idle State") {
    EggRunGameView()
        .environmentObject(AppDataManager())
}

#Preview("With High Score") {
    let dataManager = AppDataManager()
    dataManager.highScoreEggRun = 1250
    return EggRunGameView()
        .environmentObject(dataManager)
}
