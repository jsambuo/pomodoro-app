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
