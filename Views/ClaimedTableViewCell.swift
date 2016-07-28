//
//  ClaimedTableViewCell.swift
//  EventTask
//
//  Created by Julia Woodward on 7/25/16.
//  Copyright © 2016 Harrison Woodward. All rights reserved.
//

import UIKit

class ClaimedTableViewCell: UITableViewCell {

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
