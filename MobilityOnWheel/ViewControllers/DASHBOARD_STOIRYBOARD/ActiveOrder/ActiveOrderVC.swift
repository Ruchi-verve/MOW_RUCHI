//
//  ActiveOrderVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit
import AVFoundation
import CoreData

class ActiveOrderVC: SuperViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,timerReload  {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblNoOrder: UILabel!
    @IBOutlet var viewEquipment:UIView!
    @IBOutlet var txtEquipment:SkyFloatingLabelTextField!
    @IBOutlet var viewInsideEquipment:UIView!
    @IBOutlet var btnCart:AddBadgeToButton!
    @IBOutlet var btnNotification:AddBadgeToButton!
    @IBOutlet var btnMenu:UIButton!
    @IBOutlet weak var lblInfo:UILabel!
    @IBOutlet weak var viewNoActiveOrder: UIView!

    var arrData = [ActiveOrderSubRes]()
    var dictExtendRes = ExtendOrderRes()
    var dictOpeInfo = OccupantListModel()
    var OrderId = Int()
    lazy var isOpenFrom:String = ""
    lazy var releaseDate = Date()
    lazy var startDate = Date()
    var countdownTimer: Timer?
    var updateTimer:String = ""
    var remainingTime:Int = 0
    var index:Int = -1
    var arrTimers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.showProgressHud()
        tblList.estimatedRowHeight = 230
        tblList.rowHeight = UITableView.automaticDimension
        viewNoActiveOrder.isHidden = true
        viewEquipment.isHidden = true
        viewInsideEquipment.roundedViewCorner(radius: 8)
        tblList.register(UINib(nibName: "ActiveCell", bundle: nil), forCellReuseIdentifier: "ActiveCell")
        Common.shared.setFloatlblTextField(placeHolder: "Enter Equipment Id", textField: txtEquipment)
       let  strFullString  = "Scooters: The Equipment ID number for Standard, Bariatric, and Portable travel scooters are indicated by a blue square with a three-digit number located below the seat or on the inside of the steering column. On certain standard scooters, the ID may also be located on each side of the scooter on the battery box located u nderneath the seat and also under the headlight on the front of the scooter.\n \nPower wheelchair: The Equipment ID number is indicated by a blue square with a three-digit number located behind the chair and/or below the seat.\n \nWheelchairs: The Equipment ID number on the wheelchair is printed on the lower back of the wheelchair and is the last three-digit number on the lower right of the backrest.\n \nTransport Chair, Rollator, Knee walker: The Equipment ID number is located on the frame by a white label with a three-digit number.\n \nBeach Wheelchair: The Equipment ID number for the beach wheelchair is indicated by a blue square with a three-digit number located on the back frame.\n \nSingle and Double Stroller: The Equipment ID number is indicated by a blue square with a three-digit number located on the front foot fender."
        
        self.lblInfo.attributedText = addBoldText(fullString: strFullString as NSString, boldPartsOfString: ["Scooters","Power wheelchair","Wheelchairs","Transport Chair, Rollator, Knee walker","Beach Wheelchair","Single and Double Stroller"], font: setFont.regular.of(size: 12), boldFont: setFont.bold.of(size: 12))
        txtEquipment.keyboardType = .numberPad
        Utils.showProgressHud()
        btnMenu.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: UIControl.Event.touchUpInside)
    }
    
    func timerNeedtoReload() {
        Utils.showProgressHud()
        self.callActiveOrderApi(completionHandler:{ _ in
            Utils.hideProgressHud()
            if APP_DELEGATE.arrActiveOrder.count > 0 {
                self.viewNoActiveOrder.isHidden = true
                self.tblList.isHidden = false
                self.arrData = APP_DELEGATE.arrActiveOrder
                DispatchQueue.main.async {
                    self.tblList.reloadData()
                    self.tblList.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            } else {
                self.viewNoActiveOrder.isHidden = false
                self.tblList.isHidden = true
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        Utils.showProgressHud()
        navigationController?.navigationBar.isHidden = true
        Common.shared.checkCartCount(btnCart)
        
        callActiveOrderApi(completionHandler: {success in
            Utils.hideProgressHud()
            if APP_DELEGATE.arrActiveOrder.count > 0 {
                self.viewNoActiveOrder.isHidden = true
                self.tblList.isHidden = false
                self.arrData = APP_DELEGATE.arrActiveOrder
                DispatchQueue.main.async {
                    self.tblList.reloadData()
                }
            } else {
                self.viewNoActiveOrder.isHidden = false
                self.tblList.isHidden = true
            }

        })
        CommonApi.callNotificationBadgeInfo(completionHandler: {success in
            if success == true {
                Common.shared.addBadgetoButton(self.btnNotification,"\(NotificationBadge)", "icon_notification")
                Utils.hideProgressHud()
            }
        })
    }
    
    @IBAction func btnNotificationClick(_ sender: Any) {
        self.view.endEditing(true)
        let loginScene = NotificationVC.instantiate(fromAppStoryboard: .DashBoard)
        self.navigationController?.pushViewController(loginScene, animated: true)
    }

    @IBAction func btnSaveClick(_ sender: Any) {
        self.view.endEditing(true)
        guard  let name  = txtEquipment.text, name != "" , !name.isEmpty else {
            return  Utils.showMessage(type: .error,message: "Please enter equipment id")
        }
        self.callCheckEquipIDApi(EquipOrderId:OrderId, completionHandler: {success in
            if success == true {
                Utils.hideProgressHud()
                self.viewEquipment.isHidden = true
                self.callActiveOrderApi(completionHandler:{ _ in
                    Utils.hideProgressHud()
                    if APP_DELEGATE.arrActiveOrder.count > 0 {
                        self.viewNoActiveOrder.isHidden = true
                        self.tblList.isHidden = false
                        self.arrData = APP_DELEGATE.arrActiveOrder
                        DispatchQueue.main.async {
                            self.tblList.reloadData()
                        }
                    } else {
                        self.viewNoActiveOrder.isHidden = false
                        self.tblList.isHidden = true
                    }
                })
            } else {
                Utils.hideProgressHud()
                self.viewEquipment.isHidden = true
            }
        })
    }

    
    func callCheckEquipIDApi(EquipOrderId:Int,completionHandler: @escaping  (Bool) -> ()){
        Utils.showProgressHud()
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Home.setEquipmentID
        let param = ["DeviceInventoryID":self.txtEquipment.text!,"OrderID":EquipOrderId] as [String : Any]
       API_SHARED.callCommonParseApiwithDictParameter(strUrl:apiUrl, passValue:param ) { (dicResponseWithSuccess ,_)  in
      
           if  let jsonResponse = dicResponseWithSuccess {
               guard jsonResponse.dictionary != nil else {
                   return
               }
               if let dicResponseData = jsonResponse.dictionary {
                   print("Response in:\(dicResponseData)")
                   Utils.hideProgressHud()
                   if dicResponseData["StatusCode"]?.stringValue == "OK"{
                       completionHandler(true)

                   } else {
                       Utils.showMessage(type: .error, message: dicResponseData["Message"]?.stringValue ?? "This device is already assigned to other order.Please Check the device number.")
                       completionHandler(false)
                   }
               }
           } else {
               Utils.hideProgressHud()
               Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
               completionHandler(false)
           }
       }
    }

    @IBAction func btnCartClick(_ sender: Any) {
        self.view.endEditing(true)
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<Users>(entityName: "Users")
        do{
            let result = try managedObjectContext.fetch(request)
            if result.count > 0 {
                let managedObject = result[0]
                if managedObject.isExtendOrder == "yes" {
                    strIsEditOrder = "extend"
                    let help = ExtendReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                    self.navigationController?.pushViewController(help, animated: true)
                } else {
                    strIsEditOrder = ""
                    let activeOrder = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                    self.navigationController?.pushViewController(activeOrder, animated: true)
                }
            } else {
                        strIsEditOrder = ""
                let activeOrder = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                        self.navigationController?.pushViewController(activeOrder, animated: true)
                }
            }catch {
            print("Fetching data Failed")
        }
    }


    @IBAction func btnCloseClick(_ sender: Any) {
        self.view.endEditing(true)
        self.viewEquipment.isHidden = true
    }

    @objc func btnExtendClick(_ sender: UIButton) {
        
        self.callExtendOrderApi(OrderId: self.arrData[sender.tag].OrderID, completionHandler: {success in
                        if success == true  {
                            self.callgetDefaultOperator(opeid: self.dictExtendRes.operatorID, completionHandler: { [self](success) in
                                if success == true {
                                    let help = ExtendReservationVC.instantiate(fromAppStoryboard: .DashBoard)
                                //    help.strIsCome = "active"
                                    help.operatorName = self.dictOpeInfo.firstName + self.dictOpeInfo.lastName
                                    help.OrderId = self.arrData[sender.tag].OrderID
                                    help.dictExtendRes = self.dictExtendRes
                                    self.navigationController?.pushViewController(help, animated: true)
                                } else {
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type:.error, message: self.dictExtendRes.message)
                                }
                            })
                }
                    })
    }

    @objc func btnReturnClick(_ sender: UIButton) {
        OrderId = arrData[sender.tag].OrderID
        self.callCheckReturnDevice(activeOrderId: arrData[sender.tag].OrderID
                                   , completionHandler: {success in
            if success == true {
                let cameraMediaType = AVMediaType.video
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
                switch cameraAuthorizationStatus {
                case .denied,.restricted:
                    self.noCameraFound()
                case .authorized:self.presentCamera()
                case .notDetermined:self.requestCameraPermission()
                @unknown default:
                    self.dismiss(animated: false)
                }
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: "Device already returned")
            }
        })
    }
    func requestCameraPermission() {
   AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
       guard accessGranted == true else {
           Utils.hideProgressHud()
           return
       }
       self.presentCamera()
   })
   }
    func presentCamera() {
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.modalPresentationStyle = .overCurrentContext
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
   }

    func noCameraFound(){
        let alert = UIAlertController(title: "", message: "My Mobility does not have access to your camera.To enable access,tap Settings and turn on Camera", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(action:UIAlertAction) in
                    Utils.hideProgressHud()
            }));

        alert.addAction(UIAlertAction(title: "Open setting", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction) in
            UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)

            }));
            self.present(alert, animated: true, completion: nil)
        }
    
    @IBAction func btnSelectDestClick (_ sender:AnyObject) {
        let loginScene = HomeVC.instantiate(fromAppStoryboard: .DashBoard)
           loginScene.isOpenFrom = "dest"
        let leftMenuViewController = LeftMenuViewController.instantiate(fromAppStoryboard: .DashBoard)
        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: loginScene), leftMenuViewController: leftMenuViewController)
        sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: false, scaleBackground: false))
        sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 1.0))
        sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.clear, opacity: 0.6, radius: 6.0))
        APP_DELEGATE.navVC = UINavigationController(rootViewController: sideMenu)
        APP_DELEGATE.navVC?.navigationBar.isHidden = true
        APP_DELEGATE.window?.rootViewController =  APP_DELEGATE.navVC
        APP_DELEGATE.window?.makeKeyAndVisible()
    }

    //MARK:- Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ActiveCell = tblList.dequeueReusableCell(withIdentifier: "ActiveCell", for: indexPath) as! ActiveCell
        cell.lblSearchName.text = arrData[indexPath.row].LocationName
        if arrData[indexPath.row].emvId == ""  {
            cell.btnInfo.isUserInteractionEnabled = true
            let selectedString =  "Enter Your Equipment Id"
            cell.lblOrderAndEquip.text = AppConstants.OrderNumber + arrData[indexPath.row].FormatedOrderID
            let lblText =  selectedString
            let rangeToUnderLine = (lblText as NSString).range(of:selectedString)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            let attributedText = NSMutableAttributedString(string:lblText)
            attributedText.addAttribute(.underlineStyle,value: NSUnderlineStyle.single.rawValue, range: rangeToUnderLine)
            attributedText.addAttribute(.foregroundColor, value: AppConstants.kColor_Primary, range: rangeToUnderLine)
            cell.lblEquipId.attributedText = attributedText
            cell.lblEquipId.addGestureRecognizer(tapGesture)
            cell.lblEquipId.isUserInteractionEnabled = true
        } else {
            cell.btnInfo.isUserInteractionEnabled = true
            cell.lblEquipId.text = AppConstants.EquipmentID + arrData[indexPath.row].emvId
            cell.lblOrderAndEquip.text = AppConstants.OrderNumber + arrData[indexPath.row].FormatedOrderID
        }

//
        let strArr = (arrData[indexPath.row].RateSelected).components(separatedBy: "*")
        cell.lblvheicleName.text = arrData[indexPath.row].DeviceTypeName
        if strArr.count > 1 {
            cell.lblvheiclePrice.text = "$\(String(format: "%.2f", arrData[indexPath.row].ProfilePrice))/\(strArr[0])\(strArr[1])"

        } else {
            cell.lblvheiclePrice.text = "$\(String(format: "%.2f", arrData[indexPath.row].ProfilePrice))/\(strArr[0])"
        }
      //  cell.lblTimeRemain.text = arrData[indexPath.row].RemainingTime
        
        let startDateArr = arrData[indexPath.row].ArrivalDate.components(separatedBy: " ")
        let endDateArr =    arrData[indexPath.row].DepartureDate.components(separatedBy: " ")
        cell.lblvheicleDate.text = startDateArr[0] + " To " + endDateArr[0]
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        
        let getCurrentDate = formatter.string(from: Date())
        let Currentdate = formatter.date(from:getCurrentDate)!
        let ArrivalDate = formatter.date(from:arrData[indexPath.row].ArrivalDate)!
        let DepatureDate = formatter.date(from: arrData[indexPath.row].DepartureDate)!
        cell.btnReturn.isUserInteractionEnabled =  true
        cell.btnReturn.backgroundColor = AppConstants.kColor_Primary
        cell.btnReturn.titleLabel?.textColor = UIColor.white
        cell.btnExtend.isUserInteractionEnabled = true
        cell.btnExtend.backgroundColor = UIColor(red: 76/244.0, green: 183.0/244.0, blue: 83/244.0, alpha: 1)

        if ArrivalDate > Currentdate {
            cell.strStartDate = nil
            cell.lblTimeRemainBottom.text = "Future Order Starting in:"
            cell.lblTimeRemain.textColor = UIColor.black
            cell.startDate = ArrivalDate
            cell.endDate = DepatureDate
            cell.strStartDate = nil
            cell.btnReturn.isUserInteractionEnabled =  false
            cell.btnReturn.backgroundColor = UIColor.lightGray
            cell.btnReturn.titleLabel?.textColor = UIColor.white
            cell.setupTimer(with: indexPath.row)
        }
        let getVal = Currentdate.isBetween(ArrivalDate, and: DepatureDate)
               
        if getVal == true {
            cell.lblTimeRemainBottom.text = "Return Order in:"
            cell.endDate = DepatureDate
            cell.lblTimeRemain.textColor = UIColor.black
            cell.strStartDate = nil
            cell.setupTimer(with: indexPath.row)
        }

        if Currentdate > DepatureDate {
            cell.strStartDate = "not"
            cell.lblTimeRemainBottom.text = "Order past Due:"
            cell.endDate = DepatureDate
            cell.lblTimeRemain.textColor = UIColor.red
//            cell.btnExtend.isUserInteractionEnabled = false
//            cell.btnExtend.backgroundColor = UIColor.lightGray
            cell.setupTimer(with: indexPath.row)
        }
            
        if arrData[indexPath.row].IsGPSEnabled ==  true {
            cell.imgBattery.isHidden = false
            cell.lblLevelofBattery.isHidden = false
            cell.lbltxtlevelofBattery.isHidden = false
//            let batteryPer = arrData[indexPath.row].batt_level
            
            if arrData[indexPath.row].batt_level != nil {
                print("ERROR")
            } else {
                let batteryPer = arrData[indexPath.row].batt_level
                 if (1...25).contains(Int(batteryPer.replacingOccurrences(of: "%", with: ""))!){
                            cell.imgBattery.image = UIImage(named: "icon_battery_low")
                }
                 if (25...50).contains(Int(batteryPer.replacingOccurrences(of: "%", with: ""))!){
                    cell.imgBattery.image = UIImage(named: "icon_batterty_half")
                }
                 if (50...75).contains(Int(batteryPer.replacingOccurrences(of: "%", with: ""))!) {
                            cell.imgBattery.image = UIImage(named: "icon_battery_medium")
                }
                 if (75...100).contains(Int(batteryPer.replacingOccurrences(of: "%", with: ""))!){
                            cell.imgBattery.image = UIImage(named: "icon_battery_full")
                } else {
                    cell.imgBattery.image = UIImage(named: "icon_battery_empty")
                }
                cell.lblLevelofBattery.text! = batteryPer
            }
            
            
            
            
//             if (1...25).contains(Int(batteryPer.replacingOccurrences(of: "%", with: ""))!){
//                        cell.imgBattery.image = UIImage(named: "icon_battery_low")
//            }
//             if (25...50).contains(Int(batteryPer.replacingOccurrences(of: "%", with: ""))!){
//                cell.imgBattery.image = UIImage(named: "icon_batterty_half")
//            }
//             if (50...75).contains(Int(batteryPer.replacingOccurrences(of: "%", with: ""))!) {
//                        cell.imgBattery.image = UIImage(named: "icon_battery_medium")
//            }
//             if (75...100).contains(Int(batteryPer.replacingOccurrences(of: "%", with: ""))!){
//                        cell.imgBattery.image = UIImage(named: "icon_battery_full")
//            } else {
//                cell.imgBattery.image = UIImage(named: "icon_battery_empty")
//            }
//            cell.lblLevelofBattery.text! = batteryPer
            
        } else {
            cell.imgBattery.isHidden = true
            cell.lblLevelofBattery.isHidden = true
            cell.lbltxtlevelofBattery.isHidden = true
        }
        cell.delegate = self
        cell.imgVehicle.sd_setImage(with: URL(string:AppUrl.URL.imgeBase + arrData[indexPath.row].ImagPath))
        cell.imgVehicle.roundedViewCorner(radius: 5)
        cell.imgVehicle.layer.borderColor = UIColor.clear.cgColor
        cell.imgVehicle.layer.borderWidth = 1
        cell.viewContent.roundedViewCorner(radius: 5)
        cell.btnExtend.tag = indexPath.row
        cell.btnReturn.tag = indexPath.row
        cell.btnInfo.tag = indexPath.row
        cell.btnInfo.addTarget(self, action: #selector(btnInfoClick(_:)), for: .touchUpInside)
        cell.btnExtend.addTarget(self, action: #selector(btnExtendClick(_:)), for: .touchUpInside)
        cell.btnReturn.addTarget(self, action: #selector(btnReturnClick(_:)), for: .touchUpInside)
        cell.viewContent.layer.borderWidth = 1
        cell.viewContent.layer.borderColor = AppConstants.kColor_Primary.cgColor
        return cell
    }
    
    @objc func labelTapped(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
        OrderId = self.arrData[gesture.view?.tag  ?? 0].OrderID
        viewEquipment.isHidden = false
    }

    @objc func btnInfoClick(_ sender: UIButton) {
        self.view.endEditing(true)
        OrderId = self.arrData[sender.tag].OrderID
        viewEquipment.isHidden = false
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let strDesc = arrData[indexPath.row].DeviceTypeName
        let heightDesc = strDesc.height(withConstrainedWidth:tableView.frame.size.width - 100.0, font:setFont.regular.of(size: 12)!)  as CGFloat
        if heightDesc < 20 {
            return 230
        } else {
            return 230 + heightDesc
        }
    }
    
    //MARK: -ImagePicker Method
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            let activeOrder = ReturnOrderVC.instantiate(fromAppStoryboard: .DashBoard)
            activeOrder.orderId = self!.OrderId
            activeOrder.imgData = image
            self?.navigationController!.pushViewController(activeOrder, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: {})
    }
    
    //MARK:- Webservice Call
    func callExtendOrderApi(OrderId:Int,completionHandler: @escaping  (Bool) -> ()) {
            if !InternetConnectionManager.isConnectedToNetwork() {
                Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
                return
            }
            Utils.showProgressHud()
            let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.getOrderHistoryDetail
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(OrderId)") { (dicResponseWithSuccess ,_)  in
                                if  let jsonResponse = dicResponseWithSuccess {
                                    guard jsonResponse.dictionary != nil else {
                                        return
                                    }
                                    if let dicResponseData = jsonResponse.dictionary {
                                        self.dictExtendRes = ExtendOrderRes().initWithDictionary(dictionary: dicResponseData)
                
                                        if self.dictExtendRes.statusCode == "OK"  &&  self.dictExtendRes.message == "" {
                                            completionHandler(true)
                                            Utils.hideProgressHud()
                                            
                                        } else{
                                            completionHandler(false)
                                            Utils.hideProgressHud()
                                            Utils.showMessage(type: .error, message: self.dictExtendRes.message)
                                        }
                                }
                                    } else {
                                        Utils.hideProgressHud()
                                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                                        completionHandler(false)
                                    }
                            }
        }

    
    func callCheckReturnDevice(activeOrderId:Int,completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.checkReturnOrder
        API_SHARED.callCommonParseApiwithboolRes(strUrl: apiUrl, passValue: "\(activeOrderId)") { (dicResponseWithSuccess ,_)  in
            if dicResponseWithSuccess ==  false {
                Utils.hideProgressHud()
                completionHandler(true)
            }
        }
    }

    func callgetDefaultOperator(opeid:Int,completionHandler: @escaping  (Bool) -> ()){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.getOperatorByID
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(opeid)") { (dicResponseWithSuccess ,_)  in
        if  let jsonResponse = dicResponseWithSuccess {
            guard jsonResponse.dictionary != nil else {
                return
            }
            if let dicResponseData = jsonResponse.dictionary {
                if dicResponseData["StatusCode"]?.stringValue == "OK" {
                    self.dictOpeInfo  = OccupantListModel().initWithDictionary(dictionary: dicResponseData)
                    Utils.hideProgressHud()
                    completionHandler(true)
                } else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: dicResponseData["Message"]?.stringValue ?? AppConstants.ErrorMessage)
                    completionHandler(false)
                }
            } else {
            Utils.hideProgressHud()
             completionHandler(false)
            Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
        }
    } else {
        completionHandler(false)
        Utils.hideProgressHud()
        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
    }
}
}
    
    func callActiveOrderApi(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.getAllActiveOrder
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(getDesId)") { (dicResponseWithSuccess ,_)  in
            if  let jsonResponse = dicResponseWithSuccess {
                guard jsonResponse.dictionary != nil else {
                    return
                }
                if let dicResponseData = jsonResponse.dictionary {
                    APP_DELEGATE.dictActiveOrderRes = ActiveOrderResModel().initWithDictionary(dictionary: dicResponseData)
                    if APP_DELEGATE.dictActiveOrderRes.statusCode == "OK" {
                        Utils.hideProgressHud()
                        APP_DELEGATE.arrActiveOrder = APP_DELEGATE.dictActiveOrderRes.arrActiveOrder
                        completionHandler(true)
                    } else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: APP_DELEGATE.dictActiveOrderRes.message)
                        completionHandler(false)
                    }
                }
            }
        }
    }
    
    func addBoldText(fullString: NSString, boldPartsOfString: Array<NSString>, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }

}

extension Date {
    func offsetFrom(date: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
        let seconds = "\(difference.second ?? 0)"
        let minutes = "\(difference.minute ?? 0)" + " " + seconds
        let hours = "\(difference.hour ?? 0)" + " " + minutes
        let days = "\(difference.day ?? 0)" + " " + hours
        if let day = difference.day, day          >= 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }

}

