//
//  AuthService.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 5/21/24.
//

import Foundation

/// An enumeration of possible errors that the AuthService can encounter.
enum AuthServiceError: Error {
    case networkError
    case invalidCredentials
    case userAlreadyExists
    case userNotFound
    case unknownError
}

/// A protocol for authentication services supporting OAuth2.0.
protocol AuthService {
    
    /// Signs up a new user with the given email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    /// - Throws: An `AuthServiceError` if the signup fails.
    func signup(email: String, password: String) async throws
    
    /// Logs in a user with the given email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    /// - Returns: A token string on successful login.
    /// - Throws: An `AuthServiceError` if the login fails.
    func login(email: String, password: String) async throws -> String
    
    /// Initiates the password reset process for the given email.
    ///
    /// - Parameter email: The email address of the user.
    /// - Throws: An `AuthServiceError` if the password reset request fails.
    func forgotPassword(email: String) async throws
}
