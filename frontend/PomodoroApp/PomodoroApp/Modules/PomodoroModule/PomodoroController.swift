//
//  PomodoroController.swift
//  Pomodoro
//
//  Created by Jimmy Sambuo on 5/13/24.
//

import Foundation
import ProjectI

class PomodoroController {
    @Inject private var webSocketService: WebSocketService

    func startTimer() {
        webSocketService.send(message: "start")
        print("Sent 'start' command to the timer.")
    }

    func stopTimer() {
        webSocketService.send(message: "stop")
        print("Sent 'stop' command to the timer.")
    }

    func setTime(minutes: Int) {
        webSocketService.send(message: "setTime \(minutes)")
        print("Sent 'setTime \(minutes)' command to the timer.")
    }
}

