import SwiftUI

struct ErrorMessageView: View {
    let errorMessage: String
    let onRetry: () -> Void
    var body: some View {
        VStack {
            // swiftlint:disable todo
            Text("Error reading audio file") // TODO: Localize
            // swiftlint:enable todo
                .font(.title)
            Text(errorMessage)
            Button {
                onRetry()
            } label: {
                // swiftlint:disable todo
                Text("Button to try again") // TODO: Localize
                    .font(.headline)
                // swiftlint:enable todo
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
