//
//  TodoCreateView.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/14/24.
//

import SwiftUI

import SwiftUI

struct TodoCreateView: View {
    @StateObject private var viewModel = TodoCreateViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField("Title", text: $viewModel.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Create", 
                   action: {
                Task {
                    await viewModel.createTodo()
                }
            })
            .disabled(viewModel.isCreateButtonDisabled)
            .padding()

            Spacer()
        }
        .navigationTitle("Create Todo")
        .padding()
        .onAppear {
            viewModel.dismiss = {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    TodoCreateView()
}
