//
//  TodoService.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

struct Todo: Identifiable {
    let id: String
    var title: String
    var isCompleted: Bool
}

protocol TodoService {
    func fetchTodos() -> [Todo]
    func fetchTodoDetail(id: String) -> Todo?
    func createTodoItem(title: String)
    func updateTodoItem(id: String, title: String)
    func deleteTodoItem(id: String)
    func completeTodoItem(id: String)
}
