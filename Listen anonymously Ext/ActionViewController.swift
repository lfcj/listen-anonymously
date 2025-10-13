import Listen_Anonymously_Shared
import SwiftUI
import UIKit

class ActionViewController: UIViewController {

    private lazy var playingManager = AudioPlayingManager(extensionContext: self.extensionContext)

    init(playingManager: AudioPlayingManager) {
        super.init(nibName: nil, bundle: nil)
        self.playingManager = playingManager
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
        if #available(iOS 26, *) {
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
        guard let extensionContext = self.extensionContext else {
            return
        }
        extensionContext.completeRequest(returningItems: extensionContext.inputItems, completionHandler: nil)
    }

    private func findAudio() {
        Task {
            await playingManager.findAudio()
        }
    }
}
