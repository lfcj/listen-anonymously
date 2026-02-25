import Listen_Anonymously_Shared
import Testing
import ViewInspector
@testable import Listen_anonymously

@MainActor
struct ListenAnonExtensionViewTests {

    @Test("view shows anon-icon, which is in a different framework")
    func anonIcon_isDisplayed() throws {
        let view = ListenAnonExtensionView()

        let inspectedImageName = try view.inspect().label(0).icon().image(0).actualImage().name()

        #expect(inspectedImageName == "anon-icon")
    }

}
