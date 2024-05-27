//
//  PomodoroRemoteView.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/22/24.
//

import SwiftUI

struct PomodoroRemoteView: View {
    var pomodoroController: PomodoroController = .init()
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
