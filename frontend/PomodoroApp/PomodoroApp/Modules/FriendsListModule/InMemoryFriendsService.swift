class InMemoryFriendsService: FriendsService {
    private var friends: [Friend]

    init(friends: [Friend] = []) {
        self.friends = friends
        let sampleFriends = [
            Friend(userId: "1",
                   displayName: "John Doe",
                   profilePictureURL: "https://randomuser.me/api/portraits/men/42.jpg",
                   friendSince: "2020-01-01"),
            Friend(userId: "2",
                   displayName: "Jane Smith",
                   profilePictureURL: "https://randomuser.me/api/portraits/women/47.jpg",
                   friendSince: "2019-05-12"),
        ]
        self.friends.append(contentsOf: sampleFriends)
    }

    func getFriendsList(for userId: String) async throws -> [Friend] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return friends
    }
}
