
import Combine

public extension Publisher {
    func sink() -> AnyCancellable {
        return self.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}
