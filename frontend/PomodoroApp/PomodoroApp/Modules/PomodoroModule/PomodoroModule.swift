//
//  PomodoroModule.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI
import ModuleKit
import ProjectI

struct PomodoroModule: Module {
    @Inject var webSocketService: WebSocketService
    var routes: [Route] {
        [
            Route(path: "/pomodoro") {
                PomodoroView(webSocketService: webSocketService)
            },
            Route(path: "/pomodoro-remote") {
                PomodoroRemoteView()
            }
        ]
    }

    var actions: [Action] {
        []
    }
}

struct PomodoroView: View {
    @StateObject var timerViewModel: TimerViewModel
    init(webSocketService: WebSocketService) {
        let pomodoroTimer = PomodoroTimer(webSocketService: webSocketService)
        _timerViewModel = StateObject(wrappedValue: TimerViewModel(timer: pomodoroTimer))
    }
    var body: some View {
        VStack {
            Text("Pomodoro Timer")
                .font(.largeTitle)
                .padding()

            // Add your Pomodoro timer UI components here
            TimerView(viewModel: timerViewModel)

            Spacer()
        }
        .padding()
    }
}

struct PomodoroRemoteView: View {
//    @Inject var webSocketService: WebSocketService
//    let authService: AuthService = CognitoAuthService(clientId: "[replaceme]")
//    @StateObject var timerViewModel: TimerViewModel
    var pomodoroController: PomodoroController = .init()
    init() {
//        let pomodoroTimer = PomodoroTimer(webSocketService: webSocketService)
//        _timerViewModel = StateObject(wrappedValue: TimerViewModel(timer: pomodoroTimer))
//        pomodoroController = .init(webSocketService: webSocketService)
    }
    var body: some View {
        VStack {
            Text("Pomodoro Remote")
                .font(.largeTitle)
                .padding()

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

            Spacer()
        }
        .padding()
    }
}

