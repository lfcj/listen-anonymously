import SwiftUI

struct ContentView: View {

    @EnvironmentObject var appState: AppState

    // TODO: LOCALIZE
    var body: some View {
        ZStack {
            if !appState.hasCompletedInitialSetup {
                PostLaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak appState] in
                            appState?.handlePostLaunch()
                        }
                    }
            } else {
                FrontDoorView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
