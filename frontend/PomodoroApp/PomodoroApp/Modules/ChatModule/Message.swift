import Foundation

struct Message: Identifiable, Codable, Equatable {
	var id: UUID
	var content: String
	var senderID: UUID
	var receiverID: UUID
//	var createdAt: Date

	init(id: UUID = UUID(), content: String, senderID: UUID, receiverID: UUID, createdAt: Date = Date()) {
		self.id = id
		self.content = content
		self.senderID = senderID
		self.receiverID = receiverID
//		self.createdAt = createdAt
	}
}
