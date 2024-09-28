import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthenticationViewModel: ObservableObject {
    @AppStorage("uid") var userId: String = ""
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var imageUrl: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoggedIn: Bool = false
    @Published var isRegistered: Bool = false
    @Published var isLoading: Bool = false
    @Published var isUpdated: Bool = false
    
    
    // Manage Authentication
    func register() {
        clearError()
        isLoading = true
        let db = Firestore.firestore()
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Registration Failed: \(error.localizedDescription)")
                } else if let authResult = authResult {
                    self.isRegistered = true
                    print("Registration Successful!")
                    
                    let uid = authResult.user.uid
                    let userdata: [String: Any] = [
                        "Username": self.username,
                        "Image": self.imageUrl,
                        "userId": uid
                    ]
                    
                    db.collection("Users").document(uid).setData(userdata) { error in
                        DispatchQueue.main.async {
                            if let error = error {
                                self.errorMessage = error.localizedDescription
                                print("Could not save the user data: \(error.localizedDescription)")
                            } else {
                                print("User data saved successfully!")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func login() {
        clearError()
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    print("Login Failed: \(error.localizedDescription)")
                } else if let authResult = authResult {
                    self.userId = authResult.user.uid
                    self.isLoggedIn = true
                    print("Login Successful!")
                    self.fetchUserData()
                }
            }
        }
    }
    
    func logOut() {
        clearError()
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.userId = ""
            print("Log Out Successful!")
        } catch let signOutError as NSError {
            DispatchQueue.main.async {
                self.errorMessage = signOutError.localizedDescription
                print("Log Out Failed: \(signOutError.localizedDescription)")
            }
        }
    }
    
    private func clearError() {
        DispatchQueue.main.async {
            self.errorMessage = nil
        }
    }

    
    // Manage User Data
    func fetchUserData() {

        guard !userId.isEmpty else {return}
        
        let db = Firestore.firestore()
        db.collection("Users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                DispatchQueue.main.async {
                    self.username = data["Username"] as? String ?? ""
                    self.imageUrl = data["Image"] as? String ?? ""
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription ?? "Failed to load user Data."
                    print(self.errorMessage ?? "Error")
                }
            }
        }
    }

    func updateData(newUsername: String, newImageUrl: String) {
        guard !userId.isEmpty else {return}
        
        let db = Firestore.firestore()
        
        db.collection("Users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                DispatchQueue.main.async {
                    var updatedData: [String:Any] = [:]
                    
                    let currentUsername = data["Username"] as? String ?? ""
                    let currentPhoto = data["Image"] as? String ?? ""
                    
                    if newUsername != self.username && !newUsername.isEmpty {
                        updatedData["Username"] = newUsername
                    } else {
                        self.username = currentUsername
                    }

                    if newImageUrl != self.imageUrl && !newImageUrl.isEmpty {
                        updatedData["Image"] = newImageUrl
                    } else {
                        self.imageUrl = currentPhoto
                    }
                    
                    guard !updatedData.isEmpty else {
                        return
                    }
                    
                    db.collection("Users").document(self.userId).updateData(updatedData) { error in
                        if let error = error {
                            self.errorMessage = error.localizedDescription
                            print("Could not update the user data: \(error.localizedDescription)")
                        } else {
                            self.username = updatedData["Username"] as? String ?? ""
                            self.imageUrl = updatedData["Image"] as? String ?? ""
                            self.isUpdated = true
                            print("User data updated successfully!")
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription ?? "Failed to load user data"
                    print(self.errorMessage ?? "Error fetching user data")
                }
            }
        }
    }

}
