//
//  MainApp.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI
import ModuleKit

@main
struct MainApp: App {
    @StateObject private var appState = AppState()
    private let moduleManager = ModuleManager(modules: [
        LoginModule(),
        MainModule(),
        SettingsModule(),
        SignUpModule(),
    ])

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RouteView(appState.state == .loggedIn ? "/" : "/login")
            }
            .environmentObject(moduleManager)
            .environmentObject(appState)
        }
    }
}
