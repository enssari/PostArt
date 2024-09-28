//
//  PostArtApp.swift
//  PostArt
//
//  Created by Enes Sarı on 9/6/24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct PostArtApp: App {
    @AppStorage("uid") var userId = ""
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if userId.isEmpty {
                LoginView()
            } else {
                ContentView()
            }
        }
    }
}
