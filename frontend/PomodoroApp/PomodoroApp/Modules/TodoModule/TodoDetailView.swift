//
//  TodoDetailView.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import SwiftUI

struct TodoDetailView: View {
    let id: String
    @StateObject private var viewModel = TodoDetailViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if let todo = viewModel.todo {
                Text(todo.title)
                Button("Complete") {
                    viewModel.completeTodo()
                }
                Button("Delete") {
                    viewModel.deleteTodo()
                }
            } else {
                Text("Loading...")
                    .onAppear {
                        viewModel.loadTodoDetail(id: id)
                    }
            }
        }
        .navigationTitle("To-Do Detail")
        .onAppear {
            viewModel.dismiss = {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    TodoDetailView(id: "1")
}
