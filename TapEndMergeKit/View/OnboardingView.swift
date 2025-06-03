import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Welcome to Tap & Merge!",
            description: "Combine elements, score points, and progress through levels in this exciting game.",
            imageName: "gamecontroller.fill",
            gradient: [Color.blue, Color.purple]
        ),
        OnboardingPage(
            title: "How to Play?",
            description: "Tap on identical elements to merge them into the next level element. Get points for each merge!",
            imageName: "hand.tap.fill",
            gradient: [Color.purple, Color.pink]
        ),
        OnboardingPage(
            title: "Levels and Goals",
            description: "Each level has its own score goal. Reach it to unlock the next level!",
            imageName: "star.fill",
            gradient: [Color.pink, Color.orange]
        )
    ]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Spacer()
                    Button("Skip") {
                        withAnimation {
                            showOnboarding = false
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.3))
                    )
                    .padding()
                }
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        withAnimation {
                            showOnboarding = false
                        }
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Next" : "Start Game")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: pages[currentPage].gradient),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .shadow(color: pages[currentPage].gradient[0].opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let gradient: [Color]
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .font(.system(size: 100))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: page.gradient),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: page.gradient[0].opacity(0.3), radius: 10, x: 0, y: 5)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            Text(page.title)
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
            
            Text(page.description)
                .font(.system(size: 17))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.8))
                .padding(.horizontal, 30)
        }
        .padding()
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
} 