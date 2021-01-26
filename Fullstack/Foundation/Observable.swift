
import Combine

public typealias Observable<T> = AnyPublisher<T, Error>

extension Publisher {
    public func asObservable() -> Observable<Output> {
        self.mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    public static func just(_ output: Output) -> Observable<Output> {
        Just(output)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    public static func empty() -> Observable<Output> {
        return Empty().eraseToAnyPublisher()
    }
}
