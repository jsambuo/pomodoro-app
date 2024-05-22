//
//  AppState.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var state: State = .loggedOut

    enum State {
        case loggedIn
        case loggedOut
    }
}
