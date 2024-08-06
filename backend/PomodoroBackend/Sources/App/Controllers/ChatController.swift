import Vapor

final class WebSocketManager {
    static let shared = WebSocketManager()
    private init() { }

    private var clients: [WebSocket] = []

    func addClient(_ client: WebSocket) {
        clients.append(client)
    }

    func removeClient(_ client: WebSocket) {
        clients.removeAll { $0 === client }
    }

    func broadcast(message: String) {
        clients.forEach { $0.send(message) }
    }
}

struct ChatController: RouteCollection {
	func boot(routes: RoutesBuilder) throws {
		let chatRoutes = routes.grouped("api", "chat")
		chatRoutes.webSocket("connect", onUpgrade: handleWebSocket)
		chatRoutes.post("send", use: sendMessage)
		chatRoutes.get("history", use: getMessageHistory)
	}

	// WebSocket handler for receiving messages
	func handleWebSocket(req: Request, ws: WebSocket) {
		WebSocketManager.shared.addClient(ws)

		ws.onText { ws, text in
			// Handle incoming text messages
			print("Received message: \(text)")
			// Broadcast the message to all connected clients
			WebSocketManager.shared.broadcast(message: text)
		}

		ws.onClose.whenComplete { result in
			WebSocketManager.shared.removeClient(ws)
			print("WebSocket connection closed")
		}
	}

	// HTTP endpoint for sending messages
	func sendMessage(req: Request) async throws -> HTTPStatus {
		let messageDTO = try req.content.decode(CreateMessageDTO.self)
		let senderInfo = Storage.shared.getUserInfo(userID: messageDTO.senderID)
		let receiverInfo = Storage.shared.getUserInfo(userID: messageDTO.receiverID)
		
		let message = Message(
			id: UUID(),
			content: messageDTO.content,
			senderID: messageDTO.senderID,
			receiverID: messageDTO.receiverID,
			senderName: senderInfo?.name ?? "Unknown",
			senderAvatar: senderInfo?.avatar ?? "defaultAvatar.png",
			receiverName: receiverInfo?.name ?? "Unknown",
			receiverAvatar: receiverInfo?.avatar ?? "defaultAvatar.png",
			createdAt: Date()
		)
		Storage.shared.messages.append(message)

		// Broadcast the message to WebSocket clients
		let messageString = try JSONEncoder().encode(message)
		let messageStringFormatted = String(data: messageString, encoding: .utf8) ?? ""
		WebSocketManager.shared.broadcast(message: messageStringFormatted)
		return .ok
	}

	// HTTP endpoint for retrieving message history
	func getMessageHistory(req: Request) async throws -> [Message] {
		guard let senderID = req.query[UUID.self, at: "sender_id"],
			  let receiverID = req.query[UUID.self, at: "receiver_id"] else {
			throw Abort(.badRequest)
		}

		return Storage.shared.messages.filter {
			($0.senderID == senderID && $0.receiverID == receiverID) ||
			($0.senderID == receiverID && $0.receiverID == senderID)
		}
	}
}

struct CreateMessageDTO: Content {
	let content: String
	let senderID: UUID
	let receiverID: UUID
}
