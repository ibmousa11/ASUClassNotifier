//
//  CSE330FinalProjectApp.swift
//  CSE330FinalProject
//
//  Created by Ibrahim Mousa on 11/10/22.
//

import SwiftUI
import FirebaseCore
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()

    return true
  }
}

@main
struct CSE330FinalProjectApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

