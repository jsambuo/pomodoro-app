//
//  TodoDetailViewModel.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import Foundation
import ProjectI

@MainActor
final class TodoDetailViewModel: ObservableObject {
    @Published var todo: Todo?
    @Inject private var todoService: TodoService
    var dismiss: (() -> Void)?

    func loadTodoDetail(id: String) async {
        do {
            self.todo = try await todoService.fetchTodoDetail(id: id)
        } catch {
            print("Handle this")
        }
    }

    func completeTodo() async {
        guard let id = todo?.id else { return }
        
        do {
            _ = try await todoService.completeTodoItem(id: id)
            await loadTodoDetail(id: id)
            dismiss?()
        } catch {
            print("Handle this")
        }
    }

    func deleteTodo() async {
        guard let id = todo?.id else { return }
        do {
            try await todoService.deleteTodoItem(id: id)
            dismiss?()
        } catch {
            print("Handle this")
        }
    }
}
