import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data: AppDataManager

    var body: some View {
        if data.hasCompletedOnboarding {
            MainTabView()
        } else {
            OnboardingView()
        }
    }
}
