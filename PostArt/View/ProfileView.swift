//
//  ProfileView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/8/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var postManager = PostManager()
        
    @State private var clickedPostId: String = ""
    @State private var editClicked: Bool = false
    @State private var imageClicked: Bool = false
    
    let column = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack(spacing: 150) {
                        Text("Profile")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Button(action: {
                            authViewModel.logOut()
                        }) {
                            Text("sign out")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                        .frame(width: 100, height: 30)
                        .background(.red)
                        .cornerRadius(5)
                    }
                    .padding(.top, 30)
                    
                    // User Info Section
                    VStack {
                        if let imageUrl = URL(string: authViewModel.imageUrl), !authViewModel.imageUrl.isEmpty {
                            AsyncImage(url: imageUrl) { image in
                                    image
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        Text(authViewModel.username)
                            .font(.system(size: 35))
                            .fontWeight(.semibold)
                            .padding(.top, 15)
                        
                        HStack {
                            Text("\(postManager.userPosts.count)")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            
                            Text("Posts")
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                        }
                        
                        NavigationLink(destination: EditProfileView()) {
                            Text("Edit profile")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 100, height: 30)
                        .background(.secondary).opacity(0.9)
                        .cornerRadius(5)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                    Spacer()
                    
                    Divider()
                    
                    LazyVGrid(columns: column) {
                        ForEach(postManager.userPosts) { post in
                            ZStack(alignment: .center) {
                                Button {
                                    editClicked = true
                                    
                                    clickedPostId = post.id
                                } label: {
                                    Image(systemName: "square.and.pencil")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .opacity(imageClicked ? 0.8 : 0)
                                }
                                
                                if let imageUrl = URL(string: post.photoUrl), !post.photoUrl.isEmpty {
                                    Button {
                                        withAnimation(.easeInOut) {
                                            imageClicked.toggle()
                                        }
                                        clickedPostId = post.id
                                    } label: {
                                        AsyncImage(url: imageUrl) { image in
                                                image
                                                .resizable()
                                                .frame(width: 180, height: 160)
                                                .cornerRadius(5)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    .opacity(imageClicked ? 0.2 : 0.8)

                                }
                            }
                            .padding()
                        }
                    }
                    .navigationDestination(isPresented: $editClicked) {
                        EditPostView(postId: clickedPostId)
                    }
                }
                .onAppear {
                    postManager.fetchUserPosts()
                    authViewModel.fetchUserData()
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
