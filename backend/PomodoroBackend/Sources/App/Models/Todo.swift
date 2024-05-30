import Vapor

struct Todo: Content {
    var id: String
    var title: String
    var isCompleted: Bool
}
