//
//  EditProfileView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/11/24.
//

import SwiftUI

struct EditProfileView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    @State private var changePhotoClicked = false
    @State private var changeUsernameClicked = false
    @State private var newImageUrl: String = ""
    @State private var newUsername: String = ""
    @State private var saveClicked: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    
                } label: {
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
                }
                .padding(.bottom)
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                
                if changePhotoClicked == false {
                    Button {
                        withAnimation(.smooth) {
                            changePhotoClicked.toggle()
                        }
                    } label: {
                        Text("Change profile photo")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                    }
                    .frame(width: 200, height: 30)
                    .background(Color("lightGray"))
                    .cornerRadius(5)
                } else {
                    TextField("Enter the new image url", text: $newImageUrl)
                        .padding()
                        .frame(width: 365, height: 40)
                        .foregroundColor(.white)
                        .background(.gray).opacity(0.7)
                        .autocapitalization(.none)
                        .cornerRadius(10)
                }
                
                HStack {
                    if changeUsernameClicked == false {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .foregroundColor(.gray).opacity(0.7)
                                .frame(width: 330, height: 40)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .cornerRadius(10)
                            
                            Text("Enes")
                                .padding(.leading)
                                .fontWeight(.semibold)
                        }
                    } else {
                        TextField("Enter username", text: $newUsername)
                            .padding()
                            .frame(width: 330, height: 40)
                            .foregroundColor(.white)
                            .background(.gray).opacity(0.7)
                            .autocapitalization(.none)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        withAnimation(.interactiveSpring(duration: 0.5)) {
                            changeUsernameClicked.toggle()
                        }
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top)
                
                Button {
                    authViewModel.updateData(newUsername: newUsername, newImageUrl: newImageUrl)
                    saveClicked.toggle()
                } label: {
                     Text("Save changes")
                        .foregroundColor(.white)
                }
                .frame(width: 150, height: 40)
                .background(.blue)
                .cornerRadius(5)
                .padding(.top)
            }
            .navigationDestination(isPresented: $saveClicked) {
                EditProfileView()
            }
            .onAppear {
                authViewModel.fetchUserData()
                
                newUsername = authViewModel.username
                newImageUrl = authViewModel.imageUrl
            }
            .padding(.top, 50)
            Spacer()
            .navigationTitle("Edit Profile")
        }
    }
}

#Preview {
    EditProfileView()
}
