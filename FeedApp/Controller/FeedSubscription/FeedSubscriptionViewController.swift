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
    
    @IBAction func doLoadAll(_ sender: Any) {
        myLoadAllItem.isEnabled = false
        
        nextLoadIndex = -1
        // Change all subscription status
        for index in 0..<FeedSubscriptionRepository.singleton.feedSubscriptions.count {
            let cell = myTable.cellForRow(at: IndexPath(item: index, section: 0)) as? FeedSubscriptionCell
            cell?.myStatus.text = "Loading ..."
        }
        
        // Load each subscription feeds asynchronusly
        loadNext()
    }
    
    
    func notifyEndFeed(_ feedSubscription: FeedSubscriptionItem) {
       
        // Change all subscription status
        for index in 0..<FeedSubscriptionRepository.singleton.feedSubscriptions.count {
            let cell = myTable.cellForRow(at: IndexPath(item: index, section: 0)) as? FeedSubscriptionCell
            if cell?.myLabel.text == feedSubscription.name {
                cell?.myStatus.text = "Load finished!"
                print("Load finished for: ", feedSubscription.name)
            }
        }
        
        
        loadNext()
        
    }
    
    func loadNext(){
        nextLoadIndex += 1
        if(nextLoadIndex<FeedSubscriptionRepository.singleton.feedSubscriptions.count){
            FeedsClient.singleton.restart(self, feedSubscription: FeedSubscriptionRepository.singleton.feedSubscriptions[nextLoadIndex])
        }else{
            myLoadAllItem.isEnabled = true
        }
            
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTable.delegate = self
        self.myTable.dataSource = self
    }
    
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


extension FeedSubscriptionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedSubscriptionCell") as! FeedSubscriptionCell
        
        let item = FeedSubscriptionRepository.singleton.feedSubscriptions[indexPath.row]
        
        cell.myLabel.text = item.name
        cell.myStatus.text = ""
        
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
