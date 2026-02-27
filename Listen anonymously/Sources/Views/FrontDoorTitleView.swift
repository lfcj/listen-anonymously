import Listen_Anonymously_Shared
import SwiftUI

struct FrontDoorTitleView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(My.localizedString("STAY_UNSEEN"))
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .lineLimit(2)
                .accessibilityIdentifier(AccessibilityIdentifier.Titles.stayUnseen)

            Text(My.localizedString("STILL_IN_THE_LOOP"))
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .accessibilityIdentifier(AccessibilityIdentifier.Titles.stillInTheLoop)

            Text(My.localizedString("LISTEN_WITHOUT_KNOWING"))
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .padding(.top, 6)
                .lineLimit(3)
                .frame(minHeight: 50)
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
