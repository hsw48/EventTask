//
//  UnclaimedTableViewCell.swift
//  EventTask
//
//  Created by Julia Woodward on 7/25/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UnclaimedTableViewCell: UITableViewCell {
    
    var taskId : String?
 //   var taskRef : FIRDatabaseReference! = nil

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var claimButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}