import SwiftUI

class GameViewModel: ObservableObject {
    @Published var items: [MergeItem] = []
    @Published var score: Int = 0
    @Published var gameState: GameState = .playing
    @Published var selectedItem: MergeItem? = nil
    @Published var currentLevel: Level
    @Published var levels: [Level]
    @Published var showWinAlert = false
    @Published var showLoseAlert = false
    
    let gridSize = 4
    let itemSize: CGFloat = 60
    let spacing: CGFloat = 12
    let areaSize: CGFloat = 4 * 60 + 3 * 12
    
    private var timer: Timer?
    private let saveVersion = "1.0" // Версия сохранения
    
    init() {
        let initialLevels = Level.levels
        self.levels = initialLevels
        self.currentLevel = initialLevels[0]
        loadProgress()
        startTimer()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: currentLevel.spawnInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.gameState == .playing {
                self.addRandomItem()
            }
        }
    }
    
    func addRandomItem() {
        guard gameState == .playing else { return }
        
        if items.count >= gridSize * gridSize {
            gameState = .gameOver
            timer?.invalidate()
            showLoseAlert = true
            return
        }
        
        var position: CGPoint
        var attempts = 0
        let maxAttempts = 10
        
        repeat {
            let x = CGFloat(Int.random(in: 0..<gridSize))
            let y = CGFloat(Int.random(in: 0..<gridSize))
            position = CGPoint(x: x, y: y)
            attempts += 1
        } while items.contains(where: { $0.position == position }) && attempts < maxAttempts
        
        if attempts >= maxAttempts {
            gameState = .gameOver
            timer?.invalidate()
            showLoseAlert = true
            return
        }
        
        let newItem = MergeItem(id: UUID(), type: Int.random(in: 1...2), position: position)
        items.append(newItem)
    }
    
    func mergeItems(_ item1: MergeItem, _ item2: MergeItem) {
        guard item1 != item2, item1.type == item2.type, item1.position != item2.position else { return }
        guard let idx1 = items.firstIndex(of: item1), let idx2 = items.firstIndex(of: item2) else { return }
        let newType = item1.type + 1
        let newPosition = item1.position
        let newItem = MergeItem(id: UUID(), type: newType, position: newPosition)
        items.remove(at: max(idx1, idx2))
        items.remove(at: min(idx1, idx2))
        items.append(newItem)
        score += newType * 10
        
        if score >= currentLevel.requiredScore {
            gameState = .gameOver
            timer?.invalidate()
            unlockNextLevel()
            showWinAlert = true
        }
        
        selectedItem = nil
        
        if items.count >= gridSize * gridSize {
            gameState = .gameOver
            timer?.invalidate()
            showLoseAlert = true
        }
    }
    
    func restartGame() {
        items.removeAll()
        score = 0
        gameState = .playing
        selectedItem = nil
        showWinAlert = false
        showLoseAlert = false
        startTimer()
        addRandomItem()
        addRandomItem()
    }
    
    func setLevel(_ level: Level) {
        currentLevel = level
        restartGame()
    }
    
    func nextLevel() {
        if let currentIndex = levels.firstIndex(where: { $0.id == currentLevel.id }),
           currentIndex + 1 < levels.count {
            currentLevel = levels[currentIndex + 1]
            restartGame()
        }
    }
    
    private func unlockNextLevel() {
        if let currentIndex = levels.firstIndex(where: { $0.id == currentLevel.id }),
           currentIndex + 1 < levels.count {
            levels[currentIndex + 1].isUnlocked = true
            saveProgress()
        }
    }
    
    private func saveProgress() {
        let saveData = SaveData(version: saveVersion, levels: levels)
        if let encoded = try? JSONEncoder().encode(saveData) {
            UserDefaults.standard.set(encoded, forKey: "gameProgress")
        }
    }
    
    private func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: "gameProgress"),
           let saveData = try? JSONDecoder().decode(SaveData.self, from: data) {
            if saveData.version == saveVersion {
                levels = saveData.levels
                currentLevel = levels.first(where: { $0.isUnlocked }) ?? levels[0]
            }
        }
    }
}

// Структура для сохранения данных
struct SaveData: Codable {
    let version: String
    let levels: [Level]
} 