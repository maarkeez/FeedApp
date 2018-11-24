//
//  ScreenUtils.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import UIKit

class ScreenUtils{
    static func getScreenWidth() -> CGFloat {
        
        let screenSize = UIScreen.main.bounds
        var screenWidth = screenSize.width - 16
        
        if UIDevice.current.orientation.isLandscape {
            screenWidth -= 16
        }
        
        return screenWidth
    }
    
}
