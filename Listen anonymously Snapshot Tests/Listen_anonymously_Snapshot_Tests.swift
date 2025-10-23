internal import Listen_Anonymously_Shared
@testable import Listen_anonymously
import SwiftUI
import XCTest

@MainActor
final class Listen_anonymously_Snapshot_Tests: XCTestCase {

    func test_frontDoor() {
        let frontDoor = FrontDoorView()

        record(snapshot: frontDoor.snapshot(with: .iPhone17Pro(style: .light)), named: "FRONT_DOOR_light")
        record(snapshot: frontDoor.snapshot(with: .iPhone17Pro(style: .dark)), named: "FRONT_DOOR_dark")
    }

    func test_instructions() {
        let viewModel = InstructionsViewModel()
        viewModel.supportedApps = [.telegram, .whatsApp]
        viewModel.selectedApp = .whatsApp
        let instructionsView = InstructionsView(viewModel: viewModel)

        record(snapshot: instructionsView.snapshot(with: .iPhone17Pro(style: .light), needsWindow: true), named: "INSTRUCTIONS_light")
        record(snapshot: instructionsView.snapshot(with: .iPhone17Pro(style: .dark), needsWindow: true), named: "INSTRUCTIONS_dark")
    }

}
