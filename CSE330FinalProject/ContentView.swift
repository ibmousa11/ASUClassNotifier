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

struct ContentView: View {
    @State var webView = WKWebView()
    @State private var classNo: String = ""
    @State var seatsOpen: String = "NA"
    var body: some View {
        VStack{
            TextField("Enter the Class Number", text: $classNo )
            Button(action: {
                searchClass(webView: webView, classNo: classNo) {temp in
                    self.seatsOpen = temp
                }
                self.seatsOpen = "Loading..."
                print("There are " + self.seatsOpen + " seats open")
            }) {
                Text("Hello There")
            }
            Text("Seats Open")
            Text(seatsOpen)
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func searchClass (webView: WKWebView, classNo: String, completion: @escaping (String) -> Void)
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
                completion(temp)
                
            }
            
            catch {}
        })
    }
//        print("Temp2 is " + temp)
}
