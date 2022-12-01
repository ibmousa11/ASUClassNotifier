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
    
    let notify = NotificationHandler()
    
//    var tempClassList: [String] = []
    
    init() {
//        var classList2: [String] = []
        FirebaseApp.configure()
        notify.askPermission()
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
    
    @Environment(\.scenePhase) private var phase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.onChange(of: phase) { newPhase in
            switch newPhase {
            case .background: scheduleAppRefresh()
            default: break
            }
        }
        
        
        .backgroundTask(.appRefresh("ClassChecker")){
            
            //TODO isSeatOpen & notifyClassAvailibility()
            isSeatOpen()
                

            }
        }
    
}

func scheduleAppRefresh(){

    let request = BGAppRefreshTaskRequest(identifier: "ClassChecker")
    request.earliestBeginDate = .now.addingTimeInterval(24 * 3600)
    try? BGTaskScheduler.shared.submit(request)

}


func isSeatOpen() {
    
    print("isSeatOpen() called")
    
    var arr = UserDefaults.standard.array(forKey: "classList")as! [String]
    
    let x = ContentView()
    x.checkClassArray(theList: UserDefaults.standard.array(forKey: "classlist")as! [String])
    DispatchQueue.main.asyncAfter(deadline: .now() + Double(arr.count)*6.0) {
        if(x.checkArray.count>0){
            
//            notify.sendNotification(number: x.checkArray[0])
            CSE330FinalProjectApp().notify.sendNotification(number: x.checkArray[0])

        }
    }
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
