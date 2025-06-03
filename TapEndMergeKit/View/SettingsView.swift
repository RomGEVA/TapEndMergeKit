//
//  SettingsView.swift
//  TapAndMerge
//
//  Created by Роман Главацкий on 23.05.2025.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GameViewModel
    @State private var showResetAlert = false
    
    var body: some View {
        ZStack{
            BackgroundView()
            VStack {
                VStack {
                    Section(header: Text("About Game")) {
                        Text("Tap & Merge - a game for developing logic and reaction speed.")
                    }
                    Section(header: Text("Rules")) {
                        Text("1. Connect identical balls\n2. Score points\n3. Unlock new levels")
                    }
                }
                .foregroundStyle(.white)
                .bold()
                .padding()
                .background(content: {
                    Color.black
                        .opacity(0.3)
                        .cornerRadius(20)
                })
                
                MenuButton(title: "Rate Us", systemImage: "star.fill") {
                    SKStoreReviewController.requestReview()
                }
                MenuButton(title: "Privacy Policy", systemImage: "info.bubble.fill.rtl") {
                    if let url = URL(string: "https://www.termsfeed.com/live/13ae2b34-8446-4888-997f-32695f1b4eb4") {
                        UIApplication.shared.open(url)
                    }
                }
                MenuButton(title: "Reset Progress", systemImage: "memories") {
                    showResetAlert = true
                }
                
            }.padding()
                .navigationTitle("Settings")
                .alert("Reset Progress?", isPresented: $showResetAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Reset", role: .destructive) {
                        resetProgress()
                    }
                } message: {
                    Text("All progress will be deleted. This action cannot be undone.")
                }
        }
    }
    
    private func resetProgress() {
        // Сбрасываем все уровни, кроме первого
        for i in 1..<viewModel.levels.count {
            viewModel.levels[i].isUnlocked = false
        }
        
        // Устанавливаем текущий уровень на первый
        viewModel.currentLevel = viewModel.levels[0]
        
        // Очищаем сохраненные данные
        UserDefaults.standard.removeObject(forKey: "gameProgress")
        
        // Перезапускаем игру
        viewModel.restartGame()
        
        // Показываем уведомление об успешном сбросе
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

#Preview {
    SettingsView(viewModel: GameViewModel())
}
