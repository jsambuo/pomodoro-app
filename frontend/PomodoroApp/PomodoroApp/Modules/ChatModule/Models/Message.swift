import Foundation

struct Message: Identifiable, Codable, Equatable {
	var id: UUID
	var content: String
	var senderID: UUID
	var receiverID: UUID
	var senderName: String
	var senderAvatar: String // URL or name for the avatar image
	var receiverName: String
	var receiverAvatar: String // URL or name for the avatar image
//	var createdAt: Date

	init(id: UUID = UUID(), content: String, senderID: UUID, receiverID: UUID, senderName: String, senderAvatar: String, receiverName: String, receiverAvatar: String, createdAt: Date = Date()) {
		self.id = id
		self.content = content
		self.senderID = senderID
		self.receiverID = receiverID
		self.senderName = senderName
		self.senderAvatar = senderAvatar
		self.receiverName = receiverName
		self.receiverAvatar = receiverAvatar
//		self.createdAt = createdAt
	}

	static func == (lhs: Message, rhs: Message) -> Bool {
		return lhs.id == rhs.id &&
			   lhs.content == rhs.content &&
			   lhs.senderID == rhs.senderID &&
			   lhs.receiverID == rhs.receiverID &&
			   lhs.senderName == rhs.senderName &&
			   lhs.senderAvatar == rhs.senderAvatar &&
			   lhs.receiverName == rhs.receiverName &&
			   lhs.receiverAvatar == rhs.receiverAvatar //&&
//			   lhs.createdAt == rhs.createdAt
	}
}
