import SwiftUI

struct FrontDoorView: View {
    // Localize
    var body: some View {
        VStack {
            Text("Listen to your audio messages without leaving a trail.")
            HStack(spacing: -8) {
                Image(systemName: "checkmark")
                Image(systemName: "checkmark")
            }
            Text("No one will see the blue checkmarks after you listen to your voice message")
            
            Text("How to use?")
                .bold()
            
            Text("1. Select your message")
            Text("2. Tap on 'Forward'")
            Text("3. Scroll down and select 'Listen anonymously'")
            

            Text("Give a small tip")
                .font(.title)
            Text("Give a big tip")
                .font(.title)
            Text("Give a super kind tip")
                .font(.title)

            // Offer default speed as in Settings.
        }
    }
}
