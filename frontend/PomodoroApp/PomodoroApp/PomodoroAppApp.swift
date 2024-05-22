//
//  PomodoroAppApp.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/15/24.
//

import SwiftUI
import ModuleKit

@main
struct PomodoroAppApp: App {
    @StateObject private var appState = AppState()
    private let moduleManager = ModuleManager(modules: [
        LoginModule(),
        MainModule(),
        SettingsModule(),
    ])

    var body: some Scene {
        WindowGroup {
            RouteView(appState.state == .loggedIn ? "/" : "/login")
                .environmentObject(moduleManager)
                .environmentObject(appState)
        }
    }
}
