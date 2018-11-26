//
//  FeedSubscriptionItem.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import Foundation
class FeedSubscriptionItem {
    let name : String
    let url: String
    var status : String
    var newItemsCount : Int
    
    init(_ name: String, url: String){
        self.name = name
        self.url = url
        self.status = ""
        self.newItemsCount = 0
    }
}
