//
//  LoginView.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI
/*
struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var loginError: String?
    @State private var isLoading: Bool = false
    @State private var token: String?
    
    let authService: AuthService
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
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
            
            if let loginError = loginError {
                Text(loginError)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: login) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            
            Spacer()
        }
        .padding()
    }
    
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            loginError = "Email and Password cannot be empty."
            return
        }
        
        isLoading = true
        loginError = nil
        
        Task {
            do {
                let token = try await authService.login(email: email, password: password)
                self.token = token
                print("Login successful. Token: \(token)")
                // Handle successful login (e.g., navigate to another view)
            } catch {
                loginError = "Login failed: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(authService: MockAuthService())
    }
    // Mock AuthService for preview purposes
    struct MockAuthService: AuthService {
        func signup(email: String, password: String) async throws {}
        func login(email: String, password: String) async throws -> String {
            return "mock_token"
        }
        func forgotPassword(email: String) async throws {}
    }
}*/
