import SwiftUI

struct FrontDoorTitleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Stay unseen.")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .lineLimit(2)

            Text("Still in the loop.")
                .font(.system(size: 40, weight: .bold, design: .rounded))

            Text("Listen to your voice messages without anyone knowing you did.")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .padding(.top, 6)
        }
        .foregroundColor(.white)
    }
}

#Preview {
    ZStack {
        LinearGradient.lavenderToPastelBlue.ignoresSafeArea()
        FrontDoorTitleView()
    }
}
