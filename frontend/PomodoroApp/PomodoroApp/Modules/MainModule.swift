//
//  MainModule.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI
import ModuleKit

struct MainModule: Module {
    var routes: [Route] {
        [
            Route(path: "/") {
                MainView()
            }
        ]
    }

    var actions: [Action] {
        []
    }
}

struct MainView: View {
    var body: some View {
        TabView {
            Text("Home View")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            RouteView("/pomodoro")
                .tabItem {
                    Label("Pomodoro", systemImage: "timer")
                }
            RouteView("/pomodoro-remote")
                .tabItem {
                    Label("Remote", systemImage: "iphone")
                }
            RouteView("/settings")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(ModuleManager())
}
