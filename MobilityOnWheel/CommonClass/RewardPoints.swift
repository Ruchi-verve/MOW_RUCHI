//
//  RewardPoints.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 12/04/22.
//  Copyright © 2022 Verve_Sys. All rights reserved.
//

import UIKit

protocol onBtnPopupCloseClick{
    func closePopupCLick()
}

class RewardPoints: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var viewReardsPoint: UIView!
    @IBOutlet weak var btnRewardClose: UIButton!
    @IBOutlet weak var txtRewardPoint: UITextField!

    var delegate:onBtnPopupCloseClick?
    override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
     }
     
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         commonInit()
     }
    func commonInit() {
        Bundle.main.loadNibNamed("RewardPoints", owner: self, options: nil)
        contentView.frame = self.bounds
//        innerView.layer.borderWidth = 2.0
//        innerView.layer.borderColor = UIColor.clear.cgColor
//        innerView.layer.cornerRadius  = 10
       // innerView.clipsToBounds = true
        Common.shared.addPaddingAndBorder(to: self.txtRewardPoint, placeholder: "")
        contentView.fixInView(self)
        CommonApi.callRewardPointsApi(completionHandler: {success in
            if success ==  true {
                self.txtRewardPoint.text = String(format: "%.1f", APP_DELEGATE.fltRewarardPoints)
            }
        })
        self.txtRewardPoint.isUserInteractionEnabled = false
    }
    

    @IBAction func btnRewardCloseClick(_ sender:Any) {
        //viewReardsPoint.isHidden = true
        delegate?.closePopupCLick()
    }

}
