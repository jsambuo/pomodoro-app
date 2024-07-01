//
//  TodoCreateViewModel.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import Combine
import SwiftUI
import ProjectI

@MainActor
final class TodoCreateViewModel: ObservableObject {
    @Published var title: String = ""
    @Inject private var todoService: TodoService
    var isCreateButtonDisabled: Bool {
        return title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var dismiss: (() -> Void)?

    func createTodo() async {
        guard !isCreateButtonDisabled else { return }
        do {
            _ = try await todoService.createTodoItem(title: title)
        } catch {
            print("Handle this")
        }
        dismiss?()
    }
}
