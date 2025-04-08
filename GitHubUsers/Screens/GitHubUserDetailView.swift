import SwiftUI

struct GitHubUserDetailView: View {
    let username: String
    @State private var isLoading = true
    
    @EnvironmentObject var viewModel: GitHubViewModel

    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                ProgressView("Loading user...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(maxWidth: .infinity)
                Spacer()
            } else if let user = viewModel.user {
                // ✅ USER FOUND
                VStack(spacing: 12) {
                    // MARK: - HEADER
                    HStack {
                        AsyncImage(url: URL(string: user.avatar_url)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .shadow(radius: 4)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.login)
                                .font(.title2)
                                .bold()
                                .lineLimit(1)

                            if let name = user.name {
                                Text(name)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.leading, 12)
                        
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.2)))
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity)

                    // MARK: - USER INFO
                    if let bio = user.bio {
                        Text(bio)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .foregroundColor(.gray)
                    }

                    if let location = user.location {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.gray)
                            Text(location)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }

                    HStack {
                        Image(systemName: "folder.fill")
                            .foregroundColor(.orange)
                        Text("Public Repos: \(user.public_repos)")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                        Spacer()
                    }
                    .padding(.horizontal)

                    Spacer()

                    // MARK: - FOOTER
                    Text ("Follower & Following")
                    Text ("Tap on the number to see the list")
                        .font(.caption)
                        .foregroundColor(.gray)

                    HStack {
                        NavigationLink(destination: GitHubUserListView(title: "Followers", fetchType: .followers, username: user.login)) {
                            HStack {
                                Image(systemName: "person.3.fill")
                                    .foregroundColor(.blue)
                                Text("Followers: \(user.followers)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        }

                        NavigationLink(destination: GitHubUserListView(title: "Following", fetchType: .following, username: user.login)) {
                            HStack {
                                Image(systemName: "person.2.fill")
                                    .foregroundColor(.blue)
                                Text("Following: \(user.following)")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity)
                }
                .padding()

            } else {
                // ❌ USER NOT FOUND
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
        }
        .background(Color.secondary.opacity(0.2))
        .onAppear {
            // Reset before fetching
            isLoading = true
            viewModel.user = nil
            viewModel.errorMessage = nil
            
            viewModel.fetchUser(username: username) {
                DispatchQueue.main.async {
                    isLoading = false
                }
            }
        }
    }
}


#Preview {
    GitHubUserDetailView(username: "carlos")
        .environmentObject(GitHubViewModel())
}
