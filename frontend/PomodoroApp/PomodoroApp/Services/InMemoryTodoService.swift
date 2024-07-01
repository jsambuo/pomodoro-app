//
//  InMemoryTodoService.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import Foundation

class InMemoryTodoService: TodoService {
    private var todos = [Todo]()

    func fetchTodos() async throws -> [Todo] {
        return todos
    }

    func fetchTodoDetail(id: String) async throws -> Todo? {
        return todos.first { $0.id == id }
    }

    func createTodoItem(title: String) async throws -> Todo {
        let todo = Todo(id: UUID().uuidString, title: title, isCompleted: false)
        todos.append(todo)
        return todo
    }

    func updateTodoItem(id: String, title: String) async throws -> Todo? {
        guard let index = todos.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        todos[index].title = title
        return todos[index]
    }

    func deleteTodoItem(id: String) async throws {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos.remove(at: index)
        }
    }

    func completeTodoItem(id: String) async throws -> Todo? {
        guard let index = todos.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        todos[index].isCompleted = true
        return todos[index]
    }
}

