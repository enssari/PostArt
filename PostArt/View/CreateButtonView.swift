//
//  CreateButtonView.swift
//  PostArt
//
//  Created by Enes Sarı on 9/12/24.
//

import SwiftUI

struct CreateButtonView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.linearGradient(colors: [Color("gradientStart"), Color("gradientEnd")],  startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 60, height: 60)
                .cornerRadius(10)
                .shadow(color: .secondary, radius: 3)
            
            Rectangle()
                .clipShape(Circle())
                .frame(width: 55, height: 55)
                .foregroundColor(.black).opacity(0.8)
            
            Image(systemName: "plus")
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    CreateButtonView()
}
