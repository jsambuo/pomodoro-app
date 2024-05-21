//
//  SignupView.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var signUpError: String?
    @State private var isLoading: Bool = false
    @State private var token: String?
    
    let authService: AuthService
    
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
            } catch {
                signUpError = "Sign up failed: \(error.localizedDescription)"
            }
            isLoading = false
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(authService: MockAuthService())
    }
    // Mock AuthService for preview purposes
    struct MockAuthService: AuthService {
        func signup(email: String, password: String) async throws {}
        func login(email: String, password: String) async throws -> String {
            return "mock_token"
        }
        func forgotPassword(email: String) async throws {}
    }

}
