//
//  TodoListViewModel.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import Foundation
import ProjectI

@MainActor
final class TodoListViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Inject private var todoService: TodoService

    func loadTodos() async {
        do {
            self.todos = try await todoService.fetchTodos()
        } catch {
            print("Handle this")
        }
    }
}
