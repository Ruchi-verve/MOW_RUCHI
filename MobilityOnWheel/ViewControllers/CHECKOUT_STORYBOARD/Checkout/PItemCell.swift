//
//  PItemCell.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit

let PItemCellD = "PItemCellID"

class PItemCell: UITableViewCell {
    @IBOutlet weak var lblItemName:UILabel!
    @IBOutlet weak var lblItemQuantity:UILabel!
    @IBOutlet weak var lblItemPrice:UILabel!
    @IBOutlet weak var lblChairPadReq:UILabel!
    @IBOutlet weak var lblChairPadPrice:UILabel!
    
    @IBOutlet weak var vwDetail: UIView!
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var lblArrivalDate: UILabel!
    @IBOutlet weak var lblDepatureDate: UILabel!
    @IBOutlet weak var lblDepatureTime: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblComplimentary: UILabel!
    @IBOutlet weak var lblPickupLoc: UILabel!
    @IBOutlet weak var lblRiderFullname: UILabel!
    @IBOutlet weak var conlbldevicePropertyHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDeviceProperty: UILabel!
    @IBOutlet weak var conlblOccupantNameHeight: NSLayoutConstraint!
    @IBOutlet weak var lblRental: UILabel!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var lblOperatorName: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
