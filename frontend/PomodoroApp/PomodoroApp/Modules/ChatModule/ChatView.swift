import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ConversationView(userId: "1")) {
                    Text("User 1")
                }
                NavigationLink(destination: ConversationView(userId: "2")) {
                    Text("User 2")
                }
            }
            .navigationTitle("Chats")
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
