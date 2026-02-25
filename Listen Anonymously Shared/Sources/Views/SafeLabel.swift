import SwiftUI

public struct SafeLabel: View {

    let title: String
    let icon: String

    public init(title: String, icon: String) {
        self.title = title
        self.icon = icon
    }

    public var body: some View {
        Label {
            Text(title)
        } icon: {
            if UIImage(systemName: icon) != nil {
                Image(systemName: icon)
            } else {
                Text(icon)
            }
        }
    }

}
