//
//  AppDelegate.swift
//  konstchickoneapps
//
//  Created by Kostiantyn Chukhas on 11.03.2026.
//

import UIKit
import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let store = AppDataManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootView = RootView()
            .environmentObject(store)
            .preferredColorScheme(.light)
        
        window.rootViewController = UIHostingController(rootView: rootView)
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

// MARK: - Root View that responds to onboarding changes
struct RootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        if hasSeenOnboarding {
            ContentView()
        } else {
            OnboardingView()
        }
    }
}

