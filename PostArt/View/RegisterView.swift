//
//  RegisterView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/6/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    @State private var registerClicked: Bool = false
    @State private var emailError: String?
    
    var isEmailValid: Bool {
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: authViewModel.email)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("art")
                    .resizable()
                    .frame(height: UIScreen.main.bounds.height)
                    .aspectRatio(contentMode: .fit)
                
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 20) {
                        TextField("Username", text: $authViewModel.username)
                            .padding()
                            .foregroundColor(.white)
                            .background(.gray).opacity(0.7)
                            .autocapitalization(.none)
                            .cornerRadius(10)
                        
                        TextField("Enter your email", text: $authViewModel.email)
                            .padding()
                            .foregroundColor(.white)
                            .background( .gray).opacity(0.7)
                            .autocapitalization(.none)
                            .cornerRadius(10)
                            .onChange(of: authViewModel.email) {
                                emailError = isEmailValid ? nil : "Invalid email format"
                                }

                                if let error = emailError {
                                    Text(error)
                                        .padding(.leading)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                        
                        SecureField("Password", text: $authViewModel.password)
                            .padding()
                            .foregroundColor(.white)
                            .background(.gray).opacity(0.7)
                            .autocapitalization(.none)
                            .cornerRadius(10)
                        
                        TextField("Profile image URL", text: $authViewModel.imageUrl)
                            .padding()
                            .foregroundColor(.white)
                            .background(.gray).opacity(0.7)
                            .autocapitalization(.none)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        authViewModel.register()
                        registerClicked.toggle()
                        }) {
                            Text("Register")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                    }
                        .alert("Registered Succesfully!", isPresented: $registerClicked) {
                            Button("OK", role: .cancel) { }
                        }
                }
                .padding()
                .padding(.top, 150)
                .navigationTitle("Register")
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    RegisterView()
}
