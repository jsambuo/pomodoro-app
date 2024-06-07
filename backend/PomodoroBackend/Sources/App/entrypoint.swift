import Vapor
import Logging
import VaporAWSLambdaRuntime

@main
enum Entrypoint {
    static func main() async throws {
        var env = try Environment.detect()
        try LoggingSystem.bootstrap(from: &env)
        
        let app = Application(env)
        defer { app.shutdown() }
        
        do {
            try await configure(app)
        } catch {
            app.logger.report(error: error)
            throw error
        }

        if let _ = Environment.get("LAMBDA_ENABLED") {
            app.servers.use(.lambda)
        }

        try await app.execute()
    }
}
