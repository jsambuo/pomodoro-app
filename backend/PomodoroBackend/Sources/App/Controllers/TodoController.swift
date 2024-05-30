import Vapor
import AWSDynamoDB
import AWSClientRuntime

struct TodoController: RouteCollection {
    let dynamoDB: DynamoDBClient
    let tableName: String = "MainTable"
    
    init(dynamoDB: DynamoDBClient) {
        self.dynamoDB = dynamoDB
    }

    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: index)
        todos.post(use: create)
        todos.group(":todoID") { todo in
            todo.delete(use: delete)
            todo.put(use: update)
            todo.get(use: get)
        }
    }

    func index(req: Request) async throws -> [Todo] {
        let input = QueryInput(
            expressionAttributeNames: ["#pk": "PK"],
            expressionAttributeValues: [":pk": .s("TODO")],
            keyConditionExpression: "#pk = :pk",
            tableName: tableName
        )

        let output = try await dynamoDB.query(input: input)
        let items = output.items ?? []
        return items.compactMap { dict in
            guard let idAttr = dict["SK"], case .s(let id) = idAttr,
                  let titleAttr = dict["title"], case .s(let title) = titleAttr,
                  let isCompletedAttr = dict["isCompleted"], case .bool(let isCompleted) = isCompletedAttr else {
                return nil
            }
            return Todo(id: id, title: title, isCompleted: isCompleted)
        }
    }

    func create(req: Request) async throws -> Todo {
        let todo = try req.content.decode(Todo.self)
        let input = PutItemInput(
            item: [
                "PK": .s("TODO"),
                "SK": .s(todo.id),
                "title": .s(todo.title),
                "isCompleted": .bool(todo.isCompleted)
            ],
            tableName: tableName
        )
        _ = try await dynamoDB.putItem(input: input)
        return todo
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let id = req.parameters.get("todoID") else {
            throw Abort(.badRequest)
        }
        let input = DeleteItemInput(
            key: ["PK": .s("TODO"), "SK": .s(id)],
            tableName: tableName
        )
        _ = try await dynamoDB.deleteItem(input: input)
        return .noContent
    }

    func update(req: Request) async throws -> Todo {
        let updatedTodo = try req.content.decode(Todo.self)
        let input = UpdateItemInput(
            expressionAttributeValues: [
                ":title": .s(updatedTodo.title),
                ":isCompleted": .bool(updatedTodo.isCompleted)
            ],
            key: ["PK": .s("TODO"), "SK": .s(updatedTodo.id)],
            tableName: tableName,
            updateExpression: "SET title = :title, isCompleted = :isCompleted"
        )
        _ = try await dynamoDB.updateItem(input: input)
        return updatedTodo
    }

    func get(req: Request) async throws -> Todo {
        guard let id = req.parameters.get("todoID") else {
            throw Abort(.badRequest)
        }
        let input = GetItemInput(
            key: ["PK": .s("TODO"), "SK": .s(id)],
            tableName: tableName
        )
        let output = try await dynamoDB.getItem(input: input)
        guard let item = output.item,
              let idAttr = item["SK"], case .s(let id) = idAttr,
              let titleAttr = item["title"], case .s(let title) = titleAttr,
              let isCompletedAttr = item["isCompleted"], case .bool(let isCompleted) = isCompletedAttr else {
            throw Abort(.notFound)
        }
        
        return Todo(id: id, title: title, isCompleted: isCompleted)
    }
}
