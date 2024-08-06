import Vapor

final class Storage {
	var users: [User] = [
		User(id: UUID(), name: "Alice", email: "alice@example.com", avatar: "aliceAvatar.png"),
		User(id: UUID(), name: "Bob", email: "bob@example.com", avatar: "bobAvatar.png")
	]
	var messages: [Message] = []

	// Singleton instance for global access
	static let shared = Storage()
	private init() { }

	func getUserInfo(userID: UUID) -> User? {
		return users.first { $0.id == userID }
	}
}
