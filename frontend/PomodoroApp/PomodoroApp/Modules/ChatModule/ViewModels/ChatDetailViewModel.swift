import Foundation
import Combine
import ProjectI // Import ProjectI for DIContainer and @Inject

@MainActor
class ChatDetailViewModel: ObservableObject {
	@Published var messageText: String = ""
	@Published var receivedMessages: [Message] = []
	@Published var receiverName: String = ""
	@Published var receiverAvatar: String = ""

	private var cancellables = Set<AnyCancellable>()
	@Inject private var chatService: ChatService

	let userId: UUID
	let chatId: UUID

	init(userId: UUID, chatId: UUID) {
		self.userId = userId
		self.chatId = chatId

		subscribeToChatService()
		loadChatMessages()
		loadReceiverInfo()
	}

	private func subscribeToChatService() {
		chatService.messageReceivedPublisher
			.receive(on: DispatchQueue.main) // Ensure messages are received on the main thread
			.sink { [weak self] message in
				guard let self = self else { return }
				// Append message if it belongs to the current chat
				if message.chatID == self.chatId {
					self.receivedMessages.append(message)
				}
			}
			.store(in: &cancellables)
	}

	private func loadChatMessages() {
		Task {
			do {
				let messages = try await chatService.getMessages(chatID: chatId)
				self.receivedMessages = messages
			} catch {
				print("Failed to load chat messages: \(error)")
			}
		}
	}

	private func loadReceiverInfo() {
		// Load receiver information from some data source, e.g., a user service
		// This is a placeholder implementation
		Task {
			// Fetch chat participants
			let chats = try await chatService.getUserChats(for: userId)
			if let chat = chats.first(where: { $0.id == chatId }),
			   let receiver = chat.participants.first(where: { $0.id != userId }) {
				self.receiverName = receiver.name
				self.receiverAvatar = receiver.avatar
			}
		}
	}

	func sendMessage() {
		guard !messageText.isEmpty else { return }
		Task {
			do {
				try await chatService.sendMessage(chatID: chatId, content: messageText, senderID: userId)
				messageText = ""
			} catch {
				print("Failed to send message: \(error)")
			}
		}
	}
}
