import Foundation

struct Level: Identifiable, Codable {
    let id: Int
    let requiredScore: Int
    let spawnInterval: TimeInterval
    var isUnlocked: Bool
    
    static let levels: [Level] = [
        Level(id: 1, requiredScore: 1000, spawnInterval: 2.0, isUnlocked: true),
        Level(id: 2, requiredScore: 2000, spawnInterval: 1.8, isUnlocked: false),
        Level(id: 3, requiredScore: 3000, spawnInterval: 1.6, isUnlocked: false),
        Level(id: 4, requiredScore: 4000, spawnInterval: 1.4, isUnlocked: false),
        Level(id: 5, requiredScore: 5000, spawnInterval: 1.2, isUnlocked: false),
        Level(id: 6, requiredScore: 6000, spawnInterval: 1.0, isUnlocked: false),
        Level(id: 7, requiredScore: 7000, spawnInterval: 0.9, isUnlocked: false),
        Level(id: 8, requiredScore: 8000, spawnInterval: 0.8, isUnlocked: false),
        Level(id: 9, requiredScore: 9000, spawnInterval: 0.7, isUnlocked: false),
        Level(id: 10, requiredScore: 10000, spawnInterval: 0.6, isUnlocked: false)
    ]
} 