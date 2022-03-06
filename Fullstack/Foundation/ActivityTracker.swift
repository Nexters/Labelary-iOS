
import Combine
import UIKit

public typealias ActivityTracker = CurrentValueSubject<Bool, Never>

public extension Publisher where Failure: Error {
    func trackActivity(_ activityTracker: ActivityTracker) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveSubscription: { _ in
            activityTracker.send(true)
        }, receiveCompletion: { _ in
            activityTracker.send(false)
        })
            .eraseToAnyPublisher()
    }
}
