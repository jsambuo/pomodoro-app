//
//  TimerView.swift
//  Pomodoro
//
//  Created by Jimmy Sambuo on 5/13/24.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.lastEvent)
                .padding()
                .font(.title)
            
            Text(viewModel.remainingTime)
                .padding()
                .font(.largeTitle)
            
            Button("Start Timer") {
                viewModel.timer.webSocketService.send(message: "start")
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Stop Timer") {
                viewModel.timer.webSocketService.send(message: "stop")
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Set Time to 25 min") {
                viewModel.timer.webSocketService.send(message: "setTime 25")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Set Time to 5 min") {
                viewModel.timer.webSocketService.send(message: "setTime 5")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Button("Set Time to 15 min") {
                viewModel.timer.webSocketService.send(message: "setTime 15")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

