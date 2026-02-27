import SwiftUI

enum TabSelection: String, Hashable {
    case home
    case howToUse
}

struct LATabView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.colorScheme) var colorScheme
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
                TabView(selection: $appState.selectedTab) {
                    Tab(My.localizedString("TAB_HOME"), systemImage: "house", value: TabSelection.home) {
                        FrontDoorView()
                    }

                    Tab(My.localizedString("TAB_HOW_TO_USE"), systemImage: "questionmark.app", value: TabSelection.howToUse) {
                        InstructionsView()
                    }
                }
                .tint(colorScheme == .light ? .indigo : .white)
                .environmentObject(appState)
            }
        }
    }
}

#Preview {
    LATabView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
