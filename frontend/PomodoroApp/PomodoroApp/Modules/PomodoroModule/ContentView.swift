//
//  ContentView.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/15/24.
//

import SwiftUI

struct ContentView: View {
  
    let pomodoroController: PomodoroController = .init()
    
    var body: some View {
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
    }
}

#Preview {
    ContentView()
}

