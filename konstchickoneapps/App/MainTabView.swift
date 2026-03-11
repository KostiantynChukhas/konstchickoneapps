import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            GamesHubView()
                .tabItem { Label("Play", systemImage: "gamecontroller.fill") }
                .tag(1)

            CollectionView()
                .tabItem { Label("Farm", systemImage: "square.grid.3x3.fill") }
                .tag(2)

            QuizView()
                .tabItem { Label("Quiz", systemImage: "questionmark.bubble.fill") }
                .tag(3)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(4)
        }
        .tint(.orange)
    }
}
