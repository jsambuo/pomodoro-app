//
//  PomodoroView.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/22/24.
//

import SwiftUI

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
