import Foundation
import Vapor

struct Message: Identifiable, Content {
	var id: UUID
	var content: String
	var senderID: UUID
	var receiverID: UUID
	var senderName: String
	var senderAvatar: String
	var receiverName: String
	var receiverAvatar: String
	var createdAt: Date

	init(id: UUID = UUID(), content: String, senderID: UUID, receiverID: UUID, senderName: String, senderAvatar: String, receiverName: String, receiverAvatar: String, createdAt: Date = Date()) {
		self.id = id
		self.content = content
		self.senderID = senderID
		self.receiverID = receiverID
		self.senderName = senderName
		self.senderAvatar = senderAvatar
		self.receiverName = receiverName
		self.receiverAvatar = receiverAvatar
		self.createdAt = createdAt
	}
}
