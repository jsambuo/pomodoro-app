//
//  TodoListViewModel.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import Foundation
import ProjectI

class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Inject private var todoService: TodoService

    func loadTodos() {
        self.todos = todoService.fetchTodos()
    }
}
