//
//  TodoListView.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import SwiftUI
import ModuleKit

struct TodoListView: View {
    @StateObject var viewModel: TodoListViewModel

    init(viewModel: TodoListViewModel = TodoListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.todos.isEmpty {
                    Text("No tasks found")
                        .foregroundColor(.gray)
                } else {
                    Section(header: Text("Inbox")) {
                        List(viewModel.todos.filter { !$0.isCompleted }) { todo in
                            NavigationLink(destination: TodoDetailView(id: todo.id)) {
                                Text(todo.title)
                            }
                        }
                    }
                    
                    Section(header: Text("Completed")) {
                        List(viewModel.todos.filter { $0.isCompleted }) { todo in
                            NavigationLink(destination: TodoDetailView(id: todo.id)) {
                                Text(todo.title)
                            }
                        }
                    }
                }
            }
            .navigationTitle("To-do list")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: TodoCreateView()) {
                        Text("Create")
                    }
                }
            }
            .onAppear {
                viewModel.loadTodos()
            }
        }
    }
}

#Preview("Empty") {
    TodoListView()
}

#Preview("Items") {
    let viewModel = TodoListViewModel()
    viewModel.todos = [
        Todo(id: "1", 
             title: "Take out trash",
             isCompleted: false),
        Todo(id: "2",
             title: "Wash dog",
             isCompleted: false),
        Todo(id: "3",
             title: "Poop",
             isCompleted: false),
    ]
    return TodoListView(viewModel: viewModel)
}
