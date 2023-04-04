//
//  REditProfileVC.swift
//  AamluckyRetailer
//
//  Created by Arvind Kanjariya on 24/01/20.
//  Copyright © 2020 Arvind Kanjariya. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

enum devicePropertyOption:Int{
    
    case joyStickPosition = 1
    case preferredWheelchairSize = 2
    case chairPad = 3
    case handController = 4

}

class ExtendReservationVC: SuperViewController,UITextFieldDelegate {


    @IBOutlet weak var txtSelectOperator: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSelectAccType: SkyFloatingLabelTextField!
    @IBOutlet weak var txtArrivalTime: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDepatureTime: SkyFloatingLabelTextField!
    @IBOutlet weak var txtArrivalDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDepatureDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNewDepatureDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNewDepatureTime: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNewRentalPeriod: SkyFloatingLabelTextField!
    @IBOutlet weak var txtNewRiderRewards: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSelectOccupant: SkyFloatingLabelTextField!
    
    @IBOutlet weak var txtBillingAdd: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    @IBOutlet weak var txtZip: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAppartment: SkyFloatingLabelTextField!
    @IBOutlet weak var txtContactNo: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnRewardPolicy: UIButton!
    @IBOutlet weak var btnUpdateReservation: UIButton!
    @IBOutlet weak var viewOccupant: UIView!
    @IBOutlet weak var conViewOccheight: NSLayoutConstraint!
    @IBOutlet weak var viewChairPad: UIView!
    @IBOutlet weak var viewhandController: UIView!
    @IBOutlet weak var viewPreferedSize: UIView!
    @IBOutlet weak var viewJoystick: UIView!
    @IBOutlet weak var lblChairPad: UILabel!
    @IBOutlet weak var lblhandController: UILabel!
    @IBOutlet weak var lblPreferedSize: UILabel!
    @IBOutlet weak var lblJoystick: UILabel!
    @IBOutlet weak var conviewLocHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLocation: UIView!

    @IBOutlet weak var conViewOtherheight: NSLayoutConstraint!
    @IBOutlet weak var viewOther: UIView!
    @IBOutlet weak var btnOther: UIButton!

    @IBOutlet weak var conviewChairPadHeight: NSLayoutConstraint!
    @IBOutlet weak var conviewhandControllerHeight: NSLayoutConstraint!
    @IBOutlet weak var conviewPreferedSizeHeight: NSLayoutConstraint!
    @IBOutlet weak var conviewJoystickHeight: NSLayoutConstraint!

    var arrChairpadReq = [DevicePropertySubResModel]()
    var arrJoystickPos = [DevicePropertySubResModel]()
    var arrHandController = [DevicePropertySubResModel]()
    var arrPrefferedWheelchairSize = [DevicePropertySubResModel]()
    var OrderId = Int()
    var selectAccId:Int = 0
    var strIsCome = String()
    var dictExtendRes = ExtendOrderRes()
    var operatorName = String()
//    let getName = USER_DEFAULTS.value(forKey: AppConstants.FIRST_NAME) as? String ??  "Steve"
//    let strLastName  = USER_DEFAULTS.value(forKey: AppConstants.LAST_NAME) as? String ?? ""
    var dictgetBillingInfo = BillingPriceModel()
    var dictgetLoctionId = LocationIDModel()
    var deliveryFee:Float =  0,gettaxRate:Float =  0,totalPrice:Float =  0
    var dictProdDetailRes = ProductDetailRes()
    var strImagePath = String()
    var strItemName = String()
    var arrData = [[String:Any]] ()
    var billingId:Int = 0
    var strDevicePropertyIDs:String = ""
    var flotPriceAdjustment :Float =  0.0
    var OperatorId:Int = 0,billingProfileId : Int = 0
    var strSelectedLoc:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Common.shared.setFloatlblTextField(placeHolder: "Select Operator", textField: txtSelectOperator)
        Common.shared.setFloatlblTextField(placeHolder: "Select Occupant", textField: txtSelectOccupant)
        
        Common.shared.setFloatlblTextField(placeHolder: "Select Accessory Type", textField: txtSelectAccType)
        Common.shared.setFloatlblTextField(placeHolder: "mm/dd/yyyy", textField: txtArrivalDate)
        Common.shared.setFloatlblTextField(placeHolder: "hh:mm",textField: txtArrivalTime)
        Common.shared.setFloatlblTextField(placeHolder: "mm/dd/yyyy", textField: txtDepatureDate)
        Common.shared.setFloatlblTextField(placeHolder: "hh:mm", textField:     txtDepatureTime)
        Common.shared.setFloatlblTextField(placeHolder: "mm/dd/yyyy", textField: txtNewDepatureDate)
        Common.shared.setFloatlblTextField(placeHolder: "hh:mm", textField: txtNewDepatureTime)
        Common.shared.setFloatlblTextField(placeHolder: "", textField: txtNewRentalPeriod)
        Common.shared.setFloatlblTextField(placeHolder: "", textField: txtNewRiderRewards)

        txtArrivalDate.titleFormatter = { text in
    self.txtArrivalDate.titleLabel.text = self.txtArrivalDate.titleLabel.text?.lowercased()
    return text
}

        txtArrivalTime.titleFormatter = { text in
    self.txtArrivalTime.titleLabel.text = self.txtArrivalTime.titleLabel.text?.lowercased()
    return text
}
        
        txtDepatureDate.titleFormatter = { text in
    self.txtDepatureDate.titleLabel.text = self.txtDepatureDate.titleLabel.text?.lowercased()
    return text
}

        txtDepatureTime.titleFormatter = { text in
    self.txtDepatureTime.titleLabel.text = self.txtDepatureTime.titleLabel.text?.lowercased()
    return text
}

        txtNewDepatureDate.titleFormatter = { text in
    self.txtNewDepatureDate.titleLabel.text = self.txtNewDepatureDate.titleLabel.text?.lowercased()
    return text
}

        txtNewDepatureTime.titleFormatter = { text in
    self.txtNewDepatureTime.titleLabel.text = self.txtNewDepatureTime.titleLabel.text?.lowercased()
    return text
}
  
        Common.shared.addSkyTextfieldwithAssertick(to: txtBillingAdd, placeHolder: "Building Name and/or Building No./Address")
        Common.shared.setFloatlblTextField(placeHolder: "Appartment,suit,unit,etc", textField: txtAppartment)
        Common.shared.addSkyTextfieldwithAssertick(to: txtCity, placeHolder: "City")
        Common.shared.addSkyTextfieldwithAssertick(to:txtState, placeHolder: "State")
        Common.shared.addSkyTextfieldwithAssertick(to: txtZip, placeHolder: "Zip")
        Common.shared.setFloatlblTextField(placeHolder:"Contact Person's phone number & delivery location" , textField: txtContactNo)

        conviewLocHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? 90: 60
        conViewOtherheight.constant = 0
        self.viewOther.updateConstraintsIfNeeded()
        self.viewOther.layoutIfNeeded()
        self.viewOther.updateConstraintsIfNeeded()
        self.viewOther.layoutIfNeeded()
        self.viewLocation.updateConstraintsIfNeeded()
        self.viewLocation.layoutIfNeeded()
        btnUpdateReservation.backgroundColor = UIColor.lightGray
        btnUpdateReservation.isUserInteractionEnabled = false

        if strIsEditOrder == "extend" {
            
        } else {
            callLocationbyId(completionHandler:{success in
                if success == true {
                    self.callApiforProductDesc()
                }
            } )

        }

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if strIsEditOrder == "extend" {
            callSetupUI()
            billingId = (APP_DELEGATE.dictEditedData["billingProfileId"] as? Int)!
            checkbtnEnabled()
            return
        }
        strIsCome = ""
//        Common.shared.deleteDatabase()
//        Common.shared.deleteUserDatabase()
        APP_DELEGATE.dictEditedData = [:]
        strIsEditOrder = ""
        self.setupApiData()
    }
    
    func callSetupUI(){
        self.conviewChairPadHeight.constant = 0
        self.conviewJoystickHeight.constant = 0
        self.conviewPreferedSizeHeight.constant = 0
        self.conviewhandControllerHeight.constant = 0
        self.txtSelectOperator.text  = APP_DELEGATE.dictEditedData["operatorName"] as? String
            self.txtDepatureDate.text = APP_DELEGATE.dictEditedData["arrivalDate"] as? String
            self.txtNewDepatureDate.text = APP_DELEGATE.dictEditedData["depatureDate"] as? String
            self.txtNewDepatureTime.text = APP_DELEGATE.dictEditedData["depatureTime"] as? String
            self.txtDepatureTime.text = APP_DELEGATE.dictEditedData["arrivalTime"] as? String
        self.txtArrivalDate.text = APP_DELEGATE.dictEditedData["oldArrrivalDate"] as? String
        self.txtArrivalTime.text = APP_DELEGATE.dictEditedData["oldArrivalTime"] as? String
            self.txtNewRentalPeriod.text = APP_DELEGATE.dictEditedData["rentalPeriod"] as? String
        self.txtNewRiderRewards.text = "\(APP_DELEGATE.dictEditedData["rewardPoint"] as? Int ?? 0)"
        self.lblPrice.text = "$\(APP_DELEGATE.dictEditedData["originalPrice"] as? String ?? "0.00") (excl.tax)"
         self.txtSelectAccType .text  = APP_DELEGATE.dictEditedData["accessoryName"] as? String ?? ""
        self.strDevicePropertyIDs  = APP_DELEGATE.dictEditedData["strDevicePropertyIds"] as? String ?? ""
        self.flotPriceAdjustment = APP_DELEGATE.dictEditedData["priceAdjustment"] as? Float ?? 0.00
        strPrefferedWheelchairSize = APP_DELEGATE.dictEditedData["strPreffWheel"] as? String ?? ""
        strChairPadReq = APP_DELEGATE.dictEditedData["strChairpad"] as? String ?? ""
        strHandController = APP_DELEGATE.dictEditedData["strHandCon"] as? String ?? ""
        strJoystickPos = APP_DELEGATE.dictEditedData["strJoyStick"] as? String ?? ""
        getchairPadPrice = APP_DELEGATE.dictEditedData["chairPadPrice"] as? Float ?? 00.00
        self.totalPrice = Float(APP_DELEGATE.dictEditedData["originalPrice"] as? String ?? "00.00")!
        self.txtSelectOperator.text =  APP_DELEGATE.dictEditedData["operatorName"] as? String
        OccuId = APP_DELEGATE.dictEditedData["occuId"] as? Int ?? 0
        if OccuId ==  0 {
            self.conViewOccheight.constant = 0
            self.viewOccupant.layoutIfNeeded()
            self.viewOccupant.updateConstraintsIfNeeded()
        } else  {
            self.conViewOccheight.constant = UIDevice.current.userInterfaceIdiom == .pad ? 130:100
            self.viewOccupant.layoutIfNeeded()
            self.viewOccupant.updateConstraintsIfNeeded()
            callOccuDetails(occId: OccuId)
        }
        let strPickupLoc = APP_DELEGATE.dictEditedData["pickupLoc"] as? String
        if strPickupLoc!.contains("other".uppercased()) {
            conviewLocHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ?  400:420
            conViewOtherheight.constant = UIDevice.current.userInterfaceIdiom == .pad ?  300:420
            self.txtZip.text =  APP_DELEGATE.dictEditedData["shippingZipcode"] as? String
            self.txtAppartment.text = APP_DELEGATE.dictEditedData["shippingAddressLine2"] as? String
            self.txtBillingAdd.text = APP_DELEGATE.dictEditedData["shippingAddressLine1"] as? String
            self.txtCity.text = APP_DELEGATE.dictEditedData["shippingCity"] as? String
            self.txtState.text = APP_DELEGATE.dictEditedData["shippingStateName"] as? String
            self.txtContactNo.text = APP_DELEGATE.dictEditedData["shippingDeliveryNote"] as? String
        } else{
            conviewLocHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ?  70: 50
            conViewOtherheight.constant = 0
        }
        self.btnOther.setTitle(APP_DELEGATE.dictEditedData["pickupLoc"] as? String, for: .normal)
        self.txtSelectAccType.text  = APP_DELEGATE.dictEditedData["accessoryName"] as? String
        DispatchQueue.main.async {
            self.viewOther.updateConstraintsIfNeeded()
            self.viewOther.layoutIfNeeded()
            self.viewLocation.updateConstraintsIfNeeded()
            self.viewLocation.layoutIfNeeded()
        }

        OperatorId = APP_DELEGATE.dictEditedData["opeId"] as? Int ?? 0
        gettaxRate = Float(APP_DELEGATE.dictEditedData["taxRate"] as? String ?? "0.00")!
        selectAccId = APP_DELEGATE.dictEditedData["accessoryId"] as? Int ?? 0
        deliveryFee = Float(APP_DELEGATE.dictEditedData["deliveryFee"] as? String ?? "0.00")!
        billingProfileId = APP_DELEGATE.dictEditedData["billingProfileId"] as? Int ?? 0
    strSelectedLoc  = APP_DELEGATE.dictEditedData["pickupLoc"] as? String ?? ""
        if strChairPadReq != "" && strChairPadReq != "0" {
            self.conviewChairPadHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? 70 :50
            self.conviewJoystickHeight.constant = 0
            self.lblChairPad.text = strChairPadReq
            self.conviewPreferedSizeHeight.constant = 0
            self.conviewhandControllerHeight.constant = 0
        } else if strJoystickPos != "" && strJoystickPos != "0" {
            self.lblJoystick.text = strJoystickPos
            self.conviewChairPadHeight.constant = 0
            self.conviewJoystickHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? 70:50
            self.conviewPreferedSizeHeight.constant = 0
            self.conviewhandControllerHeight.constant = 0
            
        } else if strHandController != "" && strHandController != "0" {
            self.lblhandController.text = strHandController
            self.conviewChairPadHeight.constant = 0
            self.conviewJoystickHeight.constant = 0
            self.conviewPreferedSizeHeight.constant = 0
            self.conviewhandControllerHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ?  70:50
            
        } else if strPrefferedWheelchairSize != "" && strPrefferedWheelchairSize != "0" {
            self.lblPreferedSize.text = strPrefferedWheelchairSize
            self.conviewChairPadHeight.constant = 0
            self.conviewJoystickHeight.constant = 0
            self.conviewPreferedSizeHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ?  70 : 50
            self.conviewhandControllerHeight.constant = 0
            
        }
        DispatchQueue.main.async {
            self.viewhandController.updateConstraintsIfNeeded()
            self.viewhandController.layoutIfNeeded() //1
            self.viewPreferedSize.updateConstraintsIfNeeded()
            self.viewPreferedSize.layoutIfNeeded() //2
            self.viewJoystick.updateConstraintsIfNeeded()
            self.viewJoystick.layoutIfNeeded() //3
            self.viewChairPad.updateConstraintsIfNeeded()
            self.viewChairPad.layoutIfNeeded() // 4

        }
        
    }
    
   //MARK:- UIAction
    @IBAction func btnUpdateReservationClick(_ sender:Any) {
        Common.shared.deleteDatabase()
        Common.shared.deleteUserDatabase()
        openDatabse()
        
    }
    
    //MARK:- UItextfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtNewDepatureDate {
            let getDate = Common.shared.convertStringtoDate(strDate: txtDepatureDate.text!, passDateFormat: "MM/dd/yyyy")
            txtNewDepatureDate.addDepartureInputViewDatePicker(target: self, selector: #selector(onDoneTxtExpirationClick), minDate: getDate)
        }
        
        else if textField == txtNewDepatureTime {
            if txtNewDepatureDate.text == ""{
                self.view.endEditing(true)
                return Utils.showMessage(type: .error, message: "Please select new depature date first")
            }
            txtNewDepatureTime.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtTimeClick), isDob: false,isTime: true)

        }
    }
    @objc func onDoneTxtExpirationClick() {
        if let  datePicker = self.txtNewDepatureDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MM/dd/yyyy"
            self.txtNewDepatureDate.text = dateFormatter.string(from: datePicker.date)
        }
        if txtNewDepatureTime.text != "" && txtNewDepatureDate.text != "" {
            callApi()
        }
        self.txtNewDepatureDate.resignFirstResponder()
     }
    
    func checkbtnEnabled() {
        if billingId != 0 {
            btnUpdateReservation.backgroundColor = AppConstants.kColor_Primary
           btnUpdateReservation.isUserInteractionEnabled = true
        }
    }

    @objc func onDoneTxtTimeClick() {
        if let  datePicker = self.txtNewDepatureTime.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            datePicker.datePickerMode = .time
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.month, .day, .year, .hour, .minute], from: datePicker.date)
            guard var hour = dateComponents.hour, var minute = dateComponents.minute else {
                print("something went wrong")
                return
            }

            let intervalRemainder = minute % datePicker.minuteInterval
            if intervalRemainder > 0 {
                // need to correct the date
                minute += datePicker.minuteInterval - intervalRemainder
                if minute >= 60 {
                    hour += 1
                    minute -= 60
                }
                // update datecomponents
                dateComponents.hour = hour
                dateComponents.minute = minute

                // get the corrected date
                guard let roundedDate = calendar.date(from: dateComponents) else {
                    print("something went wrong")
                    return
                }

                // update the datepicker
                datePicker.date = roundedDate
            }
            self.txtNewDepatureTime.text = dateFormatter.string(from: datePicker.date)
        }
        if txtNewDepatureTime.text != "" && txtNewDepatureDate.text != "" {

            callApi()
            checkbtnEnabled()
        }
        self.txtNewDepatureTime.resignFirstResponder()
     }

//MARK:- Webservice Call
    
    func setupApiData() {
        self.txtSelectOperator.text  = self.operatorName
        if self.dictExtendRes.occupantID ==  0 {
            self.conViewOccheight.constant = 0
            self.viewOccupant.layoutIfNeeded()
            self.viewOccupant.updateConstraintsIfNeeded()
        }
        else  {
            self.conViewOccheight.constant = UIDevice.current.userInterfaceIdiom == .pad ?  130:100
            self.viewOccupant.layoutIfNeeded()
            self.viewOccupant.updateConstraintsIfNeeded()
            callOccuDetails(occId: dictExtendRes.occupantID)
        }
        if dictExtendRes.customerPickupLocation.contains("other".uppercased()) {
            conviewLocHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? 400 :400
            conViewOtherheight.constant = UIDevice.current.userInterfaceIdiom == .pad ?  300 :350
            self.txtZip.text =  dictExtendRes.shippingZipcode
            self.txtAppartment.text = dictExtendRes.shippingAddressLine2
            self.txtBillingAdd.text = dictExtendRes.shippingAddressLine1 
            self.txtCity.text = dictExtendRes.shippingCity
            self.txtState.text = APP_DELEGATE.arrGetState.filter{$0.id == dictExtendRes.shippingStateID}.first?.stateName ?? ""
            self.txtContactNo.text = dictExtendRes.shippingDeliveryNote
        } else{
            conviewLocHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ?  70 :50
            conViewOtherheight.constant = 0
            self.txtZip.text =  ""
            self.txtBillingAdd.text = ""
            self.txtCity.text = ""
            self.txtState.text = ""
            self.txtContactNo.text = ""
        }
        DispatchQueue.main.async {
            self.viewOther.updateConstraintsIfNeeded()
            self.viewOther.layoutIfNeeded()
            self.viewLocation.updateConstraintsIfNeeded()
            self.viewLocation.layoutIfNeeded()
        }
        self.btnOther.setTitle(self.dictExtendRes.customerPickupLocation, for: .normal)
        self.txtSelectAccType.text  = self.dictExtendRes.accessoryType
        self.txtArrivalTime.text = self.dictExtendRes.pickUpTime
        self.txtArrivalDate.text = self.dictExtendRes.pickUpDate
        self.txtDepatureTime.text = self.dictExtendRes.returnTime
        self.txtDepatureDate.text = self.dictExtendRes.returnDate
      //  self.lblPrice.text  = "$\(self.dictExtendRes.price)(excl.tax)"
    }
    
    //MARK:- Api Calling
    func callApi() {
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.CheckOut.getBillingData
        let param = ["pickupDate":txtArrivalDate.text!,
                     "pickupTime":txtArrivalTime.text!,
                     "returnDate":txtDepatureDate.text!,
                     "returnTime":txtDepatureTime.text!,
                     "devicetypid":strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["deviceTypeId"] as! Int : dictExtendRes.deviceTypeID,
                     "locationID":strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["destinationId"] as! Int : dictExtendRes.locationID,
                     "CustomerID":strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["customerId"] as! Int : dictExtendRes.customerID,
                     "newReturnDate":txtNewDepatureDate.text!,
                     "newReturnTime":txtNewDepatureTime.text!,
                     "orderId":strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["primaryOrderId"] as! Int : dictExtendRes.primaryOrderID] as [String : Any]
        let gettoken  = USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? ""
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":gettoken,"DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        
        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:param, httpMethodForGetOrPost: .post, setheaders: header) {[weak self] (dicResponseWithSuccess ,_)  in
            if let weakSelf = self {
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        
                        weakSelf.dictgetBillingInfo = BillingPriceModel().initWithDictionary(dictionary: dicResponseData)
                        
                        if weakSelf.dictgetBillingInfo.result == true {
                            weakSelf.totalPrice = weakSelf.dictgetBillingInfo.totalPrice
                            weakSelf.lblPrice.text = String(format: "$%.2f (excl.tax)",weakSelf.dictgetBillingInfo.totalPrice)
                            weakSelf.billingId = weakSelf.dictgetBillingInfo.billingProfileID
                            weakSelf.totalPrice = (weakSelf.dictgetBillingInfo.totalPrice)
                            weakSelf.txtNewRiderRewards.text = "\(weakSelf.dictgetBillingInfo.rewardPoint)"
                            weakSelf.txtNewRentalPeriod.text = weakSelf.dictgetBillingInfo.shortDescription
                            weakSelf.checkbtnEnabled()
                            Utils.hideProgressHud()
                        } else{
                            Utils.hideProgressHud()
                            weakSelf.billingId = 0
                            weakSelf.txtNewRentalPeriod.text = ""
                            weakSelf.txtNewRiderRewards.text = ""
                            weakSelf.txtNewDepatureDate.text = ""
                            weakSelf.txtNewDepatureTime.text = ""
                            Utils.showMessage(type: .error, message:weakSelf.dictgetBillingInfo.message)
                        }
                    }
                } else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                }
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
            }
        }
    }
    
    //MARK:- Create New Database
    func openDatabse() {
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: managedObjectContext)
        let newUser = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        saveData(UserDBObj:newUser)
    }
    func saveData(UserDBObj:NSManagedObject) {

        UserDBObj.setValue(false, forKey: "isPromoapply")
        UserDBObj.setValue(txtArrivalDate.text, forKey: "oldArrrivalDate")
        UserDBObj.setValue(txtArrivalTime.text, forKey: "oldArrivalTime")
        UserDBObj.setValue(txtDepatureDate.text, forKey: "arrivalDate")
        UserDBObj.setValue(txtDepatureTime.text, forKey: "arrivalTime")
        UserDBObj.setValue("\(totalPrice)", forKey: "total")
//        UserDBObj.setValue(strIsEditOrder == "extend" ? "" : "\(APP_DELEGATE.dictEditedData["itemPrice"] as? Float ??  0.00)", forKey: "originalPrice")
        UserDBObj.setValue( strIsEditOrder == "extend" ?   "\(APP_DELEGATE.dictEditedData["itemPrice"] as? Float ??  0.00)" : "\(dictgetBillingInfo.regularPrice)", forKey: "originalPrice")
        UserDBObj.setValue(txtNewRentalPeriod.text, forKey: "rentalPeriod")
        UserDBObj.setValue(Int32(txtNewRiderRewards.text!), forKey: "rewardPoint")
        UserDBObj.setValue( strIsEditOrder == "extend" ? totalPrice : dictgetBillingInfo.regularPrice, forKey: "itemPrice")
        UserDBObj.setValue( strIsEditOrder != "extend" ? txtSelectAccType.text :  APP_DELEGATE.dictEditedData["accessoryName"] as? String, forKey: "accessoryName")
        UserDBObj.setValue(0.0, forKey: "priceAdjustment")
        UserDBObj.setValue(dictgetBillingInfo.regularPrice == 0 ? APP_DELEGATE.dictEditedData["regPrice"] as? Float : dictgetBillingInfo.regularPrice , forKey: "regPrice")
        UserDBObj.setValue(strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["accessoryId"] as? Int:  dictExtendRes.accessoryTypeID, forKey: "accessoryId")
        UserDBObj.setValue(self.dictgetLoctionId.isGenerateAcceptBonusDay, forKey:"generateBonus")
        UserDBObj.setValue(strIsEditOrder != "extend" ?dictExtendRes.customerPickupLocation :APP_DELEGATE.dictEditedData["pickupLoc"] as? String , forKey: "pickupLoc")
        UserDBObj.setValue("yes", forKey: "isExtendOrder")
        UserDBObj.setValue(strIsEditOrder != "extend" ? USER_DEFAULTS.value(forKey:AppConstants.SelDest) as? String : APP_DELEGATE.dictEditedData["destination"] as? String, forKey: "destination")
        UserDBObj.setValue(dictExtendRes.deviceTypeID != 0  ? dictExtendRes.deviceTypeID :APP_DELEGATE.dictEditedData["deviceTypeId"] as? Int , forKey: "deviceTypeId")
        UserDBObj.setValue(self.txtNewDepatureDate.text!, forKey: "depatureDate")
        UserDBObj.setValue(self.txtNewDepatureTime.text!, forKey: "depatureTime")
        UserDBObj.setValue("0", forKey: "isExp")
        UserDBObj.setValue(strIsEditOrder != "extend" ?  dictExtendRes.occupantID : APP_DELEGATE.dictEditedData["occuId"] as? Int , forKey: "occuId")
        UserDBObj.setValue(strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["opeId"] as? Int : dictExtendRes.operatorID , forKey: "opeId")
        UserDBObj.setValue(APP_DELEGATE.itemName, forKey: "itemName")
        
        UserDBObj.setValue("\(gettaxRate)", forKey: "taxRate")
        UserDBObj.setValue("\(0)", forKey: "deliveryFee")
        UserDBObj.setValue(strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["billingProfileId"] as? Int :  self.dictgetBillingInfo.billingProfileID, forKey: "billingProfileId")
        UserDBObj.setValue(self.strImagePath, forKey: "imgPath")
        UserDBObj.setValue(dictExtendRes.deviceTypeName == "" ?APP_DELEGATE.dictEditedData["itemName"] as? String : dictExtendRes.deviceTypeName, forKey: "itemName")
        UserDBObj.setValue(false, forKey:DatabaseStringName.isShippingAddress)
        if strIsEditOrder  == "extend" {
            let strOther  = APP_DELEGATE.dictEditedData["pickupLoc"] as? String
            if strOther!.contains("other".uppercased()) {
                UserDBObj.setValue(true, forKey:DatabaseStringName.isShippingAddress)
                UserDBObj.setValue(txtBillingAdd.text!, forKey:DatabaseStringName.shippingAddressLine1)
                UserDBObj.setValue(txtAppartment.text!, forKey:DatabaseStringName.shippingAddressLine2)
                UserDBObj.setValue(txtCity.text, forKey:DatabaseStringName.shippingCity)
                UserDBObj.setValue(txtState.text, forKey:DatabaseStringName.shippingStateName)
                UserDBObj.setValue(dictExtendRes.stateID, forKey:DatabaseStringName.shippingStateID)
                UserDBObj.setValue(txtZip.text, forKey:DatabaseStringName.shippingZipcode)
                UserDBObj.setValue(txtContactNo.text!, forKey:DatabaseStringName.shippingDeliveryNote)
            }
        } else {
            
            if dictExtendRes.customerPickupLocation.contains("other".uppercased()) {
                
                UserDBObj.setValue(true, forKey:DatabaseStringName.isShippingAddress)
                UserDBObj.setValue(txtBillingAdd.text!, forKey:DatabaseStringName.shippingAddressLine1)
                UserDBObj.setValue(txtAppartment.text!, forKey:DatabaseStringName.shippingAddressLine2)
                UserDBObj.setValue(txtCity.text, forKey:DatabaseStringName.shippingCity)
                UserDBObj.setValue(txtState.text, forKey:DatabaseStringName.shippingStateName)
                UserDBObj.setValue(dictExtendRes.stateID, forKey:DatabaseStringName.shippingStateID)
                UserDBObj.setValue(txtZip.text, forKey:DatabaseStringName.shippingZipcode)
                UserDBObj.setValue(txtContactNo.text!, forKey:DatabaseStringName.shippingDeliveryNote)
            }

        }
        let creditTotal = deliveryFee + gettaxRate + totalPrice
        UserDBObj.setValue(strIsEditOrder == "extend"  ? APP_DELEGATE.dictEditedData["orderId"] as? Int : dictExtendRes.primaryOrderID , forKey:"orderId")
        UserDBObj.setValue("\(creditTotal)", forKey: "creditTotal")
        UserDBObj.setValue(strIsEditOrder != "extend"  ?   self.lblJoystick.text:APP_DELEGATE.dictEditedData[
            DatabaseStringName.strJoy]as? String, forKey: DatabaseStringName.strJoy)
        UserDBObj.setValue(self.lblPreferedSize.text, forKey: DatabaseStringName.strPrefWheel)
        UserDBObj.setValue (self.lblChairPad.text , forKey: DatabaseStringName.strChairPad)
        UserDBObj.setValue(self.lblhandController.text , forKey: DatabaseStringName.strHandCon)
        UserDBObj.setValue(strIsEditOrder != "extend" ? dictExtendRes.customerPickupLocationID:APP_DELEGATE.dictEditedData[
            "pickupLocId"]as? Int , forKey: "pickupLocId")
        
        if strIsEditOrder == "extend" {
            if APP_DELEGATE.dictEditedData["joyStickId"] as? Int != 0 {
            UserDBObj.setValue(devicePropertyOption.joyStickPosition.rawValue, forKey: "joyStickId")
        }
        if APP_DELEGATE.dictEditedData["handConId"] as? Int != 0 {
            UserDBObj.setValue(devicePropertyOption.handController.rawValue, forKey: "handConId")
        }
        if APP_DELEGATE.dictEditedData["chairPadId"] as? Int != 0 {
            UserDBObj.setValue(devicePropertyOption.chairPad.rawValue, forKey: "chairPadId")
        }
        if APP_DELEGATE.dictEditedData["preWheelId"] as? Int != 0 {
            UserDBObj.setValue(devicePropertyOption.preferredWheelchairSize.rawValue, forKey: "preWheelId")
        }
        } else {
            if  dictExtendRes.joyStickPosition != "0" &&  dictExtendRes.joyStickPosition != "" {
                UserDBObj.setValue(devicePropertyOption.joyStickPosition.rawValue, forKey: "joyStickId")
            }
            if  dictExtendRes.handController != "0" &&  dictExtendRes.handController != "" {
                UserDBObj.setValue(devicePropertyOption.handController.rawValue, forKey: "handConId")
            }
            if dictExtendRes.chairPad != "0" &&  dictExtendRes.chairPad != "" {
                UserDBObj.setValue(devicePropertyOption.chairPad.rawValue, forKey: "chairPadId")
            }
            if  dictExtendRes.preferredWheelchairSize != "0" &&  dictExtendRes.preferredWheelchairSize != ""  {
                UserDBObj.setValue(devicePropertyOption.preferredWheelchairSize.rawValue, forKey: "preWheelId")
            }
        }
        UserDBObj.setValue(dictProdDetailRes.chairPadPrice, forKey: "chairPadPrice")
        UserDBObj.setValue(self.txtSelectOperator.text!, forKey: "operatorName")
        UserDBObj.setValue(self.txtSelectOccupant.text, forKey: "occupantName")
        UserDBObj.setValue(strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["primaryOrderId"] as? Int : dictExtendRes.primaryOrderID  , forKey:"primaryOrderId")
        UserDBObj.setValue(strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["primaryOrderId"] as? Int : dictExtendRes.primaryOrderID , forKey:"orderId")
        UserDBObj.setValue(strIsEditOrder == "extend"  ? APP_DELEGATE.dictEditedData["customerId"] as? Int : dictExtendRes.customerID , forKey: "customerId")
        UserDBObj.setValue(strIsEditOrder == "extend" ?  APP_DELEGATE.dictEditedData["strDevicePropertyIds"] as? String : dictProdDetailRes.devicePropertyIDs, forKey: "strDevicePropertyIds")
        UserDBObj.setValue(false, forKey: "isPrimaryOrder")
        UserDBObj.setValue(Int(txtNewRiderRewards.text!), forKey: "rewardPoint")
        UserDBObj.setValue(strIsEditOrder == "extend" ?  APP_DELEGATE.dictEditedData["destinationId"] as? Int  : dictExtendRes.locationID, forKey: "destinationId")
        do {
            try managedObjectContext.save()
            let help = ExtendReservedVC.instantiate(fromAppStoryboard: .DashBoard)
            self.navigationController?.pushViewController(help, animated: true)

        } catch {
            print("Storing data Failed")
        }
    }
    
    
    
    func fetchData() -> [NSManagedObject] {
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if result.count > 0 {
                return result
            }
            else  {
            }
        } catch {
            print("Fetching data Failed")
        }
        return []
    }

    func callLocationbyId(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }

        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getLocationById
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue:strIsEditOrder == "extend" ? "\(APP_DELEGATE.dictEditedData["destinationId"] as! Int)" : "\(dictExtendRes.locationID)"  ) {[weak self] (dicResponseWithSuccess ,_)  in
            if let weakSelf = self {
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        weakSelf.dictgetLoctionId = LocationIDModel().initWithDictionary(dictionary: dicResponseData)
                        if weakSelf.dictgetLoctionId.statusCode == "OK" {
                            weakSelf.gettaxRate = weakSelf.dictgetLoctionId.taxRate
                            weakSelf.deliveryFee  = weakSelf.dictgetLoctionId.deliveryfee
                            completionHandler(true)
                        } else {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message: weakSelf.dictgetLoctionId.message)
                            completionHandler(false)
                        }
                    }
                } else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                    completionHandler(false)
                }
            }  else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                completionHandler(false)
            }
        }
    }
    
    //MARK:- Proper Calculations
    

    func setNewCalculation() {
        var mainTotal = Float()
        var setSubTotal = Float()
        var totalTaxRate = Float()
        var deliveryFee =   Float()
        var arrSetofData =  Set<DeliveryFeeStruct>()
        var setNewDeliveryFee:Float = 0.0
        for i in 0..<arrData.count {
            var dict = arrData[i]
            var getStrTotal = String()
            let findTaxRate  =  dict["taxRate"] as? String ?? "0.00"
        let arrTime =   dict["arrivalTime"] as! String
        let arrDate = dict["arrivalDate"] as! String
        let combineString = arrDate + arrTime
                            if arrSetofData.contains(where: {subdict in (subdict.arrivalDate_Time == combineString) && (subdict.loctionId == dict["destinationId"]as? Int) }) {
                                setNewDeliveryFee = 0
                            } else {
                                let createDict = DeliveryFeeStruct()
                                deliveryFee = deliveryFee + Float(dict["deliveryFee"] as? String ?? "0.00")!
                                createDict.loctionId = dict["destinationId"] as? Int
                                createDict.arrivalDate_Time = combineString
                                arrSetofData.insert(createDict)
                                dict["itemDeliveryFee"] = Float(dict["deliveryFee"] as? String ?? "0.00")!
                                setNewDeliveryFee = Float(dict["deliveryFee"] as? String ?? "0.00")!
            }
            if dict["isPromoapply"] as? NSNumber == 1 {
                    getStrTotal = "\((dict["regPrice"] as! Float) + (dict["chairPadPrice"] as! Float) )"
                    let getFlotPriceTax = ((dict["regPrice"] as!Float)  +  (dict ["chairPadPrice"] as!Float) + (dict["priceAdjustment"] as!Float) + setNewDeliveryFee )  * ((Float(findTaxRate)!)/100)
                    totalTaxRate = (getFlotPriceTax) + totalTaxRate
                    setSubTotal = Float(getStrTotal)! + setSubTotal //1

            } else if dict["isRiderRewardApply"]as?NSNumber == 1 {
                    let price  = (dict["itemPrice"] as! Float)
                    let chairPad  = (dict["chairPadPrice"] as! Float)
                    let priceADj = (dict["priceAdjustment"] as! Float)
                    let strTotal = price + chairPad + priceADj
                    getStrTotal = "\(strTotal)"
                    let getFlotPriceTax = ((dict["itemPrice"] as!Float)  +  (dict ["chairPadPrice"] as!Float) + (dict["priceAdjustment"] as!Float) + setNewDeliveryFee )  * ((Float(findTaxRate)!)/100)
                    totalTaxRate = (getFlotPriceTax) + totalTaxRate
                    setSubTotal = Float(getStrTotal)! + setSubTotal //1
            } else {
                getStrTotal = (dict["total"] as?String ?? "0.00")
                let price  = (dict["regPrice"] as! Float)
                let chairPad  = (dict["chairPadPrice"] as! Float)
                let priceADj = (dict["priceAdjustment"] as! Float)
                let getFlotPriceTax = (((price + chairPad + priceADj) + setNewDeliveryFee) * ((Float(findTaxRate)!)/100))
                totalTaxRate = (getFlotPriceTax) + totalTaxRate
                setSubTotal = Float(getStrTotal)! + setSubTotal //1
            }
        }
        mainTotal = setSubTotal  +  deliveryFee + totalTaxRate
        taxRate = totalTaxRate
        flotPricewithTax = (mainTotal * 100) / 100
        TaxRate = totalTaxRate
        strSubTotal = String(format: "$%.2f (excl.tax)",setSubTotal )
        strDeliveryFee = String(format: "$%.2f (excl.tax)", deliveryFee)
    }
    //MARK: -BACK STACK
    @IBAction func btnBackClicked(_ sender:UIButton) {
            //checkbtnWhereisCome()
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnHomeClicked(_ sender:UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    func checkbtnWhereisCome() {
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<Users>(entityName: "Users")
        do{
            let result = try managedObjectContext.fetch(request)
            if result.count > 0 {
                let managedObject = result[0]
                if managedObject.isExtendOrder == "yes" {
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is HistoryVC {
                            self.navigationController!.popToViewController(aViewController, animated: true)
                        }


                    }
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.navigationController?.popViewController(animated: true)
        }
            }catch {
            print("Fetching data Failed")
        }

        
    }
    //MARK:- Call Api
    func callApiforProductDesc(){
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getDeviceTypebyId
        let getDesId = strIsEditOrder == "extend" ? APP_DELEGATE.dictEditedData["deviceTypeId"] as! Int : dictExtendRes.deviceTypeID
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(getDesId)") {[weak self] (dicResponseWithSuccess ,_)  in
                        if let weakSelf = self {
                            if  let jsonResponse = dicResponseWithSuccess {
                                guard jsonResponse.dictionary != nil else {
                                    return
                            }
                if let dicResponseData = jsonResponse.dictionary {
                                    weakSelf.dictProdDetailRes = ProductDetailRes().initWithDictionary(dictionary: dicResponseData)
                                    
            if weakSelf.dictProdDetailRes.statusCode == "OK"{
                            getchairPadPrice = Float(weakSelf.dictProdDetailRes.chairPadPrice)
                    weakSelf.strItemName = weakSelf.dictProdDetailRes.deviceTypeName
                    weakSelf.strImagePath  = AppUrl.URL.imgeBase + weakSelf.dictProdDetailRes.itemImagePath
                if weakSelf.dictProdDetailRes.devicePropertyIDs != "" {
                if weakSelf.dictProdDetailRes.devicePropertyIDs.contains("1") {
                    CommonApi.callDevicePropertyOptionsApi(id: 1, controll: self!, completionHandler: {(success) in
                                                    if success == true {
                                                        let  arrJoystickPos = arrPropertyIds
                                                        var dict = DevicePropertySubResModel()
                                                       
                                                        let filterArr = arrJoystickPos.filter{$0.devicePropertyOptionID == Int(weakSelf.dictExtendRes.joyStickPosition)}
                                                         dict = filterArr[0]
                                      weakSelf.conviewJoystickHeight.constant = 50
                                                        weakSelf.viewJoystick.layoutIfNeeded()
                                                        weakSelf.viewJoystick.updateConstraintsIfNeeded()
                                                        weakSelf.lblJoystick.text = dict.devicePropertyOption
                                                    }
                                                })
                                                
                                            }
    if weakSelf.dictProdDetailRes.devicePropertyIDs.contains("2") {
        CommonApi.callDevicePropertyOptionsApi(id: 2, controll: self!, completionHandler: {(success) in
                        if success == true {
                                let  arrPreWheeSize = arrPropertyIds
                                var dict = DevicePropertySubResModel()
                                let filterArr = arrPreWheeSize.filter{$0.devicePropertyOptionID == Int(weakSelf.dictExtendRes.preferredWheelchairSize)}
                            if filterArr.count > 0 {
                                dict = filterArr[0]
                                weakSelf.conviewPreferedSizeHeight.constant = 50
                                    weakSelf.viewPreferedSize.layoutIfNeeded()
                                                            weakSelf.viewPreferedSize.updateConstraintsIfNeeded()
                                                            weakSelf.lblPreferedSize.text = dict.devicePropertyOption
                            }
                                                    }
                                                })
                                            }
                                            if weakSelf.dictProdDetailRes.devicePropertyIDs.contains("3") {
                                                CommonApi.callDevicePropertyOptionsApi(id: 3, controll: self!, completionHandler: {(success) in
                                                    if success == true {
                                                        let  arrChairPad = arrPropertyIds
                                                        let dict = arrChairPad[Int(0)]
                                                        weakSelf.conviewChairPadHeight.constant = 50
                                                        weakSelf.viewChairPad.layoutIfNeeded()
                                                        weakSelf.viewChairPad.updateConstraintsIfNeeded()
                                                        
                                                        weakSelf.lblChairPad.text =  dict.devicePropertyOption + "  " + "$\(weakSelf.dictProdDetailRes.chairPadPrice)"
                                                    }
                                                })
                                                
                                            }
                                            if weakSelf.dictProdDetailRes.devicePropertyIDs.contains("4") {
                                                CommonApi.callDevicePropertyOptionsApi(id: 4, controll: self!, completionHandler: {(success) in
                                                    if success == true {
                                                        let  arrHandCon = arrPropertyIds
                                                        var dict = DevicePropertySubResModel()
                                                        let filterArr = arrHandCon.filter{$0.devicePropertyOptionID == Int(weakSelf.dictExtendRes.handController)}
                                                            dict = filterArr[0]
                                                        weakSelf.conviewhandControllerHeight.constant = 50
                                                        weakSelf.viewhandController.layoutIfNeeded()
                                                        weakSelf.viewhandController.updateConstraintsIfNeeded()
                                                        weakSelf.lblhandController.text = dict.devicePropertyOption
                                                    }
                                                })
                                            }
                                        } else {
                                            weakSelf.viewhandController.isHidden = true
                                            weakSelf.viewJoystick.isHidden = true
                                            weakSelf.viewChairPad.isHidden = true
                                            weakSelf.viewPreferedSize.isHidden = true
                                        }
                                        Utils.hideProgressHud()
                                    } else {
                                        Utils.hideProgressHud()
                                        Utils.showMessage(type: .error, message: weakSelf.dictProdDetailRes.message)
                                    }
                                }
                                } else {
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                                }
                            }
                    else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
            
                    }

                        }
        
    }
    
    //MARK:- getOccupant Details
    func callOccuDetails(occId:Int) {
                if !InternetConnectionManager.isConnectedToNetwork() {
                    Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
                    return
                }
                Utils.showProgressHud()
                let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.getOccuDetails
                
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(occId)") { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        
                        if dicResponseData["StatusCode"]?.stringValue == "OK" || dicResponseData["StatusCode"]?.stringValue == "" {
                            Utils.hideProgressHud()
                            self.txtSelectOccupant.text = dicResponseData["FullName"]?.string
                        } else {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message: dicResponseData["Message"]?.stringValue ?? AppConstants.ErrorMessage)
                        }
                    }
                 else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                }
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
            }
        }
        
    }
    
    
    
}



