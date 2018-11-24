//
//  FeedsClient.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import Foundation
import FeedKit
import Kanna

protocol FeedsClientSubscriber {
    func notify(_ newItem : FeedItem)
}

class FeedsClient {
    
    static let singleton = FeedsClient()

    var feedURL: URL?
//    let feedURL = URL(string: "http://feeds.feedburner.com/cuantarazon")!
    
    var items: [RSSFeedItem] = []
    var subscriber: FeedsClientSubscriber?
    var parser : FeedParser?
    
    func restart(_ subscriber: FeedsClientSubscriber, feedSubscription: FeedSubscriptionItem){
        
        self.subscriber = subscriber
        
        let parser = FeedParser(URL: URL(string: feedSubscription.url)!) // or FeedParser(data: data) or FeedParser(xmlStream: stream)
        
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
                
                for item in items {
                    self.subscriber?.notify(FeedItem(item))
                }
                
            }
        }
    }

}
