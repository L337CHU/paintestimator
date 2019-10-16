//
//  CustomDimsCell.swift
//  MediaMine
//
//  Created by Christopher Chu on 9/14/19.
//  Copyright © 2019 NoOrg. All rights reserved.
//

import UIKit

class CustomDimsCell: UITableViewCell {

    @IBOutlet weak var length: UILabel!
    @IBOutlet weak var width: UILabel!
    @IBOutlet weak var totalDims: UILabel!
   // @IBOutlet weak var gallonsTotal: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
