import SwiftUI

struct ErrorMessageView: View {
    let errorMessage: String
    let onRetry: () -> Void
    var body: some View {
        VStack {
            Text(My.localizedString("ERROR_READING_AUDIO"))
                .font(.title)
            Text(errorMessage)
            Button {
                onRetry()
            } label: {
                Text(My.localizedString("TRY_AGAIN"))
                    .font(.headline)
            }
            .borderedOrGlassButtonStyle()
            .padding()
        }
        .foregroundStyle(.white)
        .padding(.all, 15)
        .background(Color.laPurple)
        .cornerRadius(20)
    }
}

#Preview {
    ErrorMessageView(
        errorMessage: "This is an error",
        onRetry: {}
    )
}
