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
import WebKit


protocol FeedsClientSubscriber {
    func notifyEndFeed(_ feedSubscription: FeedSubscriptionItem)
}


class FeedsClient {
    
    static let singleton = FeedsClient()
    
    var feedURL: URL?
    
    var items: [RSSFeedItem] = []
    var parser : FeedParser?
    
    func restart(_ subscriber: FeedsClientSubscriber, feedSubscription: FeedSubscriptionItem){
        print("Feed subscription: " , feedSubscription.name )
        do{
           
            let parser = FeedParser(URL: URL(string: feedSubscription.url)!) // or FeedParser(data: data) or FeedParser(xmlStream: stream)
            
            parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
                // Do your thing, then back to the Main thread
                DispatchQueue.global(qos: .default).async {
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
                    
                    var feedItems : [FeedItem] = []
                    for item in items {
                        feedItems.append(FeedItem(item, subscriptiontype: feedSubscription.name))
                    }
                    
                    let itemsAdded = FeedItemRepository.singleton.add(feedSubscription.name, items: feedItems)
                    print("Items added: ", itemsAdded.count)
                    
                    DispatchQueue.main.async {
                        subscriber.notifyEndFeed(feedSubscription)
                    }
                    print()
                }
            }
        } catch let error{
            print("EROR: Error in data download.")
            print(error.localizedDescription)
            DispatchQueue.main.async {
                subscriber.notifyEndFeed(feedSubscription)
            }
        }
    }
}
