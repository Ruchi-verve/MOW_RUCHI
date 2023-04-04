//
//  ActiveCell.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit

protocol timerReload {
    func timerNeedtoReload()
}

let ActiveCellID = "ActiveCellID"

class ActiveCell: UITableViewCell {

    @IBOutlet var lblvheicleName:UILabel!
    @IBOutlet var imgVehicle:UIImageView!
    @IBOutlet var lblvheicleDate:UILabel!
    @IBOutlet var lblvheiclePrice:UILabel!
    @IBOutlet var viewContent:UIView!
    @IBOutlet var imgBattery:UIImageView!
    @IBOutlet var lblLevelofBattery:UILabel!
    @IBOutlet var btnInfo:UIButton!
    @IBOutlet var lblOrderAndEquip:UILabel!
    @IBOutlet var btnExtend:UIButton!
    @IBOutlet var btnReturn:UIButton!
    @IBOutlet var lblSearchName:UILabel!
    @IBOutlet var lblTimeRemain:UILabel!
    @IBOutlet var conviewContainHeight:NSLayoutConstraint!
    @IBOutlet var lblTimeRemainBottom:UILabel!
    @IBOutlet var lbltxtlevelofBattery:UILabel!
    @IBOutlet var imgInfo:UIImageView!
    @IBOutlet var lblEquipId:UILabel!

    
    var startDate:Date?
    var endDate:Date?
    var timer: Timer?
    var timeCounter: Double = 0
    var currentIndex : Int = 1
    var strStartDate:String?
    var delegate:timerReload?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTimeRemain.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.stopTimer()
    }
    
    //MARK:- SetupTime
    
    func setupTimer(`with` indexPath: Int){
        currentIndex = indexPath + 1
        timer = Timer.scheduledTimer(timeInterval: 1.0,target:self, selector: #selector(self.calculateTime) ,userInfo: nil, repeats: true);
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        timer?.fire()
}
    
    @objc func calculateTime() {
        var strTimer:String?
        if strStartDate != nil {
            strTimer = Date().offsetFrom(date:endDate!)
        } else {
            if startDate != nil {
                strTimer = startDate!.offsetFrom(date:Date())
            } else {
                strTimer = endDate!.offsetFrom(date: Date())
            }
        }
        
        if strTimer! == "0 0 0 0" {
            if endDate! > Date() {
                self.timer = nil
                self.lblTimeRemain.text = "00:00:00:00"
                self.delegate?.timerNeedtoReload()
                return()
            }
            self.strStartDate = "not"
            self.timer = Timer.scheduledTimer(timeInterval: 1.0,target:self, selector: #selector(self.calculateTime) ,userInfo: nil, repeats: true);
            self.lblTimeRemainBottom.text = "Order past Due:"
           // self.btnExtend.isUserInteractionEnabled = false
            //self.btnExtend.backgroundColor = UIColor.lightGray
            self.lblTimeRemain.textColor = UIColor.red
        }
        
        else {
                let arrCompo =  strTimer!.components(separatedBy: " ")
                self.lblTimeRemain.text = "\(arrCompo[0])".PadLeft(totalWidth: 2, byString: "0") + ":" + "\(arrCompo[1])".PadLeft(totalWidth: 2, byString: "0") + ":" + "\(arrCompo[2])".PadLeft(totalWidth: 2, byString: "0") + ":" + "\(arrCompo[3])".PadLeft(totalWidth: 2, byString: "0")
        }
    }
    
    func stopTimer(){
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
    }

}
