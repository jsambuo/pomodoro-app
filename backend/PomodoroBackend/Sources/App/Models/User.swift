
import Vapor

struct User: Content {
	var id: UUID
	var name: String
	var email: String
	var avatar: String
}
