//
//  OtherLocationCell.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 27/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import UIKit

class OtherLocationCell: UITableViewCell {
    
    
    @IBOutlet weak var txtBillingAdd: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    @IBOutlet weak var txtZip: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAppartment: SkyFloatingLabelTextField!
    @IBOutlet weak var txtContactNo: SkyFloatingLabelTextField!

    @IBOutlet weak var btnCheckbox: UIButton!

    var arrState = [StateSubListModel]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Common.shared.addTextfieldwithAssertick(to: txtBillingAdd, placeholder: "Building Name and/or Building No./Address")
        Common.shared.addPaddingAndBorder(to: txtAppartment, placeholder: "Appartment,suit,unit,etc")
        Common.shared.addTextfieldwithAssertick(to: txtCity, placeholder: "City")
        Common.shared.addTextfieldwithAssertick(to: txtState, placeholder: "State")
        Common.shared.addTextfieldwithAssertick(to: txtZip, placeholder: "Zip")
        Common.shared.addPaddingAndBorder(to: txtContactNo, placeholder: "Contact Person's phone number & delivery location")

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

