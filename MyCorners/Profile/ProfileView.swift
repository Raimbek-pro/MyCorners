import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var presenter = ProfilePostsPresenter()

    var body: some View {
        NavigationStack {
            List {
                // Tappable header to go to account details
                Section(header:
                            NavigationLink(destination: AccountDetailView(authViewModel: authViewModel)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    if let email = Auth.auth().currentUser?.email {
                                        Text("Logged in as")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text(email)
                                            .font(.headline)
                                    } else {
                                        Text("Not logged in")
                                            .font(.headline)
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                            }
                ) {
                    
                    // My Posts
                    ForEach(presenter.myPosts) { post in
                        NavigationLink {
                            PlaceListView(
                                title: post.title,
                                presenter: PlaceListPresenter(interactor: PlaceListInteractor()),
                                showCreateButton: true,
                                feedPostId: post.id
                            )
                        } label: {
                            Text(post.title)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("My Posts")
            .onAppear { presenter.loadMyPosts() }
        }
    }
}


