//
//  RulesView.swift
//  TapAndMerge
//
//  Created by Роман Главацкий on 23.05.2025.
//

import SwiftUI

struct RulesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 25) {
                Text("Game Rules")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 15) {
                    RuleRow(number: "1", text: "Press 'Play' to start the game.")
                    RuleRow(number: "2", text: "Tap on two identical elements to merge them into the next level element.")
                    RuleRow(number: "3", text: "Get points for each merge: type * 10.")
                    RuleRow(number: "4", text: "If the field is full (16 elements) - game over.")
                    RuleRow(number: "5", text: "Press 'Restart' for a new game.")
                }
                .padding(.horizontal)
                
                Spacer()
                
                GameButton(title: "Close", systemImage: "xmark.circle.fill") {
                    dismiss()
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.9))
                    .shadow(radius: 20)
            )
            .padding()
        }
    }
}
