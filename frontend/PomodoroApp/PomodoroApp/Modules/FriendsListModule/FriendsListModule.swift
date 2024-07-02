import SwiftUI
import ModuleKit

struct FriendsListModule: Module {
    var routes: [Route] {
        return [
            Route(path: "/friends", handler: {
                FriendsListView(userId: "jason")
            })
        ]
    }
    
    var actions: [Action] {
        return []
    }
}
