import SwiftUI

struct ChatListView: View {
	@StateObject private var viewModel: ChatListViewModel

	private let currentUser = User(
		id: UUID(uuidString: "0FDAF1F2-F01B-4E6F-A918-CA68E1EA269D")!,
		name: "James",
		email: "James@example.com",
		avatar: "https://randomuser.me/api/portraits/men/43.jpg"
	)

	init() {
		let currentUserID = currentUser.id
		_viewModel = StateObject(wrappedValue: ChatListViewModel(currentUserId: currentUserID))
	}

	var body: some View {
		NavigationView {
			VStack {
				List(viewModel.chats) { chat in
					ChatRowView(chat: chat, currentUser: currentUser)
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
			viewModel.loadChats()
		}
	}
}

struct ChatRowView: View {
	let chat: Chat
	let currentUser: User

	var body: some View {
		NavigationLink(
			destination: ChatDetailView(
				userId: currentUser.id,
				chatId: chat.id
			)
		) {
			HStack {
				ParticipantAvatarView(avatars: chat.participantAvatars, currentUser: currentUser)
				VStack(alignment: .leading) {
					Text(chat.participantNames)
						.font(.headline)
					if let latestMessage = chat.latestMessage {
						Text(latestMessage.content)
							.font(.subheadline)
							.foregroundColor(.gray)
					}
				}
			}
		}
	}
}

struct ParticipantAvatarView: View {
	let avatars: [String]
	let currentUser: User

	var body: some View {
		if let url = URL(string: avatars.first ?? "") {
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
	}
}

struct ChatListView_Previews: PreviewProvider {
	static var previews: some View {
		ChatListView()
	}
}
