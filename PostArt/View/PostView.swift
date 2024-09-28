//
//  PostView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/12/24.
//

import SwiftUI

struct PostView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var postManager = PostManager()
    
    @State private var clickedPostId: String = ""
    @State private var postClicked: Bool = false
    @State private var selectedPost: Post?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {
                    ForEach(postManager.posts) {post in
                        if let imageUrl = URL(string: post.photoUrl), !post.photoUrl.isEmpty {
                            Button {
                                clickedPostId = post.id
                                postClicked = true
                                
                                postManager.fetchPostDetail(postId: clickedPostId) { post in
                                        selectedPost = post
                                }
                            } label: {
                                AsyncImage(url: imageUrl) { image in
                                    image
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width, height: 300)
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .tracking(1.1)
                                
                                HStack(spacing: 10) {
                                    if let imageUrl = URL(string: post.userPhoto), !post.userPhoto.isEmpty {
                                        AsyncImage(url: imageUrl) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .clipShape(Circle())
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    
                                    Text(post.username)
                                        .font(.system(size: 14))
                                        .fontWeight(.light)
                                }
                                
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }
                .shadow(color: .secondary ,radius: 2)
                .onAppear {
                    postManager.fetchPostData(authViewModel: AuthenticationViewModel())
                    authViewModel.fetchUserData()
                }
                .padding()
                Spacer()
            }
        }
        .navigationDestination(isPresented: $postClicked) {
            if let post = selectedPost {
                PostDetailedView(post: post)
            }
        }
    }
}

#Preview {
    PostView()
}
