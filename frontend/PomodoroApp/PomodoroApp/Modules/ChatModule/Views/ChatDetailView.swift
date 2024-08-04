import SwiftUI

struct ChatDetailView: View {
	@StateObject private var viewModel: ChatDetailViewModel
	@State private var scrollViewProxy: ScrollViewProxy? = nil

	init(userId: UUID, chatId: UUID) {
		_viewModel = StateObject(wrappedValue: ChatDetailViewModel(userId: userId, chatId: chatId))
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
										.padding([.leading, .top, .bottom], 10)
								} else {
									HStack {
										if let url = URL(string: message.senderAvatar) {
											AsyncImage(url: url) { image in
												image.resizable()
											} placeholder: {
												Image(systemName: "person.fill")
											}
											.frame(width: 40, height: 40)
											.cornerRadius(20)
										} else {
											Image(systemName: "person.fill") // Placeholder for avatar image
												.resizable()
												.frame(width: 40, height: 40)
												.cornerRadius(20)
										}
										Text(message.content)
											.padding()
											.background(Color.gray.opacity(0.2))
											.foregroundColor(.black)
											.cornerRadius(8)
									}
									.padding([.trailing, .top, .bottom], 10)
									Spacer()
								}
							}
							.padding(.horizontal, 10)
							.id(message.id) // Assign an id to each message view
						}
					}
				}
				.onAppear {
					scrollViewProxy = proxy
					scrollToBottom()
				}
				.onChange(of: viewModel.receivedMessages) {
					scrollToBottom()
				}
			}
			HStack {
				TextField("Enter message", text: $viewModel.messageText)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.onSubmit {
						viewModel.sendMessage()
					}
				Button(action: viewModel.sendMessage) {
					Text("Send")
				}
				.padding(.leading, 10)
			}
			.padding()
		}
		.navigationTitle(viewModel.receiverName)
	}

	@MainActor
	private func scrollToBottom() {
		scrollViewProxy?.scrollTo(viewModel.receivedMessages.last?.id, anchor: .bottom)
	}
}

struct ChatDetailView_Previews: PreviewProvider {
	static var previews: some View {
		ChatDetailView(userId: UUID(), chatId: UUID())
	}
}
