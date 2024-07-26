import SwiftUI

struct ConversationView: View {
	@StateObject private var viewModel: ConversationViewModel
	@State private var scrollViewProxy: ScrollViewProxy? = nil

	init(userId: UUID, receiverId: UUID) {
		_viewModel = StateObject(wrappedValue: ConversationViewModel(userId: userId, receiverId: receiverId))
	}

	var body: some View {
		VStack {
			ScrollViewReader { proxy in
				ScrollView {
					VStack(alignment: .leading) {
						ForEach(viewModel.receivedMessages) { message in
							HStack {
								if message.senderID == viewModel.userId {
									Spacer()
									Text(message.content)
										.padding()
										.background(Color.blue)
										.foregroundColor(.white)
										.cornerRadius(8)
								} else {
									Text(message.content)
										.padding()
										.background(Color.gray.opacity(0.2))
										.foregroundColor(.black)
										.cornerRadius(8)
									Spacer()
								}
							}
							.padding(.bottom, 5)
							.id(message.id) // Assign an id to each message view
						}
					}
				}
				.onAppear {
					scrollViewProxy = proxy
				}
				.onChange(of: viewModel.receivedMessages) { _ in
					scrollToBottom()
				}
			}
			HStack {
				TextField("Enter message", text: $viewModel.messageText)
					.textFieldStyle(RoundedBorderTextFieldStyle())
				Button(action: viewModel.sendMessage) {
					Text("Send")
				}
			}
			.padding()
		}
		.navigationTitle("Conversation")
	}

	@MainActor
	private func scrollToBottom() {
		scrollViewProxy?.scrollTo(viewModel.receivedMessages.last?.id, anchor: .bottom)
	}
}

struct ConversationView_Previews: PreviewProvider {
	static var previews: some View {
		ConversationView(userId: UUID(), receiverId: UUID())
	}
}
