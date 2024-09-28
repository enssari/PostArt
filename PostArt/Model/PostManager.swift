//
//  PostManager.swift
//  PostArt
//
//  Created by Enes Sarı on 9/16/24.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class PostManager: ObservableObject {
    @AppStorage("uid") var userId: String = ""
    
    @Published var userPosts: [Post] = []
    @Published var posts: [Post] = []
    @Published var photoUrl: String = ""
    @Published var title: String = ""
    @Published var errorMessage: String? = nil
    @Published var description: String = ""
    
    func createPost(authViewModel: AuthenticationViewModel, title: String, photoUrl: String) {
        guard !userId.isEmpty else { return }
        
        let newPost = Post(
            id: UUID().uuidString,
            title: title,
            description: description,
            photoUrl: photoUrl,
            username: authViewModel.username,
            userPhoto: authViewModel.imageUrl,
            createdAt: Date()
        )
        
        let postData: [String: Any] = [
            "Title": newPost.title,
            "Description": newPost.description,
            "Photo": newPost.photoUrl,
            "UserPhoto": newPost.userPhoto,
            "Username": newPost.username,
            "CreatedAt": Timestamp(date: newPost.createdAt),
            "postId": userId
        ]
        
        let db = Firestore.firestore()
        db.collection("Posts").addDocument(data: postData) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Could not create post: \(error.localizedDescription)"
                }
            } else {
                DispatchQueue.main.async {
                    self.posts.append(newPost)
                    print("Post successfully created!")
                }
            }
        }
    }
    
    func deletePost(postId: String) {
        guard !postId.isEmpty else {return}

        let db = Firestore.firestore()
        db.collection("Posts").document(postId).delete { error in
            if let error = error {
                DispatchQueue.main.async {
                    print("Could not delete the post: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updatePosts(postId: String, updatedDesc: String) {
        guard !postId.isEmpty else {return}
        
        let updatedData: [String: Any] = [
            "Description": updatedDesc
        ]
        
        let db = Firestore.firestore()
        db.collection("Posts").document(postId).updateData(updatedData) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Could not update description: \(error.localizedDescription)"
                }
            } else {
                self.description = updatedData["Description"] as? String ?? ""
            }
        }
    }
    
    func fetchPostData(authViewModel: AuthenticationViewModel) {
        guard !userId.isEmpty else {return}
        
        let db = Firestore.firestore()
        db.collection("Posts").order(by: "CreatedAt", descending: true).getDocuments { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Could not fetch user data: \(error.localizedDescription)"
                }
            } else if let snapshot = snapshot {
                DispatchQueue.main.async {
                    self.posts = snapshot.documents.compactMap { document in
                        let data = document.data()
                                            
                        return Post(
                            id: document.documentID,
                            title: data["Title"] as? String ?? "",
                            description: data["Description"] as? String ?? "",
                            photoUrl: data["Photo"] as? String ?? "",
                            username: data["Username"] as? String ?? "",
                            userPhoto: data["UserPhoto"] as? String ?? "",
                            createdAt: (data["CreatedAt"] as? Timestamp)?.dateValue() ?? Date()
                        )
                    }
                }
            }
        }
    }
    
    func fetchPostDetail(postId: String, completion: @escaping (Post?) -> Void) {
        guard !postId.isEmpty else { return }

        let db = Firestore.firestore()
        db.collection("Posts").document(postId).getDocument { document, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Could not fetch post data: \(error.localizedDescription)"
                }
                completion(nil)
            } else if let document = document, document.exists {
                let data = document.data() ?? [:]
                let post = Post(
                    id: document.documentID,
                    title: data["Title"] as? String ?? "",
                    description: data["Description"] as? String ?? "",
                    photoUrl: data["Photo"] as? String ?? "",
                    username: data["Username"] as? String ?? "",
                    userPhoto: data["UserPhoto"] as? String ?? "",
                    createdAt: (data["CreatedAt"] as? Timestamp)?.dateValue() ?? Date()
                )
                completion(post)
            } else {
                completion(nil)
            }
        }
    }

    
    func fetchUserPosts() {
        guard !userId.isEmpty else {
            print("User ID is empty")
            return
        }
        
        let db = Firestore.firestore()
        db.collection("Posts")
            .whereField("postId", isEqualTo: userId)
            .order(by: "CreatedAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Could not fetch user posts: \(error.localizedDescription)"
                    }
                    print("Error fetching user posts: \(error)")
                } else if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.userPosts = snapshot.documents.compactMap { document in
                            let data = document.data()
                                                        
                            return Post(
                                id: document.documentID,
                                title: data["Title"] as? String ?? "",
                                description: data["Description"] as? String ?? "",
                                photoUrl: data["Photo"] as? String ?? "" ,
                                username: data["Username"] as? String ?? "",
                                userPhoto: data["UserPhoto"] as? String ?? "",
                                createdAt: (data["CreatedAt"] as? Timestamp)?.dateValue() ?? Date()
                            )
                        }
                    }
                }
            }
    }

}

struct Post: Identifiable {
    var id: String
    var title: String
    var description: String
    var photoUrl: String
    var username: String
    var userPhoto: String
    var createdAt: Date
}

