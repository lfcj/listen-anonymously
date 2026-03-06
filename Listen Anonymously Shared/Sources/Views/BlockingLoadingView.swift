import SwiftUI

public struct BlockingLoadingView: View {
    public init() {}
    public var body: some View {
        Color.black.opacity(0.35)
            .ignoresSafeArea()

        VStack(spacing: 16) {
            ProgressView()
                .tint(.white)
                .progressViewStyle(.circular)
                .scaleEffect(1.8)
            Text(My.localizedString("LOADING"))
                .font(.callout.weight(.medium))
                .foregroundStyle(.white)
        }
        .frame(width: 140, height: 140)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    BlockingLoadingView()
}
