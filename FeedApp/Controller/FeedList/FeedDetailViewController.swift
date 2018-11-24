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

class FeedDetailViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    var myFeedItem : FeedItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    
        
        self.myWebView.scrollView.delegate = self
        self.myWebView.loadHTMLString(FeedDetailViewController.parseHtml(myFeedItem?.html) , baseURL: nil)
        rotated()
    }

    private static func parseHtml(_ input: String?) -> String{

        var html = "<head><style>* { font-family: Optima-Regular; text-align: justify; } h1 { text-align: left; } </style>"
        html += "<meta name='viewport' content='initial-scale=1.0'/></head><body>"
        html += input ?? ""
    
        html += "</body>"
        
        return html
    }
    
    
    @objc func rotated() {
 
        let screenSize = UIScreen.main.bounds
        var screenWidth = screenSize.width - 16

        if UIDevice.current.orientation.isLandscape {
            screenWidth -= 16
            //print("Landscape")
        } else {
            //print("Portrait")
        }
        
       
        //print("Size: ", screenWidth)
        self.myWebView.evaluateJavaScript("var maxWidth = '\(screenWidth)px'; document.querySelector('img').style.width=maxWidth;",completionHandler: nil)
        
    }

    func viewWillTransition(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(in: view, animation: nil) { (UIViewControllerTransitionCoordinatorContext) in
           

            
            self.myWebView.loadHTMLString(FeedDetailViewController.parseHtml(self.myFeedItem?.html) , baseURL: nil)

            
        }
    }
}

extension FeedDetailViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = true
    }
}
