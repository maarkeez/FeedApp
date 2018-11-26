//
//  FeedsViewController.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import UIKit
import FeedKit

class FeedsViewController: UIViewController {
    
    @IBOutlet weak var myCountItem: UIBarButtonItem!
    
    var myFeedSubscription : FeedSubscriptionItem?
    var items: [FeedItem] = []

    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            for item in FeedItemRepository.singleton.list(subscriptionType:  self.myFeedSubscription!.name){
                DispatchQueue.main.async {
                    self.notify(item)
                }
            }
        }
    
        self.myTable.delegate = self
        self.myTable.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    

    
       // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "FeedDetailSegue", let destination = segue.destination as? FeedDetailViewController,
            let itemIndex = myTable.indexPathForSelectedRow?.row
        {
            destination.myFeedItem = self.items[itemIndex]
            self.items[itemIndex].readed = true
            self.myFeedSubscription?.unreadedItems -= 1
            reloadItemCountLabel()
            DispatchQueue.global(qos: .default).async {
                FeedItemRepository.singleton.update(self.items[itemIndex], subscriptionType: self.myFeedSubscription!.name, readed: true)
            }
        }
    }
   
}

extension FeedsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsResumedTableViewCell") as! FeedsResumedTableViewCell
        let feedItem = self.items[indexPath.row]
        
        cell.myTitle.text = feedItem.title
        cell.myText.text = feedItem.firstParagraph 
        cell.myImage.image = feedItem.imageUI
        
        if (feedItem.readed ){
            cell.myTitle.textColor = UIColor.lightGray
        }else{
            cell.myTitle.textColor = UIColor.black
        }
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func notify(_ newItem: FeedItem) {
        items.append(newItem)
        myTable.beginUpdates()
        myTable.insertRows(at: [NSIndexPath(row: items.count-1, section: 0) as IndexPath],
                           with: .automatic)
        myTable.endUpdates()
        reloadItemCountLabel()
    }
    
    func reloadItemCountLabel(){
        if let feedSubscription = myFeedSubscription {
            myCountItem.title = "\(feedSubscription.unreadedItems) / \(items.count)"
        }else{
            myCountItem.title = "\(items.count)"
        }
    }
}
