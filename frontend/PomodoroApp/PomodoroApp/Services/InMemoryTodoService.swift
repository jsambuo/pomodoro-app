//
//  InMemoryTodoService.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import Foundation

class InMemoryTodoService: TodoService {
    private var todos = [Todo]()

    func fetchTodos() -> [Todo] {
        return todos
    }

    func fetchTodoDetail(id: String) -> Todo? {
        return todos.first { $0.id == id }
    }

    func createTodoItem(title: String) {
        todos.append(Todo(id: UUID().uuidString, title: title, isCompleted: false))
    }

    func updateTodoItem(id: String, title: String) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].title = title
        }
    }

    func deleteTodoItem(id: String) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos.remove(at: index)
        }
    }

    func completeTodoItem(id: String) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].isCompleted = true
        }
    }
}

