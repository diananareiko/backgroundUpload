import Foundation

class DependencyInjectionContainer {

    static let shared = DependencyInjectionContainer()

    private var services: [String: Any] = [:]

    func register<T>(_ service: T) {
        services[String(describing: T.self)] = service
    }

    func resolve<T>(_ serviceType: T.Type) -> T? {
        services[String(describing: T.self)] as? T
    }
}
