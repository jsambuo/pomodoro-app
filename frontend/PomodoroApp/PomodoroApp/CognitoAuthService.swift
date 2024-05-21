//
//  CognitoAuthService.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import Foundation

class CognitoAuthService: AuthService {
    private let clientId: String
    private let region: String
    
    init(clientId: String, region: String = "us-east-1") {
        self.clientId = clientId
        self.region = region
    }
    
    func signup(email: String, password: String) async throws {
        let url = URL(string: "https://cognito-idp.\(region).amazonaws.com/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        request.setValue("AWSCognitoIdentityProviderService.SignUp", forHTTPHeaderField: "X-Amz-Target")
        
        let body: [String: Any] = [
            "ClientId": clientId,
            "Username": email,
            "Password": password,
            "UserAttributes": [
                ["Name": "email", "Value": email]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw parseCognitoError(data)
        }
    }
    
    func login(email: String, password: String) async throws -> String {
        let url = URL(string: "https://cognito-idp.\(region).amazonaws.com/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        request.setValue("AWSCognitoIdentityProviderService.InitiateAuth", forHTTPHeaderField: "X-Amz-Target")
        
        let body: [String: Any] = [
            "AuthFlow": "USER_PASSWORD_AUTH",
            "ClientId": clientId,
            "AuthParameters": [
                "USERNAME": email,
                "PASSWORD": password
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw parseCognitoError(data)
        }
        
        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        guard let authenticationResult = jsonResponse?["AuthenticationResult"] as? [String: Any],
              let idToken = authenticationResult["IdToken"] as? String else {
            throw AuthServiceError.unknownError
        }
        
        return idToken
    }
    
    func forgotPassword(email: String) async throws {
        let url = URL(string: "https://cognito-idp.\(region).amazonaws.com/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-amz-json-1.1", forHTTPHeaderField: "Content-Type")
        request.setValue("AWSCognitoIdentityProviderService.ForgotPassword", forHTTPHeaderField: "X-Amz-Target")
        
        let body: [String: Any] = [
            "ClientId": clientId,
            "Username": email
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw parseCognitoError(data)
        }
    }
    
    private func parseCognitoError(_ data: Data) -> AuthServiceError {
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let errorType = jsonResponse["__type"] as? String {
            switch errorType {
            case "NotAuthorizedException":
                return .invalidCredentials
            case "UserNotFoundException":
                return .userNotFound
            case "UsernameExistsException":
                return .userAlreadyExists
            default:
                return .unknownError
            }
        }
        return .unknownError
    }
}
