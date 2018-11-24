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

    var items: [FeedItem] = []

    @IBOutlet weak var myTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FeedsClient.singleton.subscribe(self)
        
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
        }
    }
   
}

extension FeedsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedResumedViewCell") as! FeedsResumedTableViewCell
        let feedItem = self.items[indexPath.row]
        
        cell.myTitle.text = feedItem.title
        cell.myText.text = feedItem.firstParagraph 
        cell.myImage.image = feedItem.imageUI
    
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
    
}

extension FeedsViewController: FeedsClientSubscriber{
    func notify(_ newItem: FeedItem) {
        items.append(newItem)
        myTable.beginUpdates()
        myTable.insertRows(at: [NSIndexPath(row: items.count-1, section: 0) as IndexPath],
                           with: .automatic)
        myTable.endUpdates()
    }
}

/*
 let item = items[0]
 let title = item.title ?? ""
 var html = "<head><style>* { max-width:  320px; font-family: Optima-Regular; text-align: justify; } h1 { text-align: left; } </style>"
 html += "<meta name='viewport' content='initial-scale=1.0'/></head><body>"
 html += "<h1>\(title)</h1>"
 html += item.description ?? ""
 html += "</body>"
 */
