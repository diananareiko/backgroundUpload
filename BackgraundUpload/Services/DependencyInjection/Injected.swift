import SwiftUI

@propertyWrapper
struct Injected<T> {
    private let serviceType: T.Type
    private let container: DependencyInjectionContainer

    init(_ serviceType: T.Type = T.self) {
        self.serviceType = serviceType
        self.container = .shared
    }

    var wrappedValue: T? {
        get { container.resolve(serviceType) }
        set { container.register(newValue) }
    }
}
