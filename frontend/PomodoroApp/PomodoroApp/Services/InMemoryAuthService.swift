import Foundation

/// A simple in-memory authentication service.
class InMemoryAuthService: AuthService {
    
    /// A structure to hold user information.
    private struct User {
        let email: String
        let password: String
    }
    
    /// A dictionary to store users, with email as the key.
    private var users: [String: User] = [
        "admin": .init(email: "admin", password: "password"),
    ]
    
    /// Signs up a new user with the given email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    /// - Throws: An `AuthServiceError` if the signup fails.
    func signup(email: String, password: String) async throws {
        guard users[email] == nil else {
            throw AuthServiceError.userAlreadyExists
        }
        users[email] = User(email: email, password: password)
    }
    
    /// Logs in a user with the given email and password.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The password of the user.
    /// - Returns: A token string on successful login.
    /// - Throws: An `AuthServiceError` if the login fails.
    func login(email: String, password: String) async throws -> String {
        guard let user = users[email], user.password == password else {
            throw AuthServiceError.invalidCredentials
        }
        // Return a dummy token for simplicity.
        return "dummy-token"
    }
    
    /// Initiates the password reset process for the given email.
    ///
    /// - Parameter email: The email address of the user.
    /// - Throws: An `AuthServiceError` if the password reset request fails.
    func forgotPassword(email: String) async throws {
        guard users[email] != nil else {
            throw AuthServiceError.userNotFound
        }
        // Here, you would typically send a password reset email or similar action.
        // For simplicity, we do nothing.
    }
}
