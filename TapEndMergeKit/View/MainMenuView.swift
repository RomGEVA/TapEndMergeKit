import SwiftUI



struct MainMenuView: View {
    @State private var showGame = false
    @State private var showSettings = false
    @State private var showRules = false
    @State private var showLevels = false
    @StateObject private var viewModel = GameViewModel()
    @State private var showOnboarding = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 25) {
                    Text("Tap & Merge")
                        .font(.system(size: 52, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.black,
                                    Color.purple
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        .overlay(
                            Text("Tap & Merge")
                                .font(.system(size: 52, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.white.opacity(0.5),
                                            Color.white.opacity(0.2)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .blur(radius: 1)
                                .offset(x: 1, y: 1)
                        )
                        .padding(.top, 50)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        MenuButton(title: "Play", systemImage: "play.fill", action: {showGame = true})
                        
                        MenuButton(title: "Levels", systemImage: "list.number", action: {showLevels = true})
                        
                        MenuButton(title: "Settings", systemImage: "gearshape.fill") {
                            showSettings = true
                        }
                        MenuButton(title: "Rules", systemImage: "book.fill", action: {showRules = true})
                        
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
                .padding(.vertical, 50)
            }
            .navigationDestination(isPresented: $showGame, destination: {
                GameView(viewModel: viewModel)
                    .navigationBarBackButtonHidden()
            })
            .navigationDestination(isPresented: $showLevels, destination: {
                LevelsView(viewModel: viewModel)
            })
            .navigationDestination(isPresented: $showSettings, destination: {
                SettingsView( viewModel: viewModel)
            })
            .navigationDestination(isPresented: $showRules, destination: {
                RulesView()
                    .navigationBarBackButtonHidden()
            })
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView(showOnboarding: $showOnboarding)
            }
            .onAppear {
                if !hasSeenOnboarding {
                    showOnboarding = true
                    hasSeenOnboarding = true
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        MainMenuView()
    }
}
