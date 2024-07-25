import Vapor
import JWTKit

extension JWTKeyCollection {
    
    /// Adds JSON Web Key Set (JWKS) from a given URL to the `JWTKeyCollection`.
    ///
    /// This method fetches the JWKS from the specified URL and adds it to the current
    /// key collection. It uses the `HTTPClient` to perform the HTTP GET request and
    /// processes the response to extract the JWKS.
    ///
    /// - Parameter url: The `URI` of the endpoint from which to fetch the JWKS.
    /// - Throws: An error if the HTTP request fails, the response status is not `200 OK`,
    ///           or if there is an issue with parsing or using the fetched JWKS.
    func addFromURL(_ url: URI) throws {
        // Create an HTTP client for the event loop group.
        let client = HTTPClient(eventLoopGroupProvider: .singleton)
        
        // Ensure the client is shut down when done.
        defer { try? client.syncShutdown() }
        
        // Perform an HTTP GET request to fetch the JWKS.
        let response = try client.get(url: url.string).wait()
        
        // Check the response status and body.
        guard response.status == .ok, let body = response.body else {
            throw Abort(.internalServerError, reason: "Failed to fetch JWKS")
        }
        
        // Convert the response body to a string.
        let jwks = String(buffer: body)
        
        // Add the JWKS to the key collection.
        try self.use(jwksJSON: jwks)
    }
}


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Fetch JWKS from AWS Cognito
//    try await app.jwt.keys.addFromURL(.init(string: "[replaceme]"))

    // register routes
    try await routes(app)
}
