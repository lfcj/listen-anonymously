import SwiftUI

public extension View {
    func snapshot(with configuration: SnapshotConfiguration, needsWindow: Bool = false) -> UIImage {
        let snapshotView = SnapshotView(content: self, configuration: configuration)
        if needsWindow {
            let controller = UIHostingController(rootView: snapshotView)

            controller.view.setNeedsLayout()
            controller.view.layoutIfNeeded()
            return controller.snapshot(for: configuration)
        } else {
            let renderer = ImageRenderer(content: snapshotView)
            renderer.scale = configuration.traitCollection.displayScale
            renderer.proposedSize = ProposedViewSize(configuration.size)
            return renderer.uiImage!
        }
    }
}

