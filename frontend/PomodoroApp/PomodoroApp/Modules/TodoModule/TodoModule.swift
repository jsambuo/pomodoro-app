//
//  TodoModule.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import SwiftUI
import ModuleKit
import Combine

struct TodoModule: Module {
    var routes: [Route] {
        [
            Route(path: "/todos") {
                TodoListView()
            },
            Route(path: "/todos/{id}") { parameters in
                if let id = parameters["id"] as? String {
                    TodoDetailView(id: id)
                } else {
                    Text("Invalid ID")
                }
            },
            Route(path: "/todos/new") {
                TodoCreateView()
            },
        ]
    }

    var actions: [Action] {
        []
    }
}
