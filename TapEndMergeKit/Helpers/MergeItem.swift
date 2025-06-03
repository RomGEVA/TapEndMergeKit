import SwiftUI

struct MergeItem: Identifiable, Equatable {
    let id: UUID
    var type: Int
    var position: CGPoint
}

enum GameState {
    case playing
    case gameOver
} 