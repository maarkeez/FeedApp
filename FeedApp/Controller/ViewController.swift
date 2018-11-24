//
//  ViewController.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import UIKit
import FeedKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    
    
    let feedURL = URL(string: "http://feeds.weblogssl.com/xataka2")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myWebView.scrollView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let parser = FeedParser(URL: feedURL) // or FeedParser(data: data) or FeedParser(xmlStream: stream)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // Do your thing, then back to the Main thread
            DispatchQueue.main.async {
                // ..and update the UI
                
                print("Result sucess: " , result.isSuccess )
                print("Result is failure: " , result.isFailure )
                guard let feed = result.rssFeed, result.isSuccess else {
                    print(result.error ?? "No error found")
                    return
                }
                
                print("Items count: " , feed.items?.count ?? 0 )
                
                guard let items = feed.items else {
                    print("No items found")
                    return
                }
                
                let item = items[0]
                let title = item.title ?? ""
                var html = "<head><style>* { max-width:  320px; font-family: Optima-Regular; text-align: justify; } h1 { text-align: left; } </style>" 
                html += "<meta name='viewport' content='initial-scale=1.0'/></head><body>"
                html += "<h1>\(title)</h1>"
                html += item.description ?? ""
                html += "</body>"
                
                self.myWebView.loadHTMLString(html , baseURL: nil)
                
            }
        }
    }


}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
