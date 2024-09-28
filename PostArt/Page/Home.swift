//
//  Home.swift
//  PostArt
//
//  Created by Enes Sarı on 9/8/24.
//

import SwiftUI

struct Home: View {    
    var body: some View {
        NavigationStack {
            VStack {
                NavView()
                PostView()
                NavigationLink(destination: CreatePostView()) {
                    CreateButtonView()
                }
            }
            .background(.black)
        }
    }
}

#Preview {
    Home()
}
