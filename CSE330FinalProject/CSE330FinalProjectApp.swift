//
//  CSE330FinalProjectApp.swift
//  CSE330FinalProject
//
//  Created by Ibrahim Mousa on 11/10/22.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseDatabase


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
}

@main
struct CSE330FinalProjectApp: App {
    
//    var tempClassList: [String] = []
    
    init() {
//        var classList2: [String] = []
        FirebaseApp.configure()
//        var database = Database.database().reference()
        
        
//        database.child("TheWatchlist").getData { (error, snapshot) in
//            for childSnapshot in snapshot!.children.allObjects as! [DataSnapshot] {
////                print(childSnapshot.key) // prints the key of each user
////                print(childSnapshot.value!) // prints the userName property
//                classList2.append(childSnapshot.value as! String)
//            }
//        }
//        self.tempClassList = classList2
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

