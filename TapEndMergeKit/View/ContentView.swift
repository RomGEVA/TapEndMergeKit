//
//  ContentView.swift
//  TapAndMerge
//
//  Created by Роман Главацкий on 23.05.2025.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool?
    
    var body: some View {
        if !(hasSeenOnboarding ?? false) {
            OnboardingView()
        } else {
            MainMenuView()
        }
    }
}

#Preview {
    ContentView()
}
