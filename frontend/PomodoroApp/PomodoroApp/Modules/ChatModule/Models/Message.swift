import Foundation

struct Message: Identifiable, Codable, Equatable {
	let id: UUID
	let content: String
	let senderID: UUID
	let chatID: UUID
	let senderName: String
	let senderAvatar: String
	let createdAt: Date
}
