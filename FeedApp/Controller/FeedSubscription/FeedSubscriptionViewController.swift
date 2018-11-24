//
//  FeedSubscriptionViewController.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import UIKit

class FeedSubscriptionViewController: UIViewController {
    
    @IBOutlet weak var myTable: UITableView!
    
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
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FeedSubscriptionRepository.singleton.feedSubscriptions.count
    }
    
}
