//
//  SignUpModule.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI
import ModuleKit
import ProjectI

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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var signUpError: String?
    @State private var isLoading: Bool = false
    @State private var token: String?
    
    @Inject var authService: AuthService
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
//                .textInputAutocapitalization(.never)
//                .keyboardType(.emailAddress)
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            if let signUpError = signUpError {
                Text(signUpError)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: signUp) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            
            Button(action: { dismiss() }, label: {Text("Go back")})
            
            NavigationLink(destination: RouteView("/login")) {
                Text("Already have an account? Log In")
                    .foregroundColor(.blue)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }

    func signUp() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            signUpError = "All fields are required."
            return
        }
        
        guard password == confirmPassword else {
            signUpError = "Passwords do not match."
            return
        }
        
        isLoading = true
        signUpError = nil
        
        Task {
            do {
                try await authService.signup(email: email, password: password)
                print("Sign up successful.")
                // Handle successful sign-up (e.g., navigate to login view)
                // Simulate sign up action
                appState.state = .loggedIn(authToken: "")
            } catch {
                signUpError = "Sign up failed: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}

#Preview {
    var signUpView = SignUpView()
    signUpView.authService = MockAuthService()
    return signUpView

    // Mock AuthService for preview purposes
    struct MockAuthService: AuthService {
        func signup(email: String, password: String) async throws {}
        func login(email: String, password: String) async throws -> String {
            return "mock_token"
        }
        func forgotPassword(email: String) async throws {}
    }
}
