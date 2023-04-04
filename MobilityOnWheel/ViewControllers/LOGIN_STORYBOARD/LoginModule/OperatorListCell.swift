//
//  OperatorList.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 29/07/21.
//

import UIKit

let OperatorListID = "OperatorListCell"

class OperatorListCell: UITableViewCell {

    @IBOutlet weak var lblOperatorName: UILabel!
    @IBOutlet weak var lblOperatorEmail: UILabel!
    @IBOutlet weak var lblOpertatorContact: UILabel!
    @IBOutlet weak var btnOccupant: UIButton!
    @IBOutlet weak var imgOccupant: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgEdit: UIImageView!

    var strIsCome:String = "" 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if strIsCome == "Occupant" {
            imgOccupant.image  = UIImage(named: "icon_delete")
        }
        else {
            imgOccupant.image = UIImage(named: "icon_proffile_settings")

        }

        // Configure the view for the selected state
    }
    
}
