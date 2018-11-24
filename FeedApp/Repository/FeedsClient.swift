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

    let feedURL = URL(string: "http://feeds.weblogssl.com/xataka2")!
    var items: [RSSFeedItem] = []
    var subscribers: [FeedsClientSubscriber] = []
    
    init(){
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
                
                for item in items {
                    self.notifySubscribers(item)
                }
                
               
               
            }
        }
    }
    
    func subscribe(_ subsriber: FeedsClientSubscriber){
        self.subscribers.append(subsriber)
    }
    
    private func notifySubscribers(_ item: RSSFeedItem){
        for subscriber in self.subscribers{
            subscriber.notify(FeedItem(item))
        }
    }
    
   

}
