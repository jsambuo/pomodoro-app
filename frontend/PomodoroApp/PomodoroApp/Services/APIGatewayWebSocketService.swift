//
//  APIGatewayWebSocketService.swift
//  Pomodoro
//
//  Created by Jimmy Sambuo on 5/13/24.
//

import Foundation
import Combine

class APIGatewayWebSocketService: WebSocketService {
    private var url: URL
    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables: Set<AnyCancellable> = []
    
    // Publishers for the WebSocket events
    var connectPublisher: AnyPublisher<Void, Never> {
        connectSubject.eraseToAnyPublisher()
    }
    private let connectSubject = PassthroughSubject<Void, Never>()
    
    var disconnectPublisher: AnyPublisher<Void, Never> {
        disconnectSubject.eraseToAnyPublisher()
    }
    private let disconnectSubject = PassthroughSubject<Void, Never>()
    
    var messageReceivedPublisher: AnyPublisher<String, Never> {
        messageReceivedSubject.eraseToAnyPublisher()
    }
    private let messageReceivedSubject = PassthroughSubject<String, Never>()
    
    init(url: URL) {
        self.url = url
        self.connect() // Consider removing this.
    }
    
    func connect() {
        disconnect()
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        connectSubject.send(())
        listenToMessages()
    }
    
    func disconnect() {
        webSocketTask?.cancel()
        disconnectSubject.send(())
        webSocketTask = nil
    }
    
    func send(message: String) {
        let messageToSend = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(messageToSend) { error in
            if let error = error {
                print("Error sending message: \(error)")
            }
        }
    }
    
    private func listenToMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("Error in receiving message: \(error)")
                self?.disconnect()
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.messageReceivedSubject.send(text)
                default:
                    print("Received a non-string message")
                }
                self?.listenToMessages() // Recursive call to continue listening
            }
        }
    }
}

