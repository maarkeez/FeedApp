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
        var feedSubscriptions : [FeedSubscriptionItem] = []
        feedSubscriptions.append(FeedSubscriptionItem("Xataka", url: "http://feeds.weblogssl.com/xataka2"))
        feedSubscriptions.append(FeedSubscriptionItem("Cuanta razón", url: "http://feeds.feedburner.com/cuantarazon"))
        feedSubscriptions.append(FeedSubscriptionItem("Visto en las redes", url: "http://feeds.feedburner.com/VistoEnFacebook"))
        feedSubscriptions.append(FeedSubscriptionItem("Genbeta", url: "http://feeds.weblogssl.com/genbeta"))
        feedSubscriptions.append(FeedSubscriptionItem("FayerWayer", url: "https://feeds.feedburner.com/fayerwayer"))
        
        feedSubscriptions.append(FeedSubscriptionItem("20 minutos", url: "https://www.20minutos.es/rss/"))
        feedSubscriptions.append(FeedSubscriptionItem("Applesfera", url: "http://feeds.weblogssl.com/applesfera"))
        feedSubscriptions.append(FeedSubscriptionItem("Todo Iphone", url: "http://feedpress.me/todoiphone"))
        feedSubscriptions.append(FeedSubscriptionItem("DZone", url: "http://feeds.dzone.com/publications"))
        feedSubscriptions.append(FeedSubscriptionItem("Xataka Android", url: "http://feeds.weblogssl.com/xatakandroid"))
        feedSubscriptions.append(FeedSubscriptionItem("Microsiervos", url: "https://www.microsiervos.com/index.xml"))
        
        feedSubscriptions.append(FeedSubscriptionItem("Asco de vida", url: "http://feeds2.feedburner.com/AscoDeVida"))
        feedSubscriptions.append(FeedSubscriptionItem("Desmotivaciones", url: "https://desmotivaciones.es/rss.xml"))
        
        feedSubscriptions.append(FeedSubscriptionItem("Abc futbol", url: "https://www.abc.es/rss/feeds/abc_Futbol.xml"))

       

        feedSubscriptions.sort { $0.name < $1.name }
        self.feedSubscriptions = feedSubscriptions
    }
}
