//
//  ActivityTableViewCell.swift
//  Kuva
//
//  Created by Shane DeWael on 2/28/17.
//  Copyright © 2017 kuva. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var activityUser: UILabel!
    @IBOutlet weak var activityAction: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
