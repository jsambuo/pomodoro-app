import Foundation
import Combine

protocol ChatService {
	var messageReceivedPublisher: AnyPublisher<Message, Never> { get }

	func sendMessage(chatID: UUID, content: String, senderID: UUID) async throws
	func getMessages(chatID: UUID) async throws -> [Message]
	func getUserChats(for userID: UUID) async throws -> [Chat]
}
