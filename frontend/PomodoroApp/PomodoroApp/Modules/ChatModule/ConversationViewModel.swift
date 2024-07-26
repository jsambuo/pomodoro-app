import Foundation
import Combine
import ProjectI // Import ProjectI for DIContainer and @Inject

@MainActor
class ConversationViewModel: ObservableObject {
	@Published var messageText: String = ""
	@Published var receivedMessages: [Message] = []

	private var cancellables = Set<AnyCancellable>()
	@Inject private var webSocketService: WebSocketService
	@Inject private var chatService: ChatService

	let userId: UUID
	let receiverId: UUID

	init(userId: UUID, receiverId: UUID) {
		self.userId = userId
		self.receiverId = receiverId

		subscribeToWebSocket()
		loadChatHistory()
	}

	private func subscribeToWebSocket() {
		webSocketService.messageReceivedPublisher
			.receive(on: DispatchQueue.main) // Ensure messages are received on the main thread
			.sink { [weak self] message in
				guard let self = self else { return }
				// Assuming message is received as JSON string, convert to Message object
				if let data = message.data(using: .utf8), let receivedMessage = try? JSONDecoder().decode(Message.self, from: data) {
					self.receivedMessages.append(receivedMessage)
				}
			}
			.store(in: &cancellables)

		webSocketService.connectPublisher
			.receive(on: DispatchQueue.main) // Ensure connection events are received on the main thread
			.sink { [weak self] in
				print("Connected to WebSocket")
			}
			.store(in: &cancellables)

		webSocketService.disconnectPublisher
			.receive(on: DispatchQueue.main) // Ensure disconnection events are received on the main thread
			.sink { [weak self] in
				print("Disconnected from WebSocket")
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
