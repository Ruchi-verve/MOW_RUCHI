//
//  PriceCell.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit

let PriceCellID = "PriceCellID"

class PriceCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
