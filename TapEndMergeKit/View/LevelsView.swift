import SwiftUI

struct LevelsView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.levels) { level in
                            LevelRow(
                                level: level,
                                isSelected: viewModel.currentLevel.id == level.id
                            ) {
                                viewModel.setLevel(level)
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Уровни")
        }
    }
}

#Preview {
    NavigationView {
        LevelsView(viewModel: GameViewModel())
    }
} 