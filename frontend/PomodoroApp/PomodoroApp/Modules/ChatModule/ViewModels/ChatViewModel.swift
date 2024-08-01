import Foundation
import Combine
import ProjectI // Import ProjectI for DIContainer and @Inject

class ChatViewModel: ObservableObject {
	@Published var users: [User] = []
	@Inject private var chatService: ChatService

	init() {
		loadUsers()
	}

	func loadUsers() {
		Task {
			do {
				self.users = try await chatService.fetchUsers()
			} catch {
				print("Failed to load users: \(error)")
			}
		}
	}
}
