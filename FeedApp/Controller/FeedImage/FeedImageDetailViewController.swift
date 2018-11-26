//
//  FeedImageDetailViewController.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import UIKit

class FeedImageDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var myScroll: UIScrollView!
    
    @IBOutlet weak var myImage: UIImageView!
    
    var myImageUI : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myScroll.minimumZoomScale = 1.0
        self.myScroll.maximumZoomScale = 25.0
        
        if let imageUI = myImageUI{
            myImage.image = imageUI
        }
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return myImage
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
