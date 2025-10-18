import SwiftUI

struct PlayingViewButton: View {
    let imageName: String
    let size: CGSize
    let action: () -> Void
    var body: some View {
        Button(
            action: action,
            label: {
                Image(systemName: imageName)
                    .frame(width: size.width, height: size.height)
                    .tint(.white)
            }
        )
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.la_magenta))
    }
}

