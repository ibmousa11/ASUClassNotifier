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
    @State var classList: [String] = []
    @State private var classNo: String = ""
    @State var seatsOpen: String = "NA"
    @State private var showAlert = false
    @State private var showAlreadyAddedAlert = false
    @State var checkArray: [String] = []           //array that has the classes that changed status
    
    
    
    //    init(webView: WKWebView = WKWebView(), classList: [String], classNo: String, seatsOpen: String, showAlert: Bool = false, showAlreadyAddedAlert: Bool = false) {
    //        self.webView = webView
    //        self.classList = classList
    //        self.classNo = classNo
    //        self.seatsOpen = seatsOpen
    //        self.showAlert = showAlert
    //        self.showAlreadyAddedAlert = showAlreadyAddedAlert
    //        loadInFromFirebase()
    //    }
    var database = Database.database().reference()
    var body: some View {
        
        VStack{
            Text("Watchlist").font(.largeTitle.weight(.heavy))
            Spacer()
            List{
                ForEach(classList, id: \.self) { oneClass in
                    Text("\(oneClass)")
                }
            }
            
            Spacer()
            TextField("Enter the Class Number", text: $classNo).multilineTextAlignment(.center)
            Button(action: {
                addClass(webView: webView, classNo: classNo, classList: classList) {(temp, classList) in
                    self.seatsOpen = temp
                    if /*Int(temp) == 0 &&*/ !self.classList.contains(classNo){
                        self.classList.append(classNo)  //adding the class to the watchlist array if there are zero seats available and does not already exist in the array
                        self.database.child("TheWatchlist").setValue(self.classList)       //updating the array in firebase
                        print("Class List is: \(self.classList)")
                        self.classNo = ""
                    }
                    //                    else if Int(temp)! > 0
                    //                    {
                    //                        showAlert = true;       //shows alert if there open seats in the class
                    //                    }
                    else if self.classList.contains(classNo)
                    {
                        showAlreadyAddedAlert = true    //shows alert if class has already been added to the watchlist array
                    }
                    
                    print("Hello \(self.classList)")
                }
                
                self.seatsOpen = "Loading..."
                print("There are " + self.seatsOpen + " seats open")
            }) {
                Text("Add to Watchlist")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
            }.alert("Class \(self.classNo) Already Has Open Seats", isPresented: $showAlert) {}.alert("Class \(self.classNo) Has Already Been Added To Watchlist", isPresented: $showAlreadyAddedAlert) {}
            Button(action: {
                checkClassArray(theList: self.classList)
            }) {
                Text("Check Classes")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
            }
        }.onLoad{loadInFromFirebase()}
    }
    
    //    struct ContentView_Previews: PreviewProvider {
    //        static var previews: some View {
    //            ContentView()
    //        }
    //    }
    
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
    
    func checkClassArray(theList: [String]) {
        var timer: Double = 5
        
        
        theList.forEach { singleClass in
            checkClassArrayInner(classNumber: singleClass, webView: self.webView)
        }
        
    }
    
    func checkClassArrayInner(classNumber: String, webView: WKWebView) {
        
        print("ClassNumber is: \(classNumber)")
        let urlString = "https://catalog.apps.asu.edu/catalog/classes/classlist?campusOrOnlineSelection=C&honors=F&keywords=\(classNumber)&promod=F&searchType=all&term=2231"
        let url = URL(string: urlString)
        print(urlString)
        webView.load(URLRequest(url: url!))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            
            print("Hello we are here: \(url)")
            var temp = ""
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
                            temp = token[0]
                            print("Hello in: \(temp)")
                        }
                    }
                    print("Temp is " + temp)
                    print(classNumber)
                    if Int(temp)! > 0
                    {
                        self.checkArray.append(classNumber)
                    }
                    
                    print("Check Array is: \(self.checkArray)")
                    
                    
                    
                    
                }
                
                catch {}
            })
            
        }
        
        
        
        
    }
    
    
    func loadInFromFirebase(){
        
        database.child("TheWatchlist").getData { (error, snapshot) in
            for childSnapshot in snapshot!.children.allObjects as! [DataSnapshot] {
                //                print(childSnapshot.key) // prints the key of each user
                //                print(childSnapshot.value!) // prints the userName property
                self.classList.append(childSnapshot.value as! String)
            }
        }
        
        sleep(5)
        
        print("List in Loadin is: \(self.classList)")
    }
    
}

extension View {
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
    
}

struct ViewDidLoadModifier: ViewModifier {
    
    @State private var didLoad = false
    private let action: (() -> Void)?
    
    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
    
}

