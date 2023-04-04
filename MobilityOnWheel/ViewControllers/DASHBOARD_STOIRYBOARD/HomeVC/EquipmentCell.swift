//
//  EquipmentCell.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 30/07/21.
//

import UIKit

class EquipmentCell: UICollectionViewCell {

    @IBOutlet var lblvheicleName:UILabel!
    @IBOutlet var imgVehicle:UIImageView!
    @IBOutlet var lblvheicleDate:UILabel!
    @IBOutlet var lblvheiclePrice:UILabel!
    @IBOutlet var viewContent:UIView!
    @IBOutlet var imgBattery:UIView!
    @IBOutlet var lblLevelofBattery:UIView!
    @IBOutlet var bthnInfo:UIButton!
    @IBOutlet var lblOrderAndEquip:UILabel!
    @IBOutlet var btnExtend:UIButton!
    @IBOutlet var btnReturn:UIButton!
    @IBOutlet var lblSearchName:UILabel!
    @IBOutlet var lblTimeRemain:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgVehicle.roundedViewCorner(radius: 5)
       imgVehicle.layer.borderColor = UIColor.clear.cgColor
        imgVehicle.layer.borderWidth = 1
        viewContent.roundedViewCorner(radius: 5)
       viewContent.layer.borderWidth = 1
       viewContent.layer.borderColor = AppConstants.kColor_Primary.cgColor

    }
    
    

}

