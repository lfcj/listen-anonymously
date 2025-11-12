import Testing
@testable import Listen_Anonymously_Shared

struct PlayingRateTests {

    @Test func nextForSlowIsNormalRate() {
        #expect(PlayingRate.slow.next == .normal)
    }

    @Test func nextForNormalIsFastRate() {
        #expect(PlayingRate.normal.next == .fast)
    }

    @Test func nextForFastIsSuperFastRate() {
        #expect(PlayingRate.fast.next == .superFast)
    }

    @Test func nextForSuperFastIsSlowRate() {
        #expect(PlayingRate.superFast.next == .slow)
    }

}
