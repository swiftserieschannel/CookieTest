//
//  ViewController.swift
//  CookieTest
//
//  Created by Chandra Bhushan on 24/07/20.
//  Copyright © 2020 Swift Series. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController {
    var webView:WKWebView!
    var customRequest: URLRequest!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "https://awein.000webhostapp.com/cookiestest.php")!
        self.customRequest = URLRequest(url: url)
        
        addWebView()
    }
    
    private func addWebView(){
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let cookie = HTTPCookie(properties: [
            .domain: "awein.000webhostapp.com",
            .path: "/",
            .name: "test",
            .value: "value",
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 3600)
        ])
        
        //Makes sure the cookie is set before instantiating the webview and initiating the request
        if let myCookie = cookie {
            WKWebViewConfiguration.includeCookie(cookie: myCookie, preferences: preferences, completion: {
                [weak self] config in
                if let `self` = self {
                    if let configuration = config {
                        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: self.view.frame.height), configuration: configuration)
                        
                        self.view.addSubview(self.webView)
                        self.webView.load(self.customRequest)
                        self.webView.allowsBackForwardNavigationGestures = true
                    }
                }
            })
        }
    }
}

extension WKWebViewConfiguration {
    
    static func includeCookie(cookie:HTTPCookie, preferences:WKPreferences, completion: @escaping (WKWebViewConfiguration?) -> Void) {
        let config = WKWebViewConfiguration()
        config.preferences = preferences
        
        let dataStore = WKWebsiteDataStore.nonPersistent()
        
        DispatchQueue.main.async {
            let waitGroup = DispatchGroup()
            
            waitGroup.enter()
            dataStore.httpCookieStore.setCookie(cookie) {
                waitGroup.leave()
            }
            
            waitGroup.notify(queue: DispatchQueue.main) {
                config.websiteDataStore = dataStore
                completion(config)
            }
        }
    }
}
