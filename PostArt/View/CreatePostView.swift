//
//  CreatePostView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/12/24.
//

import SwiftUI

struct CreatePostView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var postManager = PostManager()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                ZStack {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width - 10, height: 300)
                        .cornerRadius(15)
                        .foregroundColor(.secondary).opacity(0.6)
                    
                    if let imageUrl = URL(string: postManager.photoUrl), !postManager.photoUrl.isEmpty {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width - 10, height: 300)
                                .cornerRadius(15)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("URL of the image you want to upload")
                    
                    TextField("Image URL", text: $postManager.photoUrl)
                        .padding()
                        .frame(width: 350, height: 35)
                        .foregroundColor(.white)
                        .background(.gray).opacity(0.7)
                        .autocapitalization(.none)
                        .cornerRadius(5)
                }
                
                
                VStack(alignment: .leading) {
                    Text("Enter the title you want")
                    TextField("Title", text: $postManager.title)
                        .padding()
                        .frame(width: 350, height: 35)
                        .foregroundColor(.white)
                        .background(.gray).opacity(0.7)
                        .autocapitalization(.none)
                        .cornerRadius(5)
                }
                
                VStack(alignment: .leading) {
                    Text("Enter a description")
                    TextField("Description", text: $postManager.description)
                        .padding()
                        .frame(width: 350, height: 35)
                        .foregroundColor(.white)
                        .background(.gray).opacity(0.7)
                        .autocapitalization(.none)
                        .cornerRadius(5)
                }
                
                Button {
                    postManager.createPost(authViewModel: authViewModel, title: postManager.title, photoUrl: postManager.photoUrl)
                } label: {
                    Text("Create Post")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                .frame(width: 140, height: 30)
                .background(.green)
                .cornerRadius(5)
                
                if let errorMessage = postManager.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                }
            }
            .padding()
            .navigationTitle("Create Post")
        }
        .onAppear {
            authViewModel.fetchUserData()
        }
    }
}

#Preview {
    CreatePostView()
}


#Preview {
    CreatePostView()
}
