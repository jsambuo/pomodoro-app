//
//  TimerViewModel.swift
//  Pomodoro
//
//  Created by Jimmy Sambuo on 5/13/24.
//

import Combine
import SwiftUI

class TimerViewModel: ObservableObject {
    @Published var lastEvent: String = "No events yet"
    @Published var remainingTime: String = "00:00"
    
    var timer: PomodoroTimer
    private var cancellables: Set<AnyCancellable> = []
    private var countdownCancellable: AnyCancellable?
    private var totalTime: Int = 0
    private var currentTime: Int = 0
    
    init(timer: PomodoroTimer) {
        self.timer = timer
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        timer.webSocketService.messageReceivedPublisher
            .sink { [weak self] message in
                self?.handleMessage(message)
            }
            .store(in: &cancellables)
    }
    
    private func handleMessage(_ message: String) {
        DispatchQueue.main.async {
            self.lastEvent = message
            switch message {
            case "start":
                self.startCountdown()
            case "stop":
                self.stopCountdown()
            case let message where message.starts(with: "setTime "):
                let timeComponents = message.components(separatedBy: " ")
                if timeComponents.count > 1, let time = Int(timeComponents[1]) {
                    self.setTime(time)
                }
            default:
                break
            }
        }
    }
    
    private func startCountdown() {
        countdownCancellable?.cancel()
        currentTime = totalTime
        countdownCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateCountdown()
            }
    }
    
    private func stopCountdown() {
        countdownCancellable?.cancel()
        remainingTime = "00:00"
    }
    
    private func setTime(_ minutes: Int) {
        totalTime = minutes * 60
        currentTime = totalTime
        updateRemainingTime()
    }
    
    private func updateCountdown() {
        if currentTime > 0 {
            currentTime -= 1
            updateRemainingTime()
        } else {
            stopCountdown()
        }
    }
    
    private func updateRemainingTime() {
        let minutes = currentTime / 60
        let seconds = currentTime % 60
        remainingTime = String(format: "%02d:%02d", minutes, seconds)
    }
}
