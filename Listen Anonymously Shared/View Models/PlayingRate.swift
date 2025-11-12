enum PlayingRate: Float, CaseIterable {
    case slow = 0.75
    case normal = 1.0
    case fast = 1.5
    case superFast = 2.0

    var next: PlayingRate {
        switch self {
        case .slow:
            return .normal
        case .normal:
            return .fast
        case .fast:
            return .superFast
        case .superFast:
            return .slow
        }
    }

}
