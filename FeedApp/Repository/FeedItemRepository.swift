//
//  FeedItemRepository.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import UIKit
import CoreData

class FeedItemRepository {
    static let singleton = FeedItemRepository()
    var ctx : NSManagedObjectContext?
    
    init(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("ERROR: Could not find app-delegate")
            return
        }
        ctx = appDelegate.persistentContainer.viewContext

    }
  
    
    func add(_ subscriptionType: String, items: [FeedItem]) -> [FeedItem]{
        
        var toReturn : [FeedItem] = []
        
        // To always return in the same order: insertDate DESC
        let itemsReversed = items.reversed()
        
        

        do{
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Feed")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "insertDate", ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "subscriptionType == %@", subscriptionType)
            let feeds = try ctx!.fetch(fetchRequest) as! [Feed]
            var feedIds :[String] = []
            
            for feed in feeds{
                feedIds.append(feed.id!)
            }
            
           
        for item in itemsReversed {
            if(feedIds.contains(item.idHash)){
                continue
            }
            let feedItem = Feed(context: ctx!)
            updateMO(item, feedItem: feedItem, subscriptionType: subscriptionType)
            toReturn.append(item)
            feedItem.insertDate = Date()
           
            //NSManagedObject(entity: feedEntity!, insertInto: ctx)
            /*
            feedItem.setValue(subscriptionType, forKey: "subscription")
            feedItem.setValue(item.idHash, forKeyPath: "id")
            feedItem.setValue(item.firstParagraph, forKey: "firstParagraph")
            feedItem.setValue(item.html, forKey: "html")
            feedItem.setValue(item.imageSrc, forKey: "imageSrc")
            feedItem.setValue(item.title, forKey: "title")
            feedItem.setValue(item.readed, forKey: "readed")
 */
        }
        
       
            try ctx!.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return toReturn.reversed()
    }
    
    private func updateMO(_ item: FeedItem, feedItem: Feed, subscriptionType: String) {
        feedItem.id = item.idHash
        feedItem.subscriptionType = subscriptionType
        feedItem.firstParagraph = item.firstParagraph
        feedItem.html = item.html
        feedItem.imageSrc = item.imageSrc
        if let imageUI = item.imageUI {
            feedItem.image = imageUI.pngData()
        }
        feedItem.title = item.title
        feedItem.readed = item.readed
    }
    
    func update(_ item: FeedItem, subscriptionType: String, readed: Bool){
        
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "insertDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND subscriptionType == %@", item.idHash, subscriptionType)
        do {
            
            let feeds = try ctx!.fetch(fetchRequest) as! [Feed]
            for feed in feeds{
                updateMO(item, feedItem: feed, subscriptionType: subscriptionType)
            }
            
            try ctx!.save()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
      
    }
    
    func list(subscriptionType: String) -> [FeedItem] {
        var toRetun : [FeedItem] = []
        
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "insertDate", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "subscriptionType == %@ ", subscriptionType)
        do {
            
            let feeds = try ctx!.fetch(fetchRequest) as! [Feed]
            
            for feed in feeds{
                toRetun.append(FeedItem(feed))
            }
            
            try ctx!.save()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return toRetun
    }
    
   
}
