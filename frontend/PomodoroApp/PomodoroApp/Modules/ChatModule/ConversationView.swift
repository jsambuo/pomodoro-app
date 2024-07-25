import SwiftUI

struct ConversationView: View {
    @State private var messageText: String = ""
    let userId: String
    
    var body: some View {
        VStack {
            ScrollView {
                // Display messages here
                Text("Chat history with user \(userId)")
            }
            HStack {
                TextField("Enter message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .padding()
        }
        .navigationTitle("Conversation")
    }
    
    private func sendMessage() {
        // Implement send message action here
        print("Sending message: \(messageText)")
        messageText = ""
    }
}

struct ConversationView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(userId: "1")
    }
}
