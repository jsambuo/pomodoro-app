import Vapor

struct Friend: Content {
    let userId: String
    let displayName: String
    let profilePictureURL: String
    let friendSince: String
}

struct FriendsResponse: Content {
    let friends: [Friend]
}

