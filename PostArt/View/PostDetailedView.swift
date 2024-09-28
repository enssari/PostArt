//
//  PostDetailedView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/22/24.
//

import SwiftUI

struct PostDetailedView: View {
    var post: Post
    
    @StateObject private var postManager = PostManager()
    
    var body: some View {
        VStack(alignment: .leading ,spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text(formatDate(post.createdAt))
                    .foregroundColor(.secondary)
                
                
                Text(post.title)
                    .font(.title)
                    .fontWeight(.bold)
            }
                        
            if let imageUrl = URL(string: post.photoUrl), !post.photoUrl.isEmpty {
                AsyncImage(url: imageUrl) { image in
                        image
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 20, height: 350)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                }
            }
            
            HStack(spacing: 12) {
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
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            Text(post.description)
                .font(.system(size: 15))
                .padding(.horizontal)
                .foregroundColor(.secondary)
        }
        .padding()
        Spacer()
    }
    
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd"
            return formatter.string(from: date)
        }
}

struct PostDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = Post(
            id: "1",
            title: "Sample Post Title",
            description: "This is a sample description of the post.",
            photoUrl: "https://example.com/sample-photo.jpg",
            username: "SampleUser",
            userPhoto: "https://example.com/sample-user-photo.jpg",
            createdAt: Date()
        )
        
        PostDetailedView(post: samplePost)
    }
}

