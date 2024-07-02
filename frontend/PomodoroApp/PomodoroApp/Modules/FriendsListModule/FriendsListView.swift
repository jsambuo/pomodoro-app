import SwiftUI
import ProjectI

struct Friend: Codable, Identifiable {
    var id: String { userId }
    let userId: String
    let displayName: String
    let profilePictureURL: String
    let friendSince: String
}

struct FriendsListView: View {
    let userId: String
    @State private var friends: [Friend] = []
    @State private var isLoading = true
    @State private var error: String?
    
    @Inject private var friendsService: FriendsService

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading friends...")
            } else if let error = error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                List(friends) { friend in
                    HStack {
                        AsyncImage(url: URL(string: friend.profilePictureURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        VStack(alignment: .leading) {
                            Text(friend.displayName)
                                .font(.headline)
                            Text("Friends since \(friend.friendSince)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .onAppear(perform: loadFriends)
        .navigationTitle("Friends List")
    }

    private func loadFriends() {
        Task {
            do {
                friends = try await friendsService.getFriendsList(for: userId)
                isLoading = false
            } catch {
                self.error = error.localizedDescription
                isLoading = false
            }
        }
    }
}
