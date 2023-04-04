//
//  CardCell.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit

let CardCellID = "CardCellID"

class CardCell: UITableViewCell {

    
    @IBOutlet weak var viewSelect:UIView!
    @IBOutlet weak var lblCardName:UILabel!
    @IBOutlet weak var lblCardNo:UILabel!
    @IBOutlet weak var imgCard:UIImageView!
    @IBOutlet weak var btndelete:UIButton!
    @IBOutlet weak var iconSuccess:UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
