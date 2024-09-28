//
//  EditPostView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/24/24.
//

import SwiftUI

struct EditPostView: View {
    let postId: String
    
    @StateObject private var postManager = PostManager()
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    @State private var profileView = ProfileView()
    @State private var editedText: String = ""
    @State private var editClicked: Bool = false
    @State private var deleteClicked: Bool = false
    @State private var saveClicked: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            if let imageUrl = URL(string: postManager.photoUrl), !postManager.photoUrl.isEmpty {
                AsyncImage(url: imageUrl) { image in
                        image
                        .resizable()
                        .frame(width: 350, height: 350)
                } placeholder: {
                    ProgressView()
                }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    if let imageUrl = URL(string: authViewModel.imageUrl), !authViewModel.imageUrl.isEmpty {
                        AsyncImage(url: imageUrl) { image in
                                image
                                .frame(width: 350, height: 350)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text(authViewModel.username)
                }
                
                HStack(spacing: 40) {
                    if !editClicked {
                        Text(postManager.description)
                            .frame(width: 250)
                            .foregroundColor(.secondary)
                    } else {
                        TextField("\(postManager.description)", text: $editedText)
                            .frame(width: 250)
                            .background(.black)
                    }
                    
                    Button {
                        editClicked = true
                    } label: {
                        if editClicked {
                            Button {
                                editClicked = false
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding()
            
            HStack {
                Button {
                    postManager.updatePosts(postId: postId, updatedDesc: editedText)
                    saveClicked.toggle()
                } label: {
                    Text("Save Changes")
                        .foregroundColor(.white)
                }
                .frame(width: 150, height: 40)
                .background(.blue)
                .cornerRadius(5)
                .padding(.top, 50)
                .alert("Changes Saved Succesfully!", isPresented: $saveClicked) {
                    Button("OK", role: .cancel) {}
                }
                
                Button {
                    postManager.deletePost(postId: postId)
                    deleteClicked.toggle()
                } label: {
                    Text("Delete Post")
                        .foregroundColor(.white)
                }
                .frame(width: 150, height: 41)
                .background(.red)
                .cornerRadius(5)
                .padding(.top, 50)
                .alert("Post Deleted Succesfully!", isPresented: $deleteClicked) {
                    Button("OK", role: .cancel) {}
                }
            }
        }
        .onAppear {
                    postManager.fetchPostDetail(postId: postId) { post in
                        if let post = post {
                            postManager.photoUrl = post.photoUrl
                            postManager.description = post.description
                            editedText = post.description
                        }
                    }
                }
    }
}

#Preview {
    EditPostView(postId: "Sample")
}
