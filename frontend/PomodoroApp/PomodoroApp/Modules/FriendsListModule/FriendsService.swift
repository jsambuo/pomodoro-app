protocol FriendsService {
    func getFriendsList(for userId: String) async throws -> [Friend]
}
