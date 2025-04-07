import SwiftUI

struct GitHubUserSearchView: View {
    @StateObject private var viewModel = GitHubViewModel()
    @State private var username: String = ""
    @State private var submittedUsername: String = ""
    @State private var shouldNavigate = false
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                // Show loading
                if isLoading {
                    ProgressView("Searching...")
                        .padding()
                }
                
                // Show error if user not found and not loading
                else if submittedUsername != "", viewModel.errorMessage != nil {
                    VStack(spacing: 16) {
                        Image(systemName: "person.fill.questionmark")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)

                        Text("User not found")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }

                Spacer()

                // Hidden navigation link
                NavigationLink(
                    destination: Group {
                        if let user = viewModel.user {
                            GitHubUserDetailView(username: user.login)
                        } else {
                            EmptyView() // fallback to satisfy the return type
                        }
                    },
                    isActive: $shouldNavigate
                ) {
                    EmptyView()
                }
                .hidden()


                // Search Bar
                HStack {
                    TextField("Search GitHub username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.isEmpty {
                            submittedUsername = trimmed
                            isLoading = true
                            viewModel.user = nil
                            viewModel.errorMessage = nil

                            viewModel.fetchUser(username: trimmed) {
                                DispatchQueue.main.async {
                                    isLoading = false
                                    if viewModel.user != nil {
                                        shouldNavigate = true
                                    }
                                }
                            }
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .padding(8)
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Circle())
                    }
                    .padding(.trailing)
                }
                .padding(.bottom, 16)
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("GitHub Search")
        }
    }
}

#Preview {
    GitHubUserSearchView()
}
