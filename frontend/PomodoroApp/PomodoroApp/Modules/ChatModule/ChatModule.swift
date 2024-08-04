import SwiftUI
import ModuleKit

struct ChatModule: Module {
	var routes: [Route] {
		[
			Route(path: "/chat", handler: chatListView),
			Route(path: "/chat/:chatId", handler: chatDetailView) // Updated to use chatId
		]
	}

	var actions: [Action] {
		[
			Action(key: "sendMessage", handler: sendMessage),
			Action(key: "loadChatHistory", handler: loadChatHistory)
		]
	}

	private func chatListView(params: [String: Any]) -> some View {
		ChatListView()
	}

	private func chatDetailView(params: [String: Any]) -> some View {
		guard let chatIdString = params["chatId"] as? String, let chatId = UUID(uuidString: chatIdString) else {
			return AnyView(Text("Chat ID not provided"))
		}
		let currentUserId = UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA269D")! // Assume current user ID is known
		return AnyView(ChatDetailView(userId: currentUserId, chatId: chatId))
	}

	private func sendMessage(params: [String: Any]) {
		guard let chatId = params["chatId"] as? String, let message = params["message"] as? String else {
			print("Invalid parameters")
			return
		}
		// Implement the logic to send a message here
		print("Sending message to chat \(chatId): \(message)")
	}

	private func loadChatHistory(params: [String: Any]) {
		guard let chatId = params["chatId"] as? String else {
			print("Invalid parameters")
			return
		}
		// Implement the logic to load chat history here
		print("Loading chat history for chat \(chatId)")
	}
}
