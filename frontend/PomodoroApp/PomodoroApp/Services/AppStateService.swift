import Foundation
import Combine

protocol AppStateService: AnyObject {
    var appStatePublisher: AnyPublisher<AppState, Never> { get }
    var currentState: AppState { get set }
}

enum AppState {
    case loggedIn(authToken: String)
    case loggedOut
}
