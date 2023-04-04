//
//  OrderCompleteVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit
import SwiftyJSON

class OrderCompleteVC: SuperViewController {
    
    @IBOutlet weak var imgSuccessorFailure: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnReturnToMainMenu: UIButton!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSuccessMsg: UILabel!
    @IBOutlet weak var lblSuccessType: UILabel!

    var dictRes = [String:JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if dictRes["StatusCode"]?.stringValue  == "OK" {
            imgSuccessorFailure.image = UIImage(named: "icon_success")
            lblSuccessMsg.isHidden = false
            lblOrderId.isHidden = false
            lblDate.isHidden = false
            lblTotal.isHidden = false
            lblOrderId.text = "Order Number: \(dictRes["EquipmentOrderIDWithFormat"]?.stringValue ?? "")  "
            let convertedString = String(format: "%.2f", flotPricewithTax)
            lblTotal.text = "Total: $\(convertedString)  Payment Method: \(dictRes["PaymentMethod"]?.stringValue ?? "")"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd,yyyy"
            lblDate.text = dateFormatter.string(from: Date())
            //btnReturnToMainMenu.setTitle("Return To Active Orders", for: .normal)
        }
        else {
            imgSuccessorFailure.image = UIImage(named: "icon_fail")
            lblSuccessType.text = dictRes["Message"]?.stringValue
            lblSuccessMsg.isHidden = true
            lblOrderId.isHidden = true
            lblDate.isHidden = true
            lblTotal.isHidden = true
          //  btnReturnToMainMenu.setTitle("Return To Main Menu", for: .normal)
        }
    }
    
    func removeOrderCompleteData(){
        strIsEditOrder = ""
        OccuId = 0
        intJoystickPosId = 0
        intChairPadReqId = 0
        intHandControllerId = 0
        intPrefferedWheelchairSizeId = 0
        APP_DELEGATE.intCardIndex = 0
        APP_DELEGATE.arrOpeIdNEW.removeAll()
        APP_DELEGATE.arrOpeId.removeAll()
        Common.shared.deleteDatabase()
        Common.shared.deleteUserDatabase()

    }

    @IBAction func btnMainMenuClick(_ sender: Any) {
        if dictRes["StatusCode"]?.stringValue  == "OK" {removeOrderCompleteData()} else {}
        let orderComplete = ActiveOrderVC.instantiate(fromAppStoryboard: .DashBoard)
        self.navigationController?.pushViewController(orderComplete, animated: true)

    }
    
    @IBAction func btnHomeClick(_ sender: Any) {
        removeOrderCompleteData()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        removeOrderCompleteData()
        self.navigationController?.popToRootViewController(animated: true)

    }


    
}
