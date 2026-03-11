import SwiftUI

// MARK: — Data

struct OnboardingPage {
    let emoji: String
    let title: String
    let subtitle: String
    let imageName: String
    let color: Color
}

// MARK: — Page Slide

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var bounce = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Swap Text(emoji) for Image(page.imageName) once assets are added
            Text(page.emoji)
                .font(.system(size: 100))
                .offset(y: bounce ? -12 : 0)
                .animation(
                    .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                    value: bounce
                )
                .onAppear { bounce = true }
                .shadow(radius: 20)

            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)

                Text(page.subtitle)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
            }

            Spacer()
        }
    }
}

// MARK: — Main Onboarding View

struct OnboardingView: View {
    @EnvironmentObject var data: AppDataManager
    @State private var currentPage = 0

    let pages: [OnboardingPage] = [
        OnboardingPage(
            emoji: "🐔",
            title: "Welcome to\nChickenVerse!",
            subtitle: "Your ultimate chicken universe. Tap, collect, quiz — and cluck your way to glory!",
            imageName: "onboarding_welcome",
            color: .yellow
        ),
        OnboardingPage(
            emoji: "🎮",
            title: "Play Mini Games",
            subtitle: "Run, jump and collect eggs in Egg Run! Dodge the fox and beat your high score!",
            imageName: "onboarding_games",
            color: .orange
        ),
        OnboardingPage(
            emoji: "🃏",
            title: "Collect 100+\nChickens",
            subtitle: "From common Clucky to legendary Dragon Cluck — build your ultimate farm!",
            imageName: "onboarding_collection",
            color: .purple
        ),
        OnboardingPage(
            emoji: "❓",
            title: "Cluck Quiz &\nDaily Challenges",
            subtitle: "Test your chicken knowledge, earn coins, and keep your streak alive!",
            imageName: "onboarding_quiz",
            color: .green
        ),
    ]

    var body: some View {
        ZStack {
            pages[currentPage].color.opacity(0.15)
                .ignoresSafeArea()
                .animation(.easeInOut, value: currentPage)

            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(pages.indices, id: \.self) { i in
                        OnboardingPageView(page: pages[i])
                            .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)

                bottomControls
            }
        }
    }

    private var bottomControls: some View {
        VStack(spacing: 20) {
            // Page dots
            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { i in
                    Circle()
                        .fill(i == currentPage ? pages[currentPage].color : Color.gray.opacity(0.3))
                        .frame(
                            width: i == currentPage ? 12 : 8,
                            height: i == currentPage ? 12 : 8
                        )
                        .animation(.spring(), value: currentPage)
                }
            }

            // Next / Start button
            Button(action: handleNext) {
                Text(currentPage < pages.count - 1 ? "Next →" : "Start Clucking! 🐣")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(pages[currentPage].color)
                    .cornerRadius(20)
                    .shadow(color: pages[currentPage].color.opacity(0.5), radius: 12, y: 6)
            }
            .padding(.horizontal, 32)

            // Skip
            if currentPage < pages.count - 1 {
                Button("Skip") {
                    data.completeOnboarding()
                }
                .foregroundColor(.gray)
                .font(.system(size: 14, weight: .medium))
            }
        }
        .padding(.bottom, 40)
    }

    private func handleNext() {
        if currentPage < pages.count - 1 {
            withAnimation { currentPage += 1 }
        } else {
            data.completeOnboarding()
        }
    }
}
