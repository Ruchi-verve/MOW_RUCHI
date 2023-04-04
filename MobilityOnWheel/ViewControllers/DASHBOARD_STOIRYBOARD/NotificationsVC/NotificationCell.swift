//
//  NotificationCell.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 24/02/22.
//  Copyright © 2022 Verve_Sys. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var txtNotificationDesc: UITextView!
    @IBOutlet weak var lblNotificationDate: UILabel!
    @IBOutlet weak var lblNotificationTitle: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtNotificationDesc.isEditable = false
        txtNotificationDesc.dataDetectorTypes = .all
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
