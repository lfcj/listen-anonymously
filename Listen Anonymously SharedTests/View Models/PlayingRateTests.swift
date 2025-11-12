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

    @Test func prevForSlowIsSuperFastRate() {
        #expect(PlayingRate.slow.prev == .superFast)
    }

    @Test func prevForNormalIsSlowRate() {
        #expect(PlayingRate.normal.prev == .slow)
    }

    @Test func prevForFastIsNormalRate() {
        #expect(PlayingRate.fast.prev == .normal)
    }

    @Test func prevForSuperFastIsFastRate() {
        #expect(PlayingRate.superFast.prev == .fast)
    }

    @Test func stringHasXAsSuffix() {
        #expect(PlayingRate.slow.string == "0.75x")
        #expect(PlayingRate.normal.string == "1x")
        #expect(PlayingRate.fast.string == "1.5x")
        #expect(PlayingRate.superFast.string == "2x")
    }

}
