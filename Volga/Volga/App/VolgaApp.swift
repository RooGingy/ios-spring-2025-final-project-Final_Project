//
//  VolgaApp.swift
//  Volga
//
//  Created by Austin Moser on 3/31/25.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct VolgaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // ✅ Track the current signed-in user
    @StateObject private var currentUser = CurrentUserManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(currentUser) // ✅ Inject it into the whole app
                .preferredColorScheme(.light)
        }
    }
}
