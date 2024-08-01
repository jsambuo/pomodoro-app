import SwiftUI

struct ChatView: View {
	@StateObject private var viewModel = ChatViewModel()

	private let currentUser = User(
		id: UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA269D")!,
		name: "James",
		email: "James@example.com",
		avatar: "https://randomuser.me/api/portraits/men/43.jpg"
	)

	var body: some View {
		NavigationView {
			VStack {
				List(viewModel.users) { user in
					NavigationLink(
						destination:
							ConversationView(
								userId: currentUser.id,
								receiverId: user.id
							)
					) {
						HStack {
							if let url = URL(string: user.avatar) {
								AsyncImage(url: url) { image in
									image.resizable()
								} placeholder: {
									Image(systemName: "person.fill")
								}
								.frame(width: 40, height: 40)
								.cornerRadius(20)
							} else {
								Image(systemName: "person.fill")
									.resizable()
									.frame(width: 40, height: 40)
									.cornerRadius(20)
							}
							Text(user.name)
								.font(.headline)
						}
					}
				}
				.navigationTitle("Chats")
				.toolbar {
					ToolbarItem(placement: .principal) {
						UserTitleView(user: currentUser)
					}
				}
			}
		}
		.onAppear {
			viewModel.loadUsers()
		}
	}
}

struct ChatView_Previews: PreviewProvider {
	static var previews: some View {
		ChatView()
	}
}
