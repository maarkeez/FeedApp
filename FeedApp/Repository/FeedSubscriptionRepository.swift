//
//  FeedSubscriptionRepository.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import Foundation

class FeedSubscriptionRepository {

    static let singleton  = FeedSubscriptionRepository()

    var feedSubscriptions : [FeedSubscriptionItem] = []
    
    init(){
        feedSubscriptions.append(FeedSubscriptionItem("Xataka", url: "http://feeds.weblogssl.com/xataka2"))
        feedSubscriptions.append(FeedSubscriptionItem("Cuanta razón", url: "http://feeds.feedburner.com/cuantarazon"))
        feedSubscriptions.append(FeedSubscriptionItem("Visto en las redes", url: "http://feeds.feedburner.com/VistoEnFacebook"))
        feedSubscriptions.append(FeedSubscriptionItem("Genbeta", url: "http://feeds.weblogssl.com/genbeta"))
        feedSubscriptions.append(FeedSubscriptionItem("FayerWayer", url: "https://feeds.feedburner.com/fayerwayer"))
    }
}
