import Foundation

class FriendsAPIService: FriendsService {
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func getFriendsList(for userId: String) async throws -> [Friend] {
        guard let url = URL(string: "/users/\(userId)/friends", relativeTo: baseURL) else {
            throw FriendsServiceError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let friendsResponse = try JSONDecoder().decode([String: [Friend]].self, from: data)
        return friendsResponse["friends"] ?? []
    }
}

enum FriendsServiceError: Error {
    case invalidURL
    case noData
}
