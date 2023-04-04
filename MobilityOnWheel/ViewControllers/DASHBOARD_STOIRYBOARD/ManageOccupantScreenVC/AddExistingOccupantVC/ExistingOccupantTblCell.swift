//
//  ExistingOccupantTblCell.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 21/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import UIKit
class ExistingOccupantTblCell: UITableViewCell {

    @IBOutlet weak var lblOperatorName:UILabel!
    @IBOutlet weak var lblOccupantName:UILabel!
    @IBOutlet weak var btnRadio:UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
