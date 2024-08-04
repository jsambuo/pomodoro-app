import Foundation
import Combine
import ProjectI // Import ProjectI for DIContainer and @Inject

class ChatListViewModel: ObservableObject {
	@Published var chats: [Chat] = []
	@Inject private var chatService: ChatService

	private let currentUserId: UUID

	init(currentUserId: UUID) {
		self.currentUserId = currentUserId
		loadChats()
	}

	func loadChats() {
		Task {
			do {
				self.chats = try await chatService.getUserChats(for: currentUserId)
			} catch {
				print("Failed to load chats: \(error)")
			}
		}
	}
}
