//
//  MyCell.swift
//  Traveler
//
//  Created by YED on 06/01/17.
//  Copyright © 2017 YED. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet var cell_icon: UIImageView!
    @IBOutlet var lblDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
