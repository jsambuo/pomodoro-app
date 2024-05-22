//
//  SettingsModule.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import ModuleKit
import SwiftUI

struct SettingsModule: Module {
    var routes: [Route] {
        [
            Route(path: "/settings") { _ in
                SettingsView()
            }
        ]
    }

    var actions: [Action] {
        []
    }
}

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .padding()

            // Add your settings UI components here
            Text("Settings option 1")
            Text("Settings option 2")
            Text("Settings option 3")
            
            Spacer()
            
            Button(action: {
                // Perform logout action
                appState.state = .loggedOut
            }) {
                Text("Log Out")
                    .foregroundColor(.red)
            }
            .padding()
        }
        .padding()
    }
}

