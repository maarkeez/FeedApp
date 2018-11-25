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

class FeedDetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var myWebView: WKWebView!
    var myFeedItem : FeedItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(recalculateImageWidth), name: UIDevice.orientationDidChangeNotification, object: nil)
    
        self.myWebView.navigationDelegate = self
        self.myWebView.scrollView.delegate = self
        self.myWebView.loadHTMLString(parseHtml(myFeedItem?.html) , baseURL: nil)

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.recalculateImageWidth()
    }

    private func parseHtml(_ input: String?) -> String{
        var html = "<head><style>* { font-family: Optima-Regular; text-align: justify; } h1 { text-align: left; } </style>"
        html += "<meta name='viewport' content='initial-scale=1.0' width='device-width'/></head><body>"
        
        if let feedItem = myFeedItem {
            html += "<h1>\(feedItem.title)</h1>"
        }
        
        html += input ?? ""
    
        html += "</body>"
        
        return html
    }
    
   
    @objc func recalculateImageWidth() {
 
        self.myWebView.evaluateJavaScript("var maxWidth = '\(ScreenUtils.getScreenWidth())px'; document.querySelector('img').style.width=maxWidth; document.querySelector('img').style.maxWidth=maxWidth; document.querySelector('img').style.minWidth=maxWidth;",completionHandler: nil)
        
    }

    func viewWillTransition(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: view, animation: nil) { (UIViewControllerTransitionCoordinatorContext) in
        
            self.myWebView.loadHTMLString(self.parseHtml(self.myFeedItem?.html) , baseURL: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FeedImageDetailSegue", let destination = segue.destination as? FeedImageDetailViewController {
            destination.myImageUI = myFeedItem?.imageUI
        }
    }
}

extension FeedDetailViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = true
    }
}
