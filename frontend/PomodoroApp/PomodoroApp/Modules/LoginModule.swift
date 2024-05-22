//
//  LoginModule.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI
import ModuleKit

struct LoginModule: Module {
    var routes: [Route] {
        [
            Route(path: "/login") {
                LoginView()
            }
        ]
    }

    var actions: [Action] {
        []
    }
}

struct LoginView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        VStack {
            Text("Login View")
                .font(.largeTitle)
                .padding()

            // Add your login UI components here
            Button(action: {
                // Simulate login action
                appState.state = .loggedIn
            }) {
                Text("Log In")
            }
            .padding()
            
            Spacer()

            // Link to SignUpView using NavigationLink
            NavigationLink(destination: RouteView("/signup")) {
                Text("Don't have an account? Sign Up")
                    .foregroundColor(.blue)
            }
            .padding()
        }
    }
}
