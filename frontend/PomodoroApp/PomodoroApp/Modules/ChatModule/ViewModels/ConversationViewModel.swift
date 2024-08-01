import Foundation
import Combine
import ProjectI // Import ProjectI for DIContainer and @Inject

@MainActor
class ConversationViewModel: ObservableObject {
	@Published var messageText: String = ""
	@Published var receivedMessages: [Message] = []
	@Published var receiverName: String = ""
	@Published var receiverAvatar: String = ""

	private var cancellables = Set<AnyCancellable>()
	@Inject private var chatService: ChatService

	let userId: UUID
	let receiverId: UUID

	init(userId: UUID, receiverId: UUID) {
		self.userId = userId
		self.receiverId = receiverId

		subscribeToChatService()
		loadChatHistory()
		loadReceiverInfo()
	}

	private func subscribeToChatService() {
		chatService.messageReceivedPublisher
			.receive(on: DispatchQueue.main) // Ensure messages are received on the main thread
			.sink { [weak self] message in
				guard let self = self else { return }
				// Assuming message is received as JSON string, convert to Message object
				if let data = message.data(using: .utf8), let receivedMessage = try? JSONDecoder().decode(Message.self, from: data) {
					self.receivedMessages.append(receivedMessage)
				}
			}
			.store(in: &cancellables)
	}

	private func loadChatHistory() {
		Task {
			do {
				let messages = try await chatService.fetchChatHistory(senderID: userId, receiverID: receiverId)
				self.receivedMessages = messages
			} catch {
				print("Failed to load chat history: \(error)")
			}
		}
	}

	private func loadReceiverInfo() {
		// Load receiver information from some data source, e.g., a user service
		// This is a placeholder implementation
		Task {
			// Fetch receiver's info from a service or database
			if let receiver = getUserInfo(userID: receiverId) {
				self.receiverName = receiver.name
				self.receiverAvatar = receiver.avatar
			}
		}
	}

	private func getUserInfo(userID: UUID) -> User? {
		// This is a placeholder implementation for fetching user info
		// Since we don't have access to the actual user data fetching logic,
		// we can use a mock implementation similar to InMemoryChatService for demo purposes.
		return [
			User(id: UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA244C")!, name: "Alice", email: "alice@example.com", avatar: "https://randomuser.me/api/portraits/men/42.jpg"),
			User(id: UUID(uuidString: "30104AE5-947D-4CF9-A335-F4F51994A92D")!, name: "Bob", email: "bob@example.com", avatar: "https://randomuser.me/api/portraits/women/47.jpg")
		].first { $0.id == userID }
	}

	func sendMessage() {
		guard !messageText.isEmpty else { return }
		Task {
			do {
				try await chatService.sendMessage(content: messageText, senderID: userId, receiverID: receiverId)
				messageText = ""
			} catch {
				print("Failed to send message: \(error)")
			}
		}
	}
}
