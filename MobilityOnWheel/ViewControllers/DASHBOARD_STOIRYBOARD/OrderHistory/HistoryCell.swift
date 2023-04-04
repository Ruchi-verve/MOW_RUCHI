//
//  HistoryCell.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit


let HistoryCellID = "HistoryCellID"

class HistoryCell: UITableViewCell {

    @IBOutlet weak var lblArrivalDateTime:UILabel!
    @IBOutlet weak var lblDepatureDateTime:UILabel!
    @IBOutlet weak var lblOpeOccName:UILabel!
    @IBOutlet weak var lblOperator:UILabel!
    @IBOutlet weak var lblDestination:UILabel!
    @IBOutlet weak var lblExpDate:UILabel!
    @IBOutlet weak var lblCardRetention:UILabel!
    @IBOutlet weak var lblCaredType:UILabel!
    @IBOutlet weak var lblOrderId:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var lblOrderDate:UILabel!
    @IBOutlet weak var lblCardNo:UILabel!
    @IBOutlet weak var lblRefund:UILabel!
    
    
    @IBOutlet weak var topConstainLayout: NSLayoutConstraint!
    @IBOutlet weak var lbloperatorName : UILabel!
    @IBOutlet weak var lblpayorName : UILabel!
    @IBOutlet weak var btnoperatorName : UIButton!
    @IBOutlet weak var btnpayorName : UIButton!
    
    var buttonPressedOperatorName : (() -> ()) = {}
    var buttonPressedpayorName : (() -> ()) = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onTapOperatorName(_ sender : UIButton) {
         buttonPressedOperatorName()
    }
    
    @IBAction func onTappayorName(_ sender : UIButton) {
        buttonPressedpayorName()
    }
    
    
}
