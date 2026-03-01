import UIKit

public final class SnapshotWindow: UIWindow {

    private var configuration: SnapshotConfiguration = .iPad10(style: .light)

    public convenience init?(configuration: SnapshotConfiguration, root: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        self.init(windowScene: windowScene)
        self.configuration = configuration
        self.frame = CGRect(origin: .zero, size: configuration.size)
        self.layoutMargins = configuration.layoutMargins
        self.rootViewController = root
        self.isHidden = false
        root.view.frame = CGRect(origin: .zero, size: configuration.size)
        root.view.layoutMargins = configuration.layoutMargins
    }

    public override var safeAreaInsets: UIEdgeInsets {
        configuration.safeAreaInsets
    }

    public override var traitCollection: UITraitCollection {
        configuration.traitCollection
    }

    func snapshot() -> UIImage {
        layoutIfNeeded()
        let renderer = UIGraphicsImageRenderer(bounds: bounds, format: UIGraphicsImageRendererFormat(for: traitCollection))
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }

}
