enum PlayingRate: Float, CaseIterable {
    case slow = 0.75
    case normal = 1.0
    case fast = 1.5
    case superFast = 2.0

    var prev: PlayingRate {
        switch self {
        case .slow:
            return .superFast
        case .normal:
            return .slow
        case .fast:
            return .normal
        case .superFast:
            return .fast
        }
    }

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

    var string: String {
        switch self {
        case .slow:
            return "0.75x"
        case .normal:
            return "1x"
        case .fast:
            return "1.5x"
        case .superFast:
            return "2x"
        }
    }

}
