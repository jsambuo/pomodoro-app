//
//  SettingsModule.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import ModuleKit
import SwiftUI
import ProjectI

struct SettingsModule: Module {
    var routes: [Route] {
        [
            Route(path: "/settings") {
                SettingsView()
            }
        ]
    }

    var actions: [Action] {
        []
    }
}

struct SettingsView: View {
    @Inject private var appStateService: AppStateService

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
                appStateService.currentState = .loggedOut
            }) {
                Text("Log Out")
                    .foregroundColor(.red)
            }
            .padding()
        }
        .padding()
    }
}

