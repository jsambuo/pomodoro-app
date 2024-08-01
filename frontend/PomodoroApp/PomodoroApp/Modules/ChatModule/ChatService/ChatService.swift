import Foundation
import Combine

protocol ChatService {
	var messageReceivedPublisher: AnyPublisher<String, Never> { get }
	
	func sendMessage(content: String, senderID: UUID, receiverID: UUID) async throws
	func fetchChatHistory(senderID: UUID, receiverID: UUID) async throws -> [Message]
	func fetchUsers() async throws -> [User]
}
