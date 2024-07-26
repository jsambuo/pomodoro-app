import SwiftUI

struct ChatView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination:
                        ConversationView(
                            userId: UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA244C")!,
                            receiverId: UUID(uuidString:"30104AE5-947D-4CF9-A335-F4F51994A92D")!
                                )){
                    Text("User 1")
                }
                NavigationLink(
                    destination:
                        ConversationView(
                            userId: UUID(uuidString:"30104AE5-947D-4CF9-A335-F4F51994A92D")!, 
                            receiverId: UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA244C")!)) {
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
