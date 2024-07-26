import Foundation

class APIChatService: ChatService {
    private let baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func sendMessage(content: String, senderID: UUID, receiverID: UUID) async throws {
        let url = baseURL.appendingPathComponent("/api/chat/send")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let message = CreateMessageDTO(content: content, senderID: senderID, receiverID: receiverID)
        guard let httpBody = try? JSONEncoder().encode(message) else {
            throw NSError(domain: "Encoding Error", code: 0, userInfo: nil)
        }

        request.httpBody = httpBody

		let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Invalid Response", code: 0, userInfo: nil)
        }
    }
	
	func fetchChatHistory(senderID: UUID, receiverID: UUID) async throws -> [Message] {
		let url = baseURL
			.appendingPathComponent("/api/chat/history")
			.appending(queryItems: [URLQueryItem(name: "sender_id", value: senderID.uuidString),
									URLQueryItem(name: "receiver_id", value: receiverID.uuidString)])
		let (data, response) = try await URLSession.shared.data(from: url)

		guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
			throw NSError(domain: "Invalid Response", code: 0, userInfo: nil)
		}

		let messages = try JSONDecoder().decode([Message].self, from: data)
		return messages
	}
}

struct CreateMessageDTO: Codable {
    let content: String
    let senderID: UUID
    let receiverID: UUID
}
