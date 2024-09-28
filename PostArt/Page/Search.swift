//
//  Search.swift
//  PostArt
//
//  Created by Enes Sarı on 9/8/24.
//

import SwiftUI

struct Search: View {
    @State private var searchText: String = ""
    @StateObject private var postManager = PostManager()
    
    @State private var clickedPostId: String = ""
    @State private var selectedPost: Post? = nil
    
    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return postManager.posts
        } else {
            return postManager.posts.filter { $0.title.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search for posts", text: $searchText)
                    .padding(.leading)
                    .frame(width: 350, height: 35)
                    .background(.gray).opacity(0.7)
                    .cornerRadius(5)
                    .padding()

                List {
                    ForEach(filteredPosts) { post in
                        Button {
                            clickedPostId = post.id
                            
                            // Fetch the post details and assign the selectedPost
                            postManager.fetchPostDetail(postId: clickedPostId) { post in
                                selectedPost = post
                            }
                        } label: {
                            HStack(spacing: 25) {
                                if let imageUrl = URL(string: post.photoUrl) {
                                    AsyncImage(url: imageUrl) { image in
                                        image
                                            .resizable()
                                            .frame(width: 175, height: 150)
                                            .cornerRadius(15)
                                            
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(post.title)
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    HStack {
                                        if let imageUrl = URL(string: post.userPhoto), !post.userPhoto.isEmpty {
                                            AsyncImage(url: imageUrl) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 35, height: 35)
                                                    .clipShape(Circle())
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                        
                                        Text(post.username)
                                            .font(.system(size: 12))
                                            .fontWeight(.light)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                postManager.fetchPostData(authViewModel: AuthenticationViewModel())
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedPost != nil },
                set: { newValue in
                    if !newValue { selectedPost = nil }
                }
            )) {
                if let post = selectedPost {
                    PostDetailedView(post: post)
                }
            }
        }
    }
}

#Preview {
    Search()
}
