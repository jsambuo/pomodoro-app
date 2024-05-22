//
//  WebSocketService.swift
//  Pomodoro
//
//  Created by Jimmy Sambuo on 5/13/24.
//

import Combine
protocol WebSocketService {
    // Publishers for the WebSocket events
    var connectPublisher: AnyPublisher<Void, Never> { get }
    var disconnectPublisher: AnyPublisher<Void, Never> { get }
    var messageReceivedPublisher: AnyPublisher<String, Never> { get }

    func disconnect()
    func send(message: String)
}
