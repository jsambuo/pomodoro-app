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
    @StateObject private var appStateService: DefaultAppStateService
    private let moduleManager = ModuleManager()
    
    init() {
        do {
            let defaultAppStateService = DefaultAppStateService()
            self._appStateService = StateObject(wrappedValue: defaultAppStateService)
            try DIContainer.shared.register(AppStateService.self, service: defaultAppStateService)
            try DIContainer.shared.register(AuthService.self, service: InMemoryAuthService())
            try DIContainer.shared.register(WebSocketService.self, service: APIGatewayWebSocketService(url: URL(string: "ws://localhost:8080/echo")!))
            try DIContainer.shared.register(TodoService.self, service: InMemoryTodoService())
            try DIContainer.shared.register(FriendsService.self, service: InMemoryFriendsService())
//            try DIContainer.shared.register(ChatService.self, service: APIChatService(baseURL: URL(string: "http://127.0.0.1:8080/")!))
			try DIContainer.shared.register(ChatService.self, service: InMemoryChatService())
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
            ChatModule(),
        ])
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RouteView(appStateService.appState.path)
            }
            .environmentObject(moduleManager)
        }
    }
}

private extension AppState {
    var path: String {
        switch self {
        case .loggedIn:
            return "/"
        case .loggedOut:
            return "/login"
        }
    }
}
