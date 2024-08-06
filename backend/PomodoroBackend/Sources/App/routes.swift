import Vapor
import JWT
import AWSDynamoDB

func routes(_ app: Application) async throws {
    let dynamoDB = try await DynamoDBClient()
    let todoController = TodoController(dynamoDB: dynamoDB)
    try app.register(collection: todoController)
    try app.register(collection: FriendsController(dynamoDB: dynamoDB))
    let chatController = ChatController()
    try app.register(collection: chatController)
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    struct User: Content {
        var id: Int
        var name: String
        var email: String
    }
    
    app.get("user") { req -> User in
        // Create a user instance
        let user = User(id: 1,
                        name: "John Doe",
                        email: "john@example.com")
        return user
    }
    
    let protectedRoutes = app.grouped(AuthTokenPayload.authenticator())
                            .grouped(AuthTokenPayload.guardMiddleware())
    protectedRoutes.get("protected") { req -> String in
        // This route is now protected and only accessible to authenticated users
        let authToken = try req.auth.require(AuthTokenPayload.self)
        return "You have accessed a protected route. Welcome \(authToken)!"
    }
    
    // WebSocket route
    app.webSocket("echo") { req, ws in
        print("WebSocket connected")
        ws.onText { ws, text in
            print("Received text: \(text)")
            ws.send(text)
        }
    }
}
