import SwiftUI
import ModuleKit

struct ChatModule: Module {
    var routes: [Route] {
        [
            Route(path: "/chat", handler: chatView),
            Route(path: "/chat/:userId", handler: conversationView)
        ]
    }
    
    var actions: [Action] {
        [
            Action(key: "sendMessage", handler: sendMessage),
            Action(key: "loadChatHistory", handler: loadChatHistory)
        ]
    }
    
    private func chatView(params: [String: Any]) -> some View {
        ChatView()
    }
    
    private func conversationView(params: [String: Any]) -> some View {
        guard let userId = params["userId"] as? String else {
            return AnyView(Text("User ID not provided"))
        }
        return AnyView(ConversationView(userId: UUID(uuidString: userId)!, receiverId: UUID()))
    }
    
    private func sendMessage(params: [String: Any]) {
        guard let userId = params["userId"] as? String, let message = params["message"] as? String else {
            print("Invalid parameters")
            return
        }
        // Implement the logic to send a message here
        print("Sending message to \(userId): \(message)")
    }
    
    private func loadChatHistory(params: [String: Any]) {
        guard let userId = params["userId"] as? String else {
            print("Invalid parameters")
            return
        }
        // Implement the logic to load chat history here
        print("Loading chat history for \(userId)")
    }
}
