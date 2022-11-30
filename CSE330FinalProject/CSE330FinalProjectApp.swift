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
                await notifyClassAvailability()
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
    
    getClassSeats(classNo: 13052){(temp) in
        print(temp)
        
        
    }
    
    //TODO figure out how to deal with returning a bool
    return false
}

func notifyClassAvailability() async -> Void{
    
}


func getClassSeats(classNo: Int) async -> String{
    var webView = await WKWebView()
    var temp = ""
    print(classNo)
    let urlString = "https://catalog.apps.asu.edu/catalog/classes/classlist?campusOrOnlineSelection=C&honors=F&keywords=\(classNo)&promod=F&searchType=all&term=2231"
    let url = URL(string: urlString)
    print(urlString)
    await webView.load(URLRequest(url: url!))
    
    await (html, error) = webView.evaluateJavaScript("document.documentElement.outerHTML.toString()")
        
        var s = String(describing: html)
        let doc: Document = try! SwiftSoup.parse(s)
        do {
            var classArray = try doc.getElementsByClass("text-nowrap").array()
            
            for element in classArray {
                if(try element.text().contains("of"))
                {
                    var token = try element.text().components(separatedBy: " ")
                    print(token[0])
                    temp = token[0]                    }
            }
            print("Temp is " + temp)
            return temp
            
        }
        
        catch {}
    
}
