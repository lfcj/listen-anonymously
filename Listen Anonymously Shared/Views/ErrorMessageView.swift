import SwiftUI

struct ErrorMessageView: View {
    let errorMessage: String
    let onRetry: () -> Void
    var body: some View {
        VStack {
            Text("Error reading audio file") // TODO: Localize
                .font(.title)
            Text(errorMessage)
            Button {
                onRetry()
            } label: {
                Text("Button to try again") // TODO: Localize
                    .font(.headline)
            }
            .borderedOrGlassButtonStyle()
            .padding()
        }
        .foregroundStyle(.white)
        .padding(.all, 15)
        .background(.laPurple)
        .cornerRadius(20)
    }
}

#Preview {
    ErrorMessageView(
        errorMessage: "This is an error",
        onRetry: {}
    )
}

