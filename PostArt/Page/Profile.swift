//
//  Profile.swift
//  PostArt
//
//  Created by Enes Sarı on 9/8/24.
//

import SwiftUI

struct Profile: View {
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    var body: some View {
        ProfileView()
    }
}

#Preview {
    Profile()
}
