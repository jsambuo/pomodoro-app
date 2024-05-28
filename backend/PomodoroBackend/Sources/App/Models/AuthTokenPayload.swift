import Vapor
import JWT

/// JWT payload structure for authentication tokens.
struct AuthTokenPayload: Content, Authenticatable, JWTPayload {
    
    /// Maps the longer Swift property names to the
    /// shortened keys used in the JWT payload.
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case audience = "aud"
        case jwtId = "jti"
        case issuer = "iss"
        case issuedAt = "iat"
        case email = "email"
        case notBefore = "nbf"
    }

    /// The "sub" (subject) claim identifies the principal that is the
    /// subject of the JWT.
    var subject: SubjectClaim

    /// The "exp" (expiration time) claim identifies the expiration time on
    /// or after which the JWT MUST NOT be accepted for processing.
    var expiration: ExpirationClaim
    
    /// The "aud" (audience) claim identifies the recipients that the JWT is intended for.
    var audience: AudienceClaim
    
    /// The "jti" (JWT ID) claim provides a unique identifier for the JWT.
    var jwtId: IDClaim
    
    /// The "iss" (issuer) claim identifies the principal that issued the JWT.
    var issuer: IssuerClaim
    
    /// The "iat" (issued at) claim identifies the time at which the JWT was issued.
    var issuedAt: IssuedAtClaim
    
    /// The "nbf" (not before) claim identifies the time before which the JWT MUST NOT be accepted for processing.
    var notBefore: NotBeforeClaim?
    
    /// The email address of the authenticated user.
    var email: String

    /// Verifies the JWT payload.
    /// - Parameter algorithm: The algorithm used for signature verification.
    /// - Throws: An error if the verification fails.
    /// - Note: This method runs any additional verification logic beyond
    ///         signature verification.
    func verify(using algorithm: some JWTAlgorithm) async throws {
        // Check if the token is expired
        try self.expiration.verifyNotExpired()

        // Check the audience claim
        try self.audience.verifyIntendedAudience(includes: "[replaceme]")

        // Check the not before claim if it exists
        if let notBefore = self.notBefore {
            try notBefore.verifyNotBefore()
        }
    }
}
