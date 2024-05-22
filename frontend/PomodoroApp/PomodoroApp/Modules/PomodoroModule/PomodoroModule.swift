//
//  PomodoroModule.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI
import ModuleKit

struct PomodoroModule: Module {
    var routes: [Route] {
        [
            Route(path: "/pomodoro") {
                PomodoroView()
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
    var body: some View {
        VStack {
            Text("Pomodoro Timer")
                .font(.largeTitle)
                .padding()

            // Add your Pomodoro timer UI components here

            Spacer()
        }
        .padding()
    }
}

struct PomodoroRemoteView: View {
    var body: some View {
        VStack {
            Text("Pomodoro Remote")
                .font(.largeTitle)
                .padding()

            // Add your Pomodoro remote UI components here

            Spacer()
        }
        .padding()
    }
}

