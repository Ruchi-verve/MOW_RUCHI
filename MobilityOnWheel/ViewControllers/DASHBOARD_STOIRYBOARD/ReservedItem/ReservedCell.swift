//
//  ReservedCell.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit

let ReservedCellID = "ReservedCellID"

class ReservedCell: UITableViewCell {

    @IBOutlet weak var vwDetail: UIView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblRiderFullname: UILabel!
    @IBOutlet weak var lblComplimentary: UILabel!
    @IBOutlet weak var lblPickupLoc: UILabel!
    @IBOutlet weak var lblRental: UILabel!
    @IBOutlet weak var lblArrivalTime: UILabel!
    @IBOutlet weak var lblArrivalDate: UILabel!
    @IBOutlet weak var lblDepatureDate: UILabel!
    @IBOutlet weak var lblDepatureTime: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblChairPadPrice: UILabel!
    @IBOutlet weak var lblOperatorName: UILabel!
    @IBOutlet weak var conlblOccupantNameHeight: NSLayoutConstraint!
    @IBOutlet weak var conlbldevicePropertyHeight: NSLayoutConstraint!
    @IBOutlet weak var lblDeviceProperty: UILabel!
    @IBOutlet weak var conlblChairPadHeight:NSLayoutConstraint!
    @IBOutlet weak var btnEditReservation: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
