//
//  PomodoroTimer.swift
//  Pomodoro
//
//  Created by Jimmy Sambuo on 5/13/24.
//

import Combine
import Foundation

// Assuming WebSocketService is already conformed to by some class and connected
class PomodoroTimer {
    var cancellables: Set<AnyCancellable> = []

    // Reference to the WebSocket service
    var webSocketService: WebSocketService

    init(webSocketService: WebSocketService) {
        self.webSocketService = webSocketService
        setupSubscribers()
    }

    private func setupSubscribers() {
        webSocketService.messageReceivedPublisher
            .sink { [weak self] message in
                self?.handleMessage(message)
            }
            .store(in: &cancellables)
    }

    private func handleMessage(_ message: String) {
        switch message {
        case "start":
            startTimer()
        case "stop":
            stopTimer()
        case let message where message.starts(with: "setTime "):
            let timeComponents = message.components(separatedBy: " ")
            if timeComponents.count > 1, let time = Int(timeComponents[1]) {
                setTime(time)
            }
        default:
            print("Received unknown command")
        }
    }

    private func startTimer() {
        // Logic to start the timer
        print("Timer started")
    }

    private func stopTimer() {
        // Logic to stop the timer
        print("Timer stopped")
    }

    private func setTime(_ minutes: Int) {
        // Logic to set the timer duration
        print("Timer set to \(minutes) minutes")
    }
}
