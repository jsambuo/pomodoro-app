import Vapor
import AWSDynamoDB
import AWSClientRuntime

struct FriendsController: RouteCollection {
    let dynamoDB: DynamoDBClient
    let tableName: String = "MainTable"
    
    init(dynamoDB: DynamoDBClient) {
        self.dynamoDB = dynamoDB
    }

    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.group(":userId") { user in
            user.get("friends", use: getFriends)
        }
    }

    func getFriends(req: Request) async throws -> FriendsResponse {
        guard let userId = req.parameters.get("userId") else {
            throw Abort(.badRequest, reason: "User ID is required")
        }

        let input = QueryInput(
            expressionAttributeNames: ["#pk": "PK"],
            expressionAttributeValues: [":pk": .s("USER#\(userId)"), ":sk_prefix": .s("FRIEND#")],
            keyConditionExpression: "#pk = :pk and begins_with(SK, :sk_prefix)",
            tableName: tableName
        )

        let output = try await dynamoDB.query(input: input)
        let items = output.items ?? []
        
        let friends: [Friend] = items.compactMap { dict in
            guard let userIdAttr = dict["SK"], case .s(let userId) = userIdAttr,
                  let displayNameAttr = dict["displayName"], case .s(let displayName) = displayNameAttr,
                  let profilePictureURLAttr = dict["profilePictureURL"], case .s(let profilePictureURL) = profilePictureURLAttr,
                  let friendSinceAttr = dict["friendSince"], case .s(let friendSince) = friendSinceAttr else {
                return nil
            }
            return Friend(userId: userId,
                          displayName: displayName,
                          profilePictureURL: profilePictureURL,
                          friendSince: friendSince)
        }

        return FriendsResponse(friends: friends)
    }
}
