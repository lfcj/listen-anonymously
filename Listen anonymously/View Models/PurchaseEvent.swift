struct PurchaseEvent: Sendable, Equatable {
    enum Kind: Sendable, Equatable {
        case idle
        case purchasing
        case cancelled
        case success(DonationType)
        case failure(errorDescription: String)
        case finished
    }

    let kind: Kind
}
