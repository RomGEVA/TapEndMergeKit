import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            // Основной градиент
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Декоративные круги
            ForEach(0..<5) { index in
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.2),
                                Color.purple.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: CGFloat.random(in: 100...300))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .blur(radius: 2)
            }
            
            // Декоративные прямоугольники
            ForEach(0..<3) { index in
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.purple.opacity(0.15),
                                Color.blue.opacity(0.15)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: CGFloat.random(in: 150...250),
                           height: CGFloat.random(in: 150...250))
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .blur(radius: 25)
            }
        }
        .ignoresSafeArea()
    }
}

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            // Фоновое вью
            BackgroundView()
            
            VStack(spacing: 16) {
                // Верхняя панель
                HStack {
                    VStack(alignment: .leading) {
                        Text("Level \(viewModel.currentLevel.id)")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.black)
                        Text("Goal: \(viewModel.currentLevel.requiredScore) points")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Score: \(viewModel.score)")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.black)
                        Text("of \(viewModel.currentLevel.requiredScore)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white.opacity(0.9))
                        .shadow(radius: 5)
                )
                .padding(.horizontal)
                
                // Игровое поле
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.9))
                        .shadow(radius: 10)
                        .frame(width: viewModel.areaSize, height: viewModel.areaSize)
                    
                    ForEach(viewModel.items) { item in
                        MergeItemView(item: item, isSelected: viewModel.selectedItem == item)
                            .position(x: 30 + item.position.x * (viewModel.itemSize + viewModel.spacing) + viewModel.itemSize/2,
                                      y: 30 + item.position.y * (viewModel.itemSize + viewModel.spacing) + viewModel.itemSize/2)
                            .onTapGesture {
                                handleTap(on: item)
                            }
                            .matchedGeometryEffect(id: item.id, in: animation)
                    }
                }
                .frame(width: viewModel.areaSize + 60, height: viewModel.areaSize + 60)
                .padding()
                
                // Кнопки управления
                HStack(spacing: 20) {
                    GameButton(title: "Restart", systemImage: "arrow.clockwise") {
                        withAnimation(.easeInOut) {
                            viewModel.restartGame()
                        }
                    }
                    
                    GameButton(title: "Menu", systemImage: "house") {
                        dismiss()
                    }
                }
            }
            .blur(radius: (viewModel.showWinAlert || viewModel.showLoseAlert) ? 5 : 0)
            
            if viewModel.showWinAlert {
                GameAlertView(
                    title: "Victory! 🎉",
                    message: "You have typed \(viewModel.score) in \(viewModel.currentLevel.requiredScore) scores!",
                    primaryButton: "Next level",
                    secondaryButton: "Into menu",
                    primaryAction: {
                        viewModel.nextLevel()
                    },
                    secondaryAction: {
                        dismiss()
                    }
                )
            }
            
            if viewModel.showLoseAlert {
                GameAlertView(
                    title: "Defeat 😢",
                    message: "The field is filled in!\nyou have typed \(viewModel.score) in \(viewModel.currentLevel.requiredScore) scores!",
                    primaryButton: "Restart",
                    secondaryButton: "Into menu",
                    primaryAction: {
                        viewModel.restartGame()
                    },
                    secondaryAction: {
                        dismiss()
                    }
                )
            }
        }
        .onAppear {
            viewModel.restartGame()
        }
    }
    
    private func handleTap(on item: MergeItem) {
        if let selected = viewModel.selectedItem {
            if selected == item {
                viewModel.selectedItem = nil
            } else if selected.type == item.type {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    viewModel.mergeItems(selected, item)
                }
            } else {
                viewModel.selectedItem = item
            }
        } else {
            viewModel.selectedItem = item
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel())
}

struct GameButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 150, height: 44)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(22)
            .shadow(radius: 5)
        }
    }
}

struct GameAlertView: View {
    let title: String
    let message: String
    let primaryButton: String
    let secondaryButton: String
    let primaryAction: () -> Void
    let secondaryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title)
                .bold()
                .foregroundStyle(.black)
            
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.black)
            
            VStack(spacing: 12) {
                Button(action: primaryAction) {
                    Text(primaryButton)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 250, height: 44)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(22)
                        .shadow(radius: 5)
                }
                
                Button(action: secondaryAction) {
                    Text(secondaryButton)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(width: 250, height: 44)
                        .background(Color.white)
                        .cornerRadius(22)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .shadow(radius: 3)
                }
            }
        }
        
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(radius: 20)
        )
        .padding()
    }
}

struct MergeItemView: View {
    let item: MergeItem
    let isSelected: Bool
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [color(for: item.type), color(for: item.type).opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 4)
                        .shadow(color: isSelected ? .white : .clear, radius: 5)
                )
                .shadow(radius: 5)
            
            Text("\(item.type)")
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .shadow(radius: 2)
        }
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
    
    func color(for type: Int) -> Color {
        switch type {
        case 1: return .orange
        case 2: return .green
        case 3: return .blue
        case 4: return .purple
        case 5: return .pink
        default: return .gray
        }
    }
}

struct RuleRow: View {
    let number: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text(number)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
} 
