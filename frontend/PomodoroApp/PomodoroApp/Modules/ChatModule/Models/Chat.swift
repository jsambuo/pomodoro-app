import Foundation

struct Chat: Identifiable {
	let id: UUID // Stored property for a unique ID
	var participants: [User]
	var latestMessage: Message?

	// Convenience properties
	var participantNames: String {
		participants.map { $0.name }.joined(separator: ", ")
	}

	var participantAvatars: [String] {
		participants.map { $0.avatar }
	}
}

