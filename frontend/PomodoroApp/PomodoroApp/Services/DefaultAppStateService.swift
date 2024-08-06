import Foundation
import Combine

class DefaultAppStateService: ObservableObject, AppStateService {
    @Published var appState: AppState = .loggedOut
    
    var appStatePublisher: AnyPublisher<AppState, Never> {
        return $appState.eraseToAnyPublisher()
    }
    
    var currentState: AppState {
        get {
            return appState
        }
        set {
            DispatchQueue.main.async {
                self.appState = newValue
            }
        }
    }
}
