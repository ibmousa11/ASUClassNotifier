//
//  ContentView.swift
//  CSE330FinalProject
//
//  Created by Ibrahim Mousa on 11/10/22.
//

import SwiftUI
import SwiftSoup
import HTMLKit
import WebKit
import FirebaseCore
import FirebaseDatabase
import Firebase

struct ContentView: View {
    @State var webView = WKWebView()
    @State var classList: [String] = ["first"]
    @State private var classNo: String = ""
    @State var seatsOpen: String = "NA"
    @State private var showAlert = false
    @State private var showAlreadyAddedAlert = false
    var database = Database.database().reference()
    var body: some View {
        VStack{
            Spacer()
            TextField("Enter the Class Number", text: $classNo).multilineTextAlignment(.center)
            Button(action: {
                addClass(webView: webView, classNo: classNo, classList: classList) {(temp, classList) in
                    self.seatsOpen = temp
                    var example = ["hello", "mmy", "name"]
                    if Int(temp) == 0 && !self.classList.contains(classNo){
                        self.classList.append(classNo)  //adding the class to the watchlist array if there are zero seats available and does not already exist in the array
                        //self.database.child("TheWatchlist").setValue(classNo)       //updating the array in firebase
                        //self.database.child("Example").setValue(example)
                    }
                    else if Int(temp)! > 0
                    {
                        showAlert = true;       //shows alert if there open seats in the class
                    }
                    else if self.classList.contains(classNo)
                    {
                        showAlreadyAddedAlert = true    //shows alert if class has already been added to the watchlist array
                    }
                    
                    print(self.classList)
                }
                self.seatsOpen = "Loading..."
                print("There are " + self.seatsOpen + " seats open")
            }) {
                Text("Add to Watchlist")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
            }.alert("Class Already Has Open Seats", isPresented: $showAlert) {}.alert("Class Has Already Been Added To Watchlist", isPresented: $showAlreadyAddedAlert) {}
            
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    func addClass (webView: WKWebView, classNo: String, classList: [String], completion: @escaping (String, [String]) -> Void)
    {
        
        var temp = ""
        print(classNo)
        let urlString = "https://catalog.apps.asu.edu/catalog/classes/classlist?campusOrOnlineSelection=C&honors=F&keywords=\(classNo)&promod=F&searchType=all&term=2231"
        let url = URL(string: urlString)
        print(urlString)
        webView.load(URLRequest(url: url!))
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                       completionHandler: { (html: Any?, error: Error?) in
                
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
                    completion(temp, classList)
                    
                }
                
                catch {}
            })
        }
    }
}
