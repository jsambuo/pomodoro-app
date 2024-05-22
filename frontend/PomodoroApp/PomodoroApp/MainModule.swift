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
            DummyView1()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            DummyView2()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            DummyView3()
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                }
            RouteView("/settings")
                .tabItem {
                    Label("Settings", systemImage: "person")
                }
        }
    }
}

struct DummyView1: View {
    var body: some View {
        Text("Home View")
    }
}

struct DummyView2: View {
    var body: some View {
        Text("Search View")
    }
}

struct DummyView3: View {
    var body: some View {
        Text("Notifications View")
    }
}

struct DummyView4: View {
    var body: some View {
        Text("Profile View")
    }
}
