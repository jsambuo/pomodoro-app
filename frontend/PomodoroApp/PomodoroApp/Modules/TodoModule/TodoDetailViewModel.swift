//
//  TodoDetailViewModel.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import Foundation
import ProjectI

class TodoDetailViewModel: ObservableObject {
    @Published var todo: Todo?
    @Inject private var todoService: TodoService
    var dismiss: (() -> Void)?

    func loadTodoDetail(id: String) {
        self.todo = todoService.fetchTodoDetail(id: id)
    }

    func completeTodo() {
        guard let id = todo?.id else { return }
        todoService.completeTodoItem(id: id)
        loadTodoDetail(id: id)
        dismiss?()
    }

    func deleteTodo() {
        guard let id = todo?.id else { return }
        todoService.deleteTodoItem(id: id)
        dismiss?()
    }
}
