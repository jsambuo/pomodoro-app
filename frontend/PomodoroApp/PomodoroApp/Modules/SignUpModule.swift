//
//  SignUpModule.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI
import ModuleKit

struct SignUpModule: Module {
    var routes: [Route] {
        [
            Route(path: "/signup") {
                SignUpView()
            }
        ]
    }

    var actions: [Action] {
        []
    }
}

struct SignUpView: View {
    @EnvironmentObject var appState: AppState

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Simulate sign up action
                appState.state = .loggedIn
            }) {
                Text("Sign Up")
            }
            .padding()

            Spacer()

            NavigationLink(destination: RouteView("/login")) {
                Text("Already have an account? Log In")
                    .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
    }
}
