import SwiftUI
import Listen_Anonymously_Shared

struct FrontDoorView: View {
    var body: some View {
        ZStack {
            LinearGradient
                .lavenderToPastelBlue
                .ignoresSafeArea()
            

            Text("Give a small tip")
                .font(.title)
            Text("Give a big tip")
                .font(.title)
            Text("Give a super kind tip")
                .font(.title)

            // Offer default speed as in Settings.
        }
        .padding()
    }
}
