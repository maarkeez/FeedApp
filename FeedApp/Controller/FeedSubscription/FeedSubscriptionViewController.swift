//
//  FeedSubscriptionViewController.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import UIKit
import WebKit

class FeedSubscriptionViewController: UIViewController, FeedsClientSubscriber {
    @IBOutlet weak var myLoadAllItem: UIBarButtonItem!
    
    @IBOutlet weak var myTable: UITableView!
    
    var nextLoadIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recalculateNumberOfUnreadedItems()
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
    }
    
    @IBAction func doLoadAll(_ sender: Any) {
        myLoadAllItem.isEnabled = false
        
        nextLoadIndex = -1
        changeAllSubscriptionStatus()
        loadNext()
    }
    
    
}
// MARK: - Fetch number of unreaded items
extension FeedSubscriptionViewController{
    
    func recalculateNumberOfUnreadedItems(){
        DispatchQueue.global(qos: .default).async {
            // ... backgournd thread
            for subscriptionItem in FeedSubscriptionRepository.singleton.feedSubscriptions {
                subscriptionItem.unreadedItems = FeedItemRepository.singleton.count(subscriptionItem.name, readed: false)
                print("Unreaded: " , subscriptionItem.unreadedItems)
            }
            
            DispatchQueue.main.async {
                self.myTable.reloadData()
            }
        }
    }
    
}


// MARK: - Fetch new data
extension FeedSubscriptionViewController{
    
    func changeAllSubscriptionStatus(){
        // Change all subscription status
        for index in 0..<FeedSubscriptionRepository.singleton.feedSubscriptions.count {
            FeedSubscriptionRepository.singleton.feedSubscriptions[index].status = "Loading ..."
        }
        self.myTable.reloadData()
    }
    
    func loadNext(){
        nextLoadIndex += 1
        if(nextLoadIndex<FeedSubscriptionRepository.singleton.feedSubscriptions.count){
            FeedsClient.singleton.restart(self, feedSubscription: FeedSubscriptionRepository.singleton.feedSubscriptions[nextLoadIndex])
        }else{
            myLoadAllItem.isEnabled = true
        }
        
    }
    
    func notifyEndFeed(_ feedSubscription: FeedSubscriptionItem) {
        
        // Change all subscription status
        var indexPathsToBeReloaded : [IndexPath] = []
        for index in 0..<FeedSubscriptionRepository.singleton.feedSubscriptions.count {
            let subscriptionItem = FeedSubscriptionRepository.singleton.feedSubscriptions[index]
            if subscriptionItem.name == feedSubscription.name {
                FeedSubscriptionRepository.singleton.feedSubscriptions[index].status = "Load finished!"
                FeedSubscriptionRepository.singleton.feedSubscriptions[index].unreadedItems = feedSubscription.unreadedItems
                print("Load finished for: ", feedSubscription.name)
                indexPathsToBeReloaded.append(IndexPath(row: index, section: 0))
            }
        }
        
        reloadRows(indexPathsToBeReloaded)
        loadNext()
        
    }
    
    func reloadRows(_ indexPathsToBeReloaded : [IndexPath]){
        self.myTable.beginUpdates()
        self.myTable.reloadRows(at: indexPathsToBeReloaded, with: .none)
        self.myTable.endUpdates()
    }
    
}


// MARK: - Navigation
extension FeedSubscriptionViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "FeedsViewSegue", let destination = segue.destination as? FeedsViewController,
            let itemIndex = myTable.indexPathForSelectedRow?.row
        {
            destination.myFeedSubscription = FeedSubscriptionRepository.singleton.feedSubscriptions[itemIndex]
        }
    }
}



// MARK: - Table
extension FeedSubscriptionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedSubscriptionCell") as! FeedSubscriptionCell
        
        let item = FeedSubscriptionRepository.singleton.feedSubscriptions[indexPath.row]
        
        cell.myLabel.text = item.name
        cell.myStatus.text = item.status
        cell.myUnreaded.text = "\(item.unreadedItems)"
        cell.myUnreaded.layer.cornerRadius =  cell.myUnreaded.frame.size.width/2
        cell.myUnreaded.layer.masksToBounds = true
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedSubscriptionRepository.singleton.feedSubscriptions.count
    }
    
}
