import SwiftUI
import Listen_Anonymously_Shared

struct DonationButtonsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Vibe check 💬")
                .font(.title2.weight(.semibold))
                .foregroundColor(.white)
            
            Text("How much do you love being invisible?")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            
            HStack(spacing: 12) {
                Button {
                    // tip small
                } label: {
                    Label("Buy us a coffee", systemImage: "cup.and.saucer.fill")
                        .padding(.vertical, 12)
                }
                .buttonStyle(FrostyRoundedButtonStyle())
                
                Button {
                    // tip medium
                } label: {
                    Label("Send good vibes", systemImage: "heart.fill")
                        .padding(.vertical, 12)
                }
                .buttonStyle(FrostyRoundedButtonStyle())
            }
            
            Button {
                // super kind tip
            } label: {
                Label("Go ghost mode hero (super kind tip)", systemImage: "ghost.fill")
                    .padding(.vertical, 12)
            }
            .buttonStyle(FrostyRoundedButtonStyle(fullWidth: true))
            .padding(.top, 6)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient.lavenderToPastelBlue.ignoresSafeArea()
        DonationButtonsView()
    }
    .preferredColorScheme(.dark)
}
