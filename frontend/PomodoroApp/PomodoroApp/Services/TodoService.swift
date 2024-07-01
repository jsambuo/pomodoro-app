//
//  TodoService.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

struct Todo: Identifiable, Codable {
    let id: String
    var title: String
    var isCompleted: Bool
}

protocol TodoService {
    func fetchTodos() async throws -> [Todo]
    func fetchTodoDetail(id: String) async throws -> Todo?
    func createTodoItem(title: String) async throws -> Todo
    func updateTodoItem(id: String, title: String) async throws -> Todo?
    func deleteTodoItem(id: String) async throws
    func completeTodoItem(id: String) async throws -> Todo?
}

