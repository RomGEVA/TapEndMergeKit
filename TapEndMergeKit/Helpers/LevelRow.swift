import SwiftUI

struct LevelRow: View {
    let level: Level
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Номер уровня
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    isSelected ? Color.blue : Color.gray.opacity(0.3),
                                    isSelected ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: isSelected ? Color.blue.opacity(0.3) : Color.clear, radius: 5)
                    
                    Text("\(level.id)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(isSelected ? .white : .gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(level.id)")
                        .font(.headline)
                        .foregroundColor(isSelected ? .black : .gray)
                    
                    Text("Goal: \(level.requiredScore) points")
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .black.opacity(0.7) : .gray.opacity(0.7))
                }
                
                Spacer()
                
                // Иконка замка или стрелки
                if level.isUnlocked {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isSelected ? .blue : .gray)
                        .opacity(isSelected ? 1 : 0.5)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: isSelected ? Color.blue.opacity(0.2) : Color.black.opacity(0.05),
                           radius: isSelected ? 10 : 5,
                           x: 0,
                           y: isSelected ? 5 : 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isSelected ? Color.blue.opacity(0.5) : Color.clear,
                                isSelected ? Color.blue.opacity(0.2) : Color.clear
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!level.isUnlocked)
    }
}

#Preview {
    VStack(spacing: 15) {
        LevelRow(level: Level(id: 1, requiredScore: 1000, spawnInterval: 2.0, isUnlocked: true), isSelected: true) {}
        LevelRow(level: Level(id: 2, requiredScore: 2000, spawnInterval: 1.8, isUnlocked: true), isSelected: false) {}
        LevelRow(level: Level(id: 3, requiredScore: 3000, spawnInterval: 1.6, isUnlocked: false), isSelected: false) {}
    }
    .padding()
    .background(Color(.systemGroupedBackground))
} 
