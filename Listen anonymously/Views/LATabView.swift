import SwiftUI

struct LATabView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        ZStack {
            if !appState.hasCompletedInitialSetup {
                PostLaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak appState] in
                            appState?.handlePostLaunch()
                        }
                    }
            } else {
                TabView {
                    Tab("Home", systemImage: "house") {
                        FrontDoorView()
                    }

                    Tab("How to use", systemImage: "questionmark.app") {
                        InstructionsView()
                    }
                }
                .tint(.indigo)
            }
        }
    }
}

#Preview {
    LATabView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
