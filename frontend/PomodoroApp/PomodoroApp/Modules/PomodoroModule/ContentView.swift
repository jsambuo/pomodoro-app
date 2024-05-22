//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/15/24.
//

import SwiftUI

struct ContentView: View {
    let webSocketService: WebSocketService = APIGatewayWebSocketService(url: URL(string: "ws://localhost:8080/echo")!)
    let authService: AuthService = CognitoAuthService(clientId: "[replaceme]")
    @StateObject var timerViewModel: TimerViewModel
    var pomodoroController: PomodoroController
    init() {
        let pomodoroTimer = PomodoroTimer(webSocketService: webSocketService)
        _timerViewModel = StateObject(wrappedValue: TimerViewModel(timer: pomodoroTimer))
        pomodoroController = .init(webSocketService: webSocketService)
    }
    var body: some View {
//        LoginView(authService: authService)
//        LoginView()
//        SignUpView(authService: authService)
        VStack {
            Button("Start Timer") {
                pomodoroController.startTimer()
            }

            Button("Stop Timer") {
                pomodoroController.stopTimer()
            }

            Button("Focus Time (25 min)") {
                pomodoroController.setTime(minutes: 25)
            }

            Button("Short Break (5 min)") {
                pomodoroController.setTime(minutes: 5)
            }

            Button("Long Break (15 min)") {
                pomodoroController.setTime(minutes: 15)
            }
        }
        TimerView(viewModel: timerViewModel)
    }
}

#Preview {
    ContentView()
}

