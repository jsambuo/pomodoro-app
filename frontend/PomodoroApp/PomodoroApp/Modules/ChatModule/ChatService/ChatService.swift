import Foundation

protocol ChatService {
    func sendMessage(content: String, senderID: UUID, receiverID: UUID) async throws
	
	func fetchChatHistory(senderID: UUID, receiverID: UUID) async throws -> [Message]
}
