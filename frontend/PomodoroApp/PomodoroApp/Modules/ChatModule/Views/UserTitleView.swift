import SwiftUI

struct UserTitleView: View {
	let user: User

	var body: some View {
		VStack {
			if let url = URL(string: user.avatar) {
				AsyncImage(url: url) { image in
					image.resizable()
				} placeholder: {
					Image(systemName: "person.fill")
				}
				.frame(width: 40, height: 40)
				.cornerRadius(20)
			} else {
				Image(systemName: "person.fill")
					.resizable()
					.frame(width: 40, height: 40)
					.cornerRadius(20)
			}
			Text(user.name)
				.font(.headline)
				.fontWeight(.bold)
		}
	}
}
