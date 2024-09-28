//
//  NavView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/8/24.
//

import SwiftUI

struct NavView: View {
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 500, height: 80)
                .foregroundColor(.black).opacity(0.7)
                .shadow(color: .cyan ,radius: 5)
            VStack {
                HStack(spacing: 80) {
                    NavigationLink(destination: Search()) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    
                    Image(systemName: "pencil.tip.crop.circle.fill")
                        .resizable()
                        .frame(width: 37, height: 37)
                        .foregroundColor(.white)
                    
                    NavigationLink(destination: Profile()) {
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        Spacer()
    }
}

#Preview {
    NavView()
}
