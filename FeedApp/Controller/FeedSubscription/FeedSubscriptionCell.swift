//
//  FeedSubscriptionCell.swift
//  FeedApp
//
//  Created by David Márquez Delgado on 24/11/2018.
//  Copyright © 2018 David Márquez Delgado. All rights reserved.
//

import UIKit

class FeedSubscriptionCell: UITableViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myStatus: UILabel!
    @IBOutlet weak var myUnreaded: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
