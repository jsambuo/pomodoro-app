import Vapor

func routes(_ app: Application) throws {
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
    
    // WebSocket route
    app.webSocket("echo") { req, ws in
        print("WebSocket connected")
        ws.onText { ws, text in
            print("Received text: \(text)")
            ws.send(text)
        }
    }
}
