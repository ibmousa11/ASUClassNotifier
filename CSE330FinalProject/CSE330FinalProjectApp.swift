//
//  CSE330FinalProjectApp.swift
//  CSE330FinalProject
//
//  Created by Ibrahim Mousa on 11/10/22.
//

import SwiftUI
import FirebaseCore
import Firebase
import BackgroundTasks
import SwiftSoup
import HTMLKit
import WebKit


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
        
        //comment
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
        .backgroundTask(.appRefresh("ClassChecker")){
            scheduleAppRefresh()
            //TODO isSeatOpen & notifyClassAvailibility()
            if await isSeatOpen(){
                //await notifyClassAvailability()
                //print("notification sent")
            }
        }
    }
}

func scheduleAppRefresh(){

    let request = BGAppRefreshTaskRequest(identifier: "ClassChecker")

}


func isSeatOpen() async -> Bool {

    var tempClassNumber = 13052
    var seats = "0"
    
    var arr = UserDefaults.standard.array(forKey: "classList")as! [String]
    
    let x = ContentView()
    x.checkClassArray(theList: UserDefaults.standard.array(forKey: "classlist")as! [String])
    DispatchQueue.main.asyncAfter(deadline: .now() + Double(arr.count)*6.0) {
        if(x.checkArray.count>0){
            
            //SEND NOTIFICATION HERE OR CALL IT
            
        }
    }
    
    
    //TODO figure out how to deal with returning a bool
    return false
}
/*
func notifyClassAvailability() async -> Void{
    var notify:UNNotificationRequest = nil
    do{
        try await UNUserNotificationCenter.current().add(notify)
    }catch{
        print("Error w/ notification")
    }
}
*/
