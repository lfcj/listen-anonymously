import Foundation

public protocol Injectable {}

@propertyWrapper
public struct Inject<T: Injectable> {
    public let wrappedValue: T

    public init() {
        self.wrappedValue = InjectionResolver.shared.resolve()
    }
}

public class InjectionResolver {

    public static let shared = InjectionResolver()

    private var storage: [String: Injectable] = [:]

    public func add<T: Injectable>(_ injectable: T, for classOrProtocol: T.Type) {
        let key: String = String(reflecting: classOrProtocol)

        storage[key] = injectable
    }

    public func resolve<T: Injectable>() -> T {
        let key = String(reflecting: T.self)

        guard let injectable = storage[key] as? T else {
            fatalError("\(key) has not been added as an injectable object.")
        }

        return injectable
    }

}
