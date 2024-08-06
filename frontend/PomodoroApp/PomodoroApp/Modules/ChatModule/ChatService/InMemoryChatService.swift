import Foundation
import Combine

class InMemoryChatService: ChatService {
	private var messages: [Message] = []
	private var chats: [Chat] = []  // Maintain a list of all chats
	private var currentUser = User(id: UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA269D")!, name: "James", email: "james@example.com", avatar: "https://randomuser.me/api/portraits/men/43.jpg")
	private lazy var users: [User] = [
		currentUser,
		User(id: UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA244C")!, name: "Alice", email: "alice@example.com", avatar: "https://randomuser.me/api/portraits/men/42.jpg"),
		User(id: UUID(uuidString: "30104AE5-947D-4CF9-A335-F4F51994A92D")!, name: "Bob", email: "bob@example.com", avatar: "https://randomuser.me/api/portraits/women/47.jpg")
	]

	private let messageReceivedSubject = PassthroughSubject<Message, Never>()
	private var timerCancellable: AnyCancellable?

	var messageReceivedPublisher: AnyPublisher<Message, Never> {
		messageReceivedSubject.eraseToAnyPublisher()
	}

	init() {
		setupInitialChats() // Set up some initial chats for demonstration
	}

	private func setupInitialChats() {
		// Create some initial chats between users with fixed UUIDs
		let chat1 = Chat(
			id: UUID(uuidString: "123E4567-E89B-12D3-A456-426614174000")!,
			participants: [currentUser, users[1]],
			latestMessage: nil
		)
		let chat2 = Chat(
			id: UUID(uuidString: "123E4567-E89B-12D3-A456-426614174001")!,
			participants: [currentUser, users[2]],
			latestMessage: nil
		)
		chats = [chat1, chat2]
	}

	func sendMessage(chatID: UUID, content: String, senderID: UUID) async throws {
		guard let chat = chats.first(where: { $0.id == chatID }) else {
			throw NSError(domain: "Chat not found", code: 0, userInfo: nil)
		}

		guard let sender = getUserInfo(userID: senderID) else {
			throw NSError(domain: "User not found", code: 0, userInfo: nil)
		}

		let message = Message(
			id: UUID(),
			content: content,
			senderID: senderID,
			chatID: chatID,
			senderName: sender.name,
			senderAvatar: sender.avatar,
			createdAt: Date()
		)

		messages.append(message)

		// Update the latest message in the chat
		if let index = chats.firstIndex(where: { $0.id == chatID }) {
			chats[index].latestMessage = message
		}

		// Send the message object directly
		messageReceivedSubject.send(message)

		// Check for start/stop commands
		if content.lowercased() == "start" {
			// Start auto-message assuming it sends to all other participants
			for participant in chat.participants where participant.id != senderID {
				startAutoMessage(senderID: participant.id, chatID: chatID)
			}
		} else if content.lowercased() == "stop" {
			stopAutoMessage()
		}
	}

	func getMessages(chatID: UUID) async throws -> [Message] {
		return messages.filter { $0.chatID == chatID }
	}

	func getUserChats(for userID: UUID) async throws -> [Chat] {
		// Return all chats that involve the specified user
		return chats.filter { $0.participants.contains(where: { $0.id == userID }) }
	}

	private func getUserInfo(userID: UUID) -> User? {
		return users.first { $0.id == userID }
	}

	private func startAutoMessage(senderID: UUID, chatID: UUID) {
		timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
			.autoconnect()
			.sink { [weak self] _ in
				guard let self = self else { return }
				Task {
					do {
						let content = self.generateRandomMessage()
						try await self.sendMessage(chatID: chatID, content: content, senderID: senderID)
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
