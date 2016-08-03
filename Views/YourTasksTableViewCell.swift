//
//  YourTasksTableViewCell.swift
//  EventTask
//
//  Created by Harrison Woodward on 7/27/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit

class YourTasksTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
