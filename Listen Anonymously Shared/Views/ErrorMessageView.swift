import SwiftUI

struct ErrorMessageView: View {
    @State var errorMessage: String
    var body: some View {
        VStack {
            Text("Error reading audio file") // TODO: Localize
                .font(.title)
            Text(errorMessage)
            Button {
                print("TO-DO")
            } label: {
                Text("Button to try again") // TODO: Localize
                    .font(.headline)
            }
            .buttonStyle(.glassProminent)
            
        }
        .foregroundStyle(.white)
        .padding(.all, 15)
        .background(Color.la_purple)
        .cornerRadius(20)
    }
}

#Preview {
    ErrorMessageView(errorMessage: "This is an error")
}

