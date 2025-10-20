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
                if #available(iOS 18.0, *) {
                    TabView {
                        Tab("Home", systemImage: "house") {
                            FrontDoorView()
                        }

                        Tab("How to use", systemImage: "questionmark.app") {
                            InstructionsView()
                        }
                    }
                    .tint(.indigo)
                } else {
                    TabView {
                        FrontDoorView()
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                        
                        InstructionsView()
                            .tabItem {
                                Label("How to use", systemImage: "questionmark.app")
                            }
                    }
                    .tint(.indigo)
                }
            }
        }
    }
}

#Preview {
    LATabView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
