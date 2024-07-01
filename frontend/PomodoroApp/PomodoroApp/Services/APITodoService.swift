//
//  APITodoService.swift
//  PomodoroApp
//
//  Created by Jimmy Sambuo on 6/17/24.
//

import Foundation

class APITodoService: TodoService {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func fetchTodos() async throws -> [Todo] {
        let url = baseURL.appendingPathComponent("/todos")
        let (data, _) = try await URLSession.shared.data(from: url)
        let todos = try JSONDecoder().decode([Todo].self, from: data)
        return todos
    }
    
    func fetchTodoDetail(id: String) async throws -> Todo? {
        let url = baseURL.appendingPathComponent("/todos/\(id)")
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
            return nil
        }
        
        let todo = try JSONDecoder().decode(Todo.self, from: data)
        return todo
    }
    
    func createTodoItem(title: String) async throws -> Todo {
        var request = URLRequest(url: baseURL.appendingPathComponent("/todos"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let newTodo = Todo(id: UUID().uuidString, title: title, isCompleted: false)
        let data = try JSONEncoder().encode(newTodo)
        request.httpBody = data
        
        let (responseData, _) = try await URLSession.shared.data(for: request)
        let todo = try JSONDecoder().decode(Todo.self, from: responseData)
        return todo
    }
    
    func updateTodoItem(id: String, title: String) async throws -> Todo? {
        guard var existingTodo = try await fetchTodoDetail(id: id) else {
            return nil
        }
        existingTodo.title = title
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/todos/\(id)"))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try JSONEncoder().encode(existingTodo)
        request.httpBody = data
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
            return nil
        }
        
        let todo = try JSONDecoder().decode(Todo.self, from: responseData)
        return todo
    }
    
    func deleteTodoItem(id: String) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("/todos/\(id)"))
        request.httpMethod = "DELETE"
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    func completeTodoItem(id: String) async throws -> Todo? {
        guard var existingTodo = try await fetchTodoDetail(id: id) else {
            return nil
        }
        existingTodo.isCompleted = true
        
        var request = URLRequest(url: baseURL.appendingPathComponent("/todos/\(id)"))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try JSONEncoder().encode(existingTodo)
        request.httpBody = data
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 404 {
            return nil
        }
        
        let todo = try JSONDecoder().decode(Todo.self, from: responseData)
        return todo
    }
}
