import SwiftUI

struct AudioLoadingView: View {
    var body: some View {
        VStack {
            Text(My.localizedString("LOADING"))
            ProgressView()
        }
        .frame(width: 100, height: 100)
        .padding(.all, 10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    AudioLoadingView()
}
