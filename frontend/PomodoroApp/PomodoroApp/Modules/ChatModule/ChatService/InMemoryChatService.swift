import Foundation
import Combine

class InMemoryChatService: ChatService {
	private var messages: [Message] = []
	private var currentUser = User(id: UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA269D")!, name: "Jame", email: "Jame@example.com", avatar: "https://randomuser.me/api/portraits/men/43.jpg")
	private lazy var users: [User] = [
		currentUser,
		User(id: UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA244C")!, name: "Alice", email: "alice@example.com", avatar: "https://randomuser.me/api/portraits/men/42.jpg"),
		User(id: UUID(uuidString: "30104AE5-947D-4CF9-A335-F4F51994A92D")!, name: "Bob", email: "bob@example.com", avatar: "https://randomuser.me/api/portraits/women/47.jpg")
	]
	
	private let messageReceivedSubject = PassthroughSubject<String, Never>()
	private var timerCancellable: AnyCancellable?
	
	var messageReceivedPublisher: AnyPublisher<String, Never> {
		messageReceivedSubject.eraseToAnyPublisher()
	}
	
	func sendMessage(content: String, senderID: UUID, receiverID: UUID) async throws {
		guard let sender = getUserInfo(userID: senderID),
			  let receiver = getUserInfo(userID: receiverID) else {
			throw NSError(domain: "User not found", code: 0, userInfo: nil)
		}

		let message = Message(
			id: UUID(),
			content: content,
			senderID: senderID,
			receiverID: receiverID,
			senderName: sender.name,
			senderAvatar: sender.avatar,
			receiverName: receiver.name,
			receiverAvatar: receiver.avatar,
			createdAt: Date()
		)
		
		messages.append(message)
		
		// Simulate message received event
		let messageString = try JSONEncoder().encode(message)
		let messageStringFormatted = String(data: messageString, encoding: .utf8) ?? ""
		messageReceivedSubject.send(messageStringFormatted)
		
		// Check for start/stop commands
		if content.lowercased() == "start" {
			startAutoMessage(senderID: receiverID, receiverID: senderID) // Swap sender and receiver for auto messages
		} else if content.lowercased() == "stop" {
			stopAutoMessage()
		}
	}
	
	func fetchChatHistory(senderID: UUID, receiverID: UUID) async throws -> [Message] {
		return messages.filter {
			($0.senderID == senderID && $0.receiverID == receiverID) ||
			($0.senderID == receiverID && $0.receiverID == senderID)
		}
	}
	
	func fetchUsers() async throws -> [User] {
		return users.filter { $0.id != currentUser.id }
	}
	
	private func getUserInfo(userID: UUID) -> User? {
		return users.first { $0.id == userID }
	}
	
	private func startAutoMessage(senderID: UUID, receiverID: UUID) {
		timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
			.autoconnect()
			.sink { [weak self] _ in
				guard let self = self else { return }
				Task {
					do {
						let content = self.generateRandomMessage()
						try await self.sendMessage(content: content, senderID: senderID, receiverID: receiverID)
					} catch {
						print("Failed to send automated message: \(error)")
					}
				}
			}
	}
	
	private func stopAutoMessage() {
		timerCancellable?.cancel()
		timerCancellable = nil
	}

	private func generateRandomMessage() -> String {
		let messages = [
			"Hello!",
			"How are you?",
			"What's up?",
			"This is a random message.",
			"Hope you're having a great day!",
			"Let's chat!"
		]
		return messages.randomElement() ?? "Hello!"
	}
}
