import Listen_Anonymously_Shared
import SwiftUI
import UIKit

class ActionViewController: UIViewController {

    private(set) lazy var playingManager = AudioPlayingManager(extensionContext: self.extensionContext)

    private var injectedExtensionContext: NSExtensionContext?
    private var isIOS26Available = false

    private var usableExtensionContext: NSExtensionContext? {
        injectedExtensionContext ?? self.extensionContext
    }

    init(
        playingManager: AudioPlayingManager,
        extensionContext: NSExtensionContext? = nil,
        isIOS26Available: Bool? = nil
    ) {
        super.init(nibName: nil, bundle: nil)
        self.playingManager = playingManager
        self.injectedExtensionContext = extensionContext
        if #available(iOS 26, *) {
            self.isIOS26Available = true
        }
        if let isIOS26Available {
            self.isIOS26Available = isIOS26Available
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = .fullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(
            rootView: AudioPlayingView(playingManager: playingManager)
        )
        findAudio()
        let navigationController = UINavigationController(rootViewController: hostingController)
        hostingController.navigationItem.rightBarButtonItem = makeDoneButton()

        addChild(navigationController)
        navigationController.view.frame = self.view.bounds
        hostingController.view.frame = self.view.bounds
        view.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
    }

    private func makeDoneButton() -> UIBarButtonItem {
        let style: UIBarButtonItem.Style
        if isIOS26Available, #available(iOS 26, *) {
            style = .prominent
        } else {
            style = .done
        }
        return UIBarButtonItem(
            title: "Done", // TODO: Localize
            style: style,
            target: self,
            action: #selector(completeRequest)
        )
        
    }

    @objc private func completeRequest() {
        guard let extensionContext = self.usableExtensionContext else {
            return
        }
        extensionContext.completeRequest(returningItems: extensionContext.inputItems, completionHandler: nil)
    }

    private func findAudio() {
        Task {
            await playingManager.findAudio(isSecondAttempt: false)
        }
    }
}
