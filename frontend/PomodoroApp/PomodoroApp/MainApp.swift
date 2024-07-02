//
//  MainApp.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI
import ModuleKit
import ProjectI

@main
struct MainApp: App {
    @StateObject private var appState = AppState()
    private let moduleManager = ModuleManager()
    
    init() {
        do {
            try DIContainer.shared.register(AuthService.self, service: CognitoAuthService(clientId: "[replaceme]"))
            try DIContainer.shared.register(WebSocketService.self, service: APIGatewayWebSocketService(url: URL(string: "ws://localhost:8080/echo")!))
            try DIContainer.shared.register(TodoService.self, service: InMemoryTodoService())
            try DIContainer.shared.register(FriendsService.self, service: InMemoryFriendsService())
        } catch {
            assertionFailure("Error registering depedency: \(error)")
        }
        
        moduleManager.registerModules([
            LoginModule(),
            MainModule(),
            SettingsModule(),
            SignUpModule(),
            PomodoroModule(),
            TodoModule(),
            FriendsListModule(),
        ])
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RouteView(appState.state.path)
            }
            .environmentObject(moduleManager)
            .environmentObject(appState)
        }
    }
}

private extension AppState.State {
    var path: String {
        switch self {
        case .loggedIn:
            return "/"
        case .loggedOut:
            return "/login"
        }
    }
}
