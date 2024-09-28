//
//  LoginView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/6/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    @State private var emailError: String?
    
    var isEmailValid: Bool {
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: authViewModel.email)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("art")
                    .resizable()
                    .frame(height: UIScreen.main.bounds.height)
                    .aspectRatio(contentMode: .fit)

                VStack(spacing: 30) {
                    VStack(alignment: .leading) {
                        TextField("Enter your email", text: $authViewModel.email)
                            .padding()
                            .foregroundColor(.white)
                            .background(.gray).opacity(0.7)
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
                    }
                    
                    Button {
                        authViewModel.login()
                    } label: {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 100, height: 20)
                    .padding()
                    .background(.green)
                    .cornerRadius(5)
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Don't have an account?")
                            .fontWeight(.semibold)
                    }
                }
                .accentColor(.blue)
                .padding()
                .navigationTitle("Login")
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LoginView()
}
