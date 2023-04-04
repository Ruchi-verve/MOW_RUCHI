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
import SwiftyJSON
import WebKit

class AddReservationVC: SuperViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CommonPickerViewDelegate,UITableViewDelegate,UITableViewDataSource , OnCloseClick,OnbtnPopupCloseClick,saveUserData,WKNavigationDelegate{
 
    func getAllUserData(billAdd: String, City: String, isSelect: Int, State: String, stateId: Int, customeNo: String, zip: String) {
    }
    
    func onClosePopup() {
        if self.webView != nil {
            self.webView.removeFromSuperview()
        }
    }
    
    func onClose() {
        if self.cardView != nil {
            self.cardView.removeFromSuperview()
        }
        if self.traingView != nil {
            self.traingView.removeFromSuperview()
        }
    }
    
    //MARK: -PickerView Done
    func didTapDone() {
        self.view.endEditing(true)
        if strPickerTapped == "accessory" {
            let getSelectIndex = PickerAccessory.selectedRow(inComponent: 0)
            isPickerOperator = ""
            txtSelectAccType.text = self.arrAccTypeList[getSelectIndex].accessoryTypeName
            selectAccId = self.arrAccTypeList[getSelectIndex].iD
            txtSelectAccType.endEditing(true)
        }
        
        if strPickerTapped == "operator" {
            if arrOperatorList.count > 0 {
                let selIndex = picker.selectedRow(inComponent: 0)
                self.isDefaultOperator = arrOperatorList[selIndex].isDefault
                txtSelectOperator.text = arrOperatorList[selIndex].fullName
                OperatorId = self.arrOperatorList[selIndex].operatorID
                btnCheckboxOccupant.isSelected = false
                isPickerOperator = "Done"
                if strOccupantAvailable == "Yes" {
              CommonApi.callOccupantList(CustId: OperatorId, completionHandler: { [self](success) in
                                     if success == true {
                                         self.view.endEditing(true)
                                        self.txtSelectOccupant.text = ""
                                        self.arrOccupantList.removeAll()
                                         self.arrOccupantList = Arr_OccupantList
                                         let dict = OccupantListModel()
                                         dict.fullName = "Select Occupant".capitalized
                                         self.arrOccupantList.insert(dict, at: 0)
                                         if self.arrOccupantList.count > 0 {
                                             self.txtSelectOccupant.isUserInteractionEnabled = true
                                         } else {
                                             self.txtSelectOccupant.isUserInteractionEnabled = false
                                         }
                                     } else {
                                         self.view.endEditing(true)
                                         self.txtSelectOccupant.isUserInteractionEnabled = false
                                         self.txtSelectOccupant.text = ""
                                         self.arrOccupantList.removeAll()
                                         Utils.showMessage(type: .error, message:"No Occupants found")
                                     }
                    })
                }
            }
        }

        if strPickerTapped == "occupant" {
            let getSelectedIndex  = PickerOccupant.selectedRow(inComponent: 0)
            let name  = arrOccupantList[getSelectedIndex].fullName
            txtSelectOccupant.text = name
            OccuId = arrOccupantList[getSelectedIndex].iD
        }
        checkValEveryTime()
     }
    
    @IBOutlet weak var txtSelectOperator: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSelectAccType: SkyFloatingLabelTextField!
    @IBOutlet weak var txtArrivalTime: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDepatureTime: SkyFloatingLabelTextField!
    @IBOutlet weak var txtArrivalDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDepatureDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtRentalPeriod: SkyFloatingLabelTextField!
    @IBOutlet weak var txtRiderRewards: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSelectOccupant: SkyFloatingLabelTextField!

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnRewardPolicy: UIButton!
    @IBOutlet weak var contblHeight: NSLayoutConstraint!
    @IBOutlet weak var viewOccupant: UIView!
    @IBOutlet weak var conViewOccheight: NSLayoutConstraint!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var btnOccupant: UIButton!
    @IBOutlet weak var btnOperator: UIButton!
    @IBOutlet weak var btnCart: AddBadgeToButton!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var viewShortDesc: UIView!
    @IBOutlet weak var webShortDesc: WKWebView!
    @IBOutlet weak var lblheaderOperator: UILabel!
    @IBOutlet weak var lblheaderArrivalDate: UILabel!
    @IBOutlet weak var lblheaderPickupLoc: UILabel!
    @IBOutlet weak var lblheaderDepartureDate: UILabel!
    @IBOutlet weak var lblheaderArrivalTime: UILabel!
    @IBOutlet weak var lblheaderDepartureTime: UILabel!

    @IBOutlet weak var btnSaveOrder: UIButton!
    @IBOutlet weak var btnSave_AddOrder: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnNotif: AddBadgeToButton!

    @IBOutlet weak var btnCheckboxOccupant: UIButton!
    @IBOutlet weak var lblOperatorNote: UILabel!
    
    @IBOutlet weak var lblJoystickPosition: UILabel!
    @IBOutlet weak var lblChairPadReq: UILabel!
    @IBOutlet weak var lblHandController: UILabel!
    @IBOutlet weak var lblPrefferedWheelchairSize: UILabel!
    
    @IBOutlet weak var tblJoystickPosition: UITableView!
    @IBOutlet weak var tblChairPadReq: UITableView!
    @IBOutlet weak var tblHandController: UITableView!
    @IBOutlet weak var tblPrefferedWheelchairSize: UITableView!
    
    @IBOutlet weak var contblJoystickPosHeight: NSLayoutConstraint!
    @IBOutlet weak var contblChairPadReqHeight: NSLayoutConstraint!
    @IBOutlet weak var contblHandControllerHeight: NSLayoutConstraint!
    @IBOutlet weak var contblPrefferedWheelchairSizeHeight: NSLayoutConstraint!
    @IBOutlet weak var conlblOperatorNoteHeight: NSLayoutConstraint!

    @IBOutlet weak var conlblJoystickPosHeight: NSLayoutConstraint!
    @IBOutlet weak var conlblChairPadReqHeight: NSLayoutConstraint!
    @IBOutlet weak var conlblHandControllerHeight: NSLayoutConstraint!
    @IBOutlet weak var conlblPrefferedWheelchairSizeHeight: NSLayoutConstraint!
    @IBOutlet weak var conlblShortDescHeight: NSLayoutConstraint!

    
    lazy var selectArriDate = Date()
    lazy var arrOperatorList = [OperatorListSubRes]()
    lazy var dictApiRes = OperatorListModel()
    var picker = CommonPicker() , PickerAccessory = CommonPicker() ,PickerOccupant = CommonPicker()
    var toolBar =  UIToolbar() ,toolBarAccessory = UIToolbar()
    lazy var arrPickupLocation = [PickupLocationModelSubRes]()
    lazy var arrAccTypeList = [AccessoryTypeSubRes]()
    lazy var arrOccupantList = [OccupantListModel]()
     var OperatorId:Int = 0,selectAccId:Int = 0,UserLocId:Int = 0,billingProfileId : Int = 0
     var isPickerOperator:String = "",strSelectedLoc:String = "",strSave:String = ""
    lazy var dictgetBillingInfo = BillingPriceModel()
    lazy  var dictSamdayRes = SameDayReserModel()
    lazy var dictgetLoctionId = LocationIDModel()
    var deliveryFee:Float =  0,gettaxRate:Float =  0,totalPrice:Float =  0
     var strOccupantAvailable:String = "",getImagePath:String = "", getStartTime:String = "",getEndTime:String = "",isSameday : String = ""
     var traingView: TrainingVideo!
     var webView: WebDataText!
     var cardView: CardAgrement!
    var dictData = [String:JSON]()
     var strDevicePropertyIDs:String = ""
     var strPickupLocInfo = String()
    var arrChairpadReq = [DevicePropertySubResModel]()
    var arrJoystickPos = [DevicePropertySubResModel]()
    var arrHandController = [DevicePropertySubResModel]()
    var arrPrefferedWheelchairSize = [DevicePropertySubResModel]()
    var dictSameOccu = SameOccupantModel()
    var arrSameOccuMapper = [OccupantListModel]()
    var dictProfileData = CustomerAdressModel()
    var custPickupLocId = Int()
    var arrSavedData = [[String:Any]]()
    var filteredArr = [[String:Any]]()
    var arrEditedOrder  = [[String:Any]]()
    var getIndex:Int? = nil
    var shippingAddLine1 = String()
    var shippingAddLine2 = String()
    var shippingZipcode = String()
    var shippingCity = String()
    var shippingDeliveryNote = String()
    var shippingStateID = String()
    var strPickerTapped = String()
    var flotPriceAdjustment :Float =  0.0
    var isDefaultOperator:Bool = false
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        strOccupantAvailable = ""
        OperatorId = 0
        OccuId = 0
        updateAttributedStringWithCharacter(title: "Operator", uilabel: lblheaderOperator)
        updateAttributedStringWithCharacter(title: "Pickup Location", uilabel: lblheaderPickupLoc)
        updateAttributedStringWithCharacter(title: "Arrival Date", uilabel: lblheaderArrivalDate)
        updateAttributedStringWithCharacter(title: "Arrival Time", uilabel: lblheaderArrivalTime)
        updateAttributedStringWithCharacter(title: "Departure Date", uilabel: lblheaderDepartureDate)
        updateAttributedStringWithCharacter(title: "Departure Time", uilabel: lblheaderDepartureTime)

        tblLocation.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tblHandController.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tblJoystickPosition.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tblChairPadReq.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        tblPrefferedWheelchairSize.register(UINib(nibName: "LocationCell", bundle: nil), forCellReuseIdentifier: "LocationCell")
        
        Common.shared.setFloatlblTextField(placeHolder: "Select Operator", textField: txtSelectOperator)
        Common.shared.setFloatlblTextField(placeHolder: "Select Accessory Type", textField: txtSelectAccType)
        Common.shared.setFloatlblTextField(placeHolder: "mm/dd/yyyy", textField: txtArrivalDate)
        Common.shared.setFloatlblTextField(placeHolder: "hh:mm",textField: txtArrivalTime)
        Common.shared.setFloatlblTextField(placeHolder: "mm/dd/yyyy", textField: txtDepatureDate)
        Common.shared.setFloatlblTextField(placeHolder: "hh:mm", textField: txtDepatureTime)
        Common.shared.setFloatlblTextField(placeHolder: "", textField: txtRentalPeriod)
        Common.shared.setFloatlblTextField(placeHolder: "", textField: txtRiderRewards)
        Common.shared.setFloatlblTextField(placeHolder: "Select Occupant", textField: txtSelectOccupant)
        
        
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

        txtRentalPeriod.isUserInteractionEnabled = false
        
        if IsOccupantSame == true {
            conViewOccheight.constant =  0
            conlblOperatorNoteHeight .constant = 0
            txtSelectOccupant.isHidden = true
            strOccupantAvailable = ""
        } else {
            conViewOccheight.constant = (UIDevice.current.userInterfaceIdiom == .pad ? 200:130)
            conlblOperatorNoteHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? 60 : 50
            txtSelectOccupant.isHidden = false
            strOccupantAvailable = "Yes"
        }
        lblOperatorNote.layoutIfNeeded()
        lblOperatorNote.updateConstraintsIfNeeded()
        viewOccupant.updateConstraintsIfNeeded()
        viewOccupant.layoutIfNeeded()
        
        PickerOccupant.delegate = self
        PickerOccupant.dataSource = self
        PickerOccupant.toolbarDelegate = self
        txtSelectOccupant.inputAccessoryView = self.PickerOccupant.toolbar
        
        PickerAccessory.delegate = self
        PickerAccessory.dataSource = self
        PickerAccessory.toolbarDelegate = self
        txtSelectAccType.inputView = self.PickerAccessory
        txtSelectAccType.inputAccessoryView = self.PickerAccessory.toolbar
        
        picker.delegate = self
        picker.dataSource = self
        picker.toolbarDelegate = self
        txtSelectOperator.inputView = self.picker
        txtSelectOperator.inputAccessoryView = self.picker.toolbar

        btnSaveOrder.backgroundColor = UIColor.gray
        btnSave_AddOrder.backgroundColor = UIColor.gray
        btnSaveOrder.isUserInteractionEnabled  = false
        btnSave_AddOrder.isUserInteractionEnabled = false

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if strIsEditOrder == "nop" {
            self.txtArrivalDate.text = ""
            self.txtDepatureDate.text = ""
            self.txtArrivalTime.text = ""
            self.txtDepatureTime.text = ""
            self.txtRiderRewards.text = "0"
            self.txtRentalPeriod.text = ""
            self.lblPrice.text = "$0.00 (excl.tax)"
            arrPrefferedWheelchairSize.filter{ $0.isSelect == 1 }.first?.isSelect = 0
            arrChairpadReq.filter{ $0.isSelect == 1 }.first?.isSelect = 0
            arrHandController.filter{ $0.isSelect == 1 }.first?.isSelect = 0
            arrJoystickPos.filter{ $0.isSelect == 1 }.first?.isSelect = 0
            arrPickupLocation.filter{ $0.isSelected == 1 }.first?.isSelected = 0
            selectAccId = 0
            btnCheckboxOccupant.isSelected = false
            btnOccupant.isSelected = false
            txtSelectOperator.text =  ""
            txtSelectOccupant.text =  ""
            txtSelectAccType.text =  ""
            self.tblLocation.reloadData()
            self.tblHandController.reloadData()
            self.tblJoystickPosition.reloadData()
            self.tblChairPadReq.reloadData()
            self.tblPrefferedWheelchairSize.reloadData()
            return
        }
       // Common.shared.addBadgetoButton(btnNotif, "2", imgNotification)

       // checkCartCount()
        self.lblItemName.text = APP_DELEGATE.itemName
        self.contblPrefferedWheelchairSizeHeight.constant = 0
        self.conlblPrefferedWheelchairSizeHeight.constant = 0
        self.contblHandControllerHeight.constant = 0
        self.conlblHandControllerHeight.constant = 0
        self.contblChairPadReqHeight.constant = 0
        self.conlblChairPadReqHeight.constant = 0
        self.contblJoystickPosHeight.constant = 0
        self.conlblJoystickPosHeight.constant = 0
        self.btnLocation.setTitle(UserDefaults.standard.string(forKey: AppConstants.SelDest), for: .normal)
        self.conlblShortDescHeight.constant = 0
        self.webShortDesc.layoutIfNeeded()
        self.webShortDesc.updateConstraintsIfNeeded()
        let path = Bundle.main.path(forResource: "style", ofType: "css")
       let cssString = try! String(contentsOfFile: path!).components(separatedBy: .newlines).joined()
       let source = """
       var style = document.createElement('style');
       style.innerHTML = '\(cssString)';
       document.head.appendChild(style);
       """
       let userScript = WKUserScript(source: source,
                                     injectionTime: .atDocumentEnd,
                                     forMainFrameOnly: true)
       let userContentController = WKUserContentController()
       userContentController.addUserScript(userScript)
       let configuration = WKWebViewConfiguration()
       configuration.userContentController = userContentController
        webShortDesc.navigationDelegate = self
        webShortDesc.scrollView.isScrollEnabled = false
        webShortDesc.scrollView.bounces = false
        
        DispatchQueue.main.async {
            self.tblJoystickPosition.updateConstraintsIfNeeded()
            self.tblJoystickPosition.layoutIfNeeded()
            self.lblJoystickPosition.updateConstraintsIfNeeded()
            self.lblJoystickPosition.layoutIfNeeded()
            self.tblPrefferedWheelchairSize.updateConstraintsIfNeeded()
            self.tblPrefferedWheelchairSize.layoutIfNeeded()
            self.lblPrefferedWheelchairSize.updateConstraintsIfNeeded()
            self.lblPrefferedWheelchairSize.layoutIfNeeded()
            self.tblChairPadReq.updateConstraintsIfNeeded()
            self.tblChairPadReq.layoutIfNeeded()
            self.lblChairPadReq.updateConstraintsIfNeeded()
            self.lblChairPadReq.layoutIfNeeded()
            self.tblHandController.updateConstraintsIfNeeded()
            self.tblHandController.layoutIfNeeded()
            self.lblHandController.updateConstraintsIfNeeded()
            self.lblHandController.layoutIfNeeded()
        }

        if strIsEditOrder == "yes"  || strIsEditOrder == "back" {
            self.setupUI()
            btnSave_AddOrder.isUserInteractionEnabled = true
            btnSave_AddOrder.backgroundColor = AppConstants.kColor_Primary
            btnSave_AddOrder.setTitle("Update Reservation", for: .normal)
            btnSaveOrder.isHidden = true
        } else if strIsEditOrder == "nop" {
            return
        }
        else{
            callParallelApi()
                btnSave_AddOrder.setTitle("Save & Add an Additional Order", for: .normal)
                btnSaveOrder.isHidden = false
        }

        if OperatorId != 0  && strOccupantAvailable == "Yes"{
            CommonApi.callOccupantList(CustId: OperatorId, completionHandler: { [self](success) in
                if success == true {
                    self.view.endEditing(true)
                    self.arrOccupantList = Arr_OccupantList
                    if self.arrOccupantList.count > 0 {
                        self.txtSelectOccupant.isUserInteractionEnabled = true
                    } else {
                        self.txtSelectOccupant.isUserInteractionEnabled = false
                    }
                } else {
                    self.view.endEditing(true)
                    self.txtSelectOccupant.isUserInteractionEnabled = false
                    Utils.showMessage(type: .error, message:"No Occupants found")
                }
            })
        }
        APP_DELEGATE.fetchData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        strDevicePropertyIDs = ""
        intChairPadReqId = 0
        intHandControllerId = 0
        getchairPadPrice = 0
         intJoystickPosId = 0
        intPrefferedWheelchairSizeId = 0
        OccuId = 0
        strHandController = ""
        strChairPadReq = ""
        strPrefferedWheelchairSize = ""
        strJoystickPos = ""
        getIndex = nil
    }
    override func viewDidAppear(_ animated: Bool) {
        self.loadHTMLContent(APP_DELEGATE.shortDesc, 0.7, self.webShortDesc)

    }
    //MARK: - WEBVIEW Content

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webShortDesc.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
        self.conlblShortDescHeight.constant  = height as! CGFloat

    })

    }
    //MARK: - HTML Content

    func loadHTMLContent(_ htmlContent: String,_ payScale:Float , _ webView:WKWebView) {
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=\(payScale), shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

    //MARK: - CoreData Functionality
    func savetoDatabase(completionHandler: @escaping  (Bool) -> ()) {
        if getIndex != nil {
            let index = IndexPath(row: getIndex!, section: 0)
            let cell: LocationCell = self.tblLocation.cellForRow(at: index) as! LocationCell
            if cell.txtCity.text == "" {
                completionHandler(false)
                return Utils.showMessage(type: .error, message: "Please enter city")
                
            } else if cell.txtState.text == "" {
                completionHandler(false)
                return Utils.showMessage(type: .error, message: "Please select state")

            } else if cell.txtZip.text == "" {
                completionHandler(false)
                return Utils.showMessage(type: .error, message: "Please enter zipcode")
            }
            
        } else { }
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let UsersData = Users(context: managedObjectContext)
        UsersData.isPromoapply = false
        UsersData.total = "\(totalPrice)"
        UsersData.originalPrice = "\(totalPrice)"
        UsersData.regPrice = dictgetBillingInfo.regularPrice
        UsersData.priceAdjustment = flotPriceAdjustment
        UsersData.itemDesc = APP_DELEGATE.shortDesc
        UsersData.accessoryName = txtSelectAccType.text == "Select Accessory Type".capitalized ? "" : txtSelectAccType.text
        UsersData.itemPrice = dictgetBillingInfo.regularPrice
        UsersData.isDefaultOperator = self.isDefaultOperator
        UsersData.isDefault =  btnCheckboxOccupant.isSelected ? true:false
        UsersData.occupantName = IsOccupantSame == false ? txtSelectOccupant.text : ""
        UsersData.operatorName = self.txtSelectOperator.text!
        UsersData.generateBonus = self.dictgetLoctionId.isGenerateAcceptBonusDay
        UsersData.accessoryId = Int32(selectAccId)
        UsersData.orderId = 0
        UsersData.primaryOrderId = 0
        UsersData.pickupLoc = strSelectedLoc
        UsersData.rentalPeriod = txtRentalPeriod.text!
        UsersData.arrivalDate = txtArrivalDate.text!
        UsersData.arrivalTime = txtArrivalTime.text!
        UsersData.depatureDate = txtDepatureDate.text!
        UsersData.depatureTime = txtDepatureTime.text!
        UsersData.isExp = "0"
        UsersData.isOccupant = IsOccupantSame
        UsersData.destination = USER_DEFAULTS.value(forKey:AppConstants.SelDest) as? String ?? ""
        UsersData.deviceTypeId = Int32(APP_DELEGATE.deviceTypeId)
        UsersData.occuId = Int32(OccuId)
        UsersData.opeId = Int32(OperatorId)
        UsersData.itemName = APP_DELEGATE.itemName
        UsersData.taxRate = "\(gettaxRate)"
        UsersData.deliveryFee = "\(deliveryFee)"
        UsersData.billingProfileId = Int32(self.dictgetBillingInfo.billingProfileID)
        UsersData.destinationId = USER_DEFAULTS.value(forKey:AppConstants.selDestId) as! Int32
        UsersData.customerId = USER_DEFAULTS.value(forKey:AppConstants.USER_ID) as! Int32
        UsersData.isPrimaryOrder = true
        UsersData.isShippingAddress = false
                if getIndex != nil {
                    let index = IndexPath(row: getIndex!, section: 0)
                    let cell: LocationCell = self.tblLocation.cellForRow(at: index) as! LocationCell
                    UsersData.isShippingAddress = true
                     UsersData.shippingAddressLine1 = cell.txtBillingAdd.text!
                    UsersData.shippingAddressLine2 = cell.txtAppartment.text!
                    UsersData.shippingCity = cell.txtCity.text!
                    UsersData.shippingStateName = cell.txtState.text!
                    UsersData.shippingStateID = Int32(APP_DELEGATE.otherStateId ?? 0)
                    UsersData.shippingCheckBox = (cell.btnCheckbox.isSelected ? true : false)
                    UsersData.shippingZipcode = cell.txtZip.text!
                    UsersData.shippingDeliveryNote = cell.txtContactNo.text!
                } else {
                    UsersData.isShippingAddress = false
                }
        
        let creditTotal = deliveryFee + gettaxRate + totalPrice
        UsersData.creditTotal = "\(creditTotal)"
        UsersData.strJoyStick =   strJoystickPos
        UsersData.strPreffWheel =  strPrefferedWheelchairSize
        UsersData.strHandCon = strHandController 
        UsersData.strChairpad = strChairPadReq
        UsersData.pickupLocId = Int32(UserLocId)
        UsersData.joyStickId = Int32(intJoystickPosId)
        UsersData.handConId = Int32(intHandControllerId)
        UsersData.chairPadId = intChairPadReqId != 0 ? Int32(intChairPadReqId) : 0
        UsersData.preWheelId = Int32(intPrefferedWheelchairSizeId)
        UsersData.chairPadPrice = Float(getchairPadPrice)
        UsersData.strDevicePropertyIds = strDevicePropertyIDs
        UsersData.rewardPoint = Int32(txtRiderRewards.text!)!
        UsersData.imgPath = getImagePath
        do {
            try managedObjectContext.save()
            completionHandler(true)
        } catch {
            print("Storing data Failed")
            completionHandler(false)
        }
    }
    
    func fetchSavedData() {
        filteredArr.removeAll()
        print("Fetching Data..")
       
        if managedObjectContext != nil {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            request.returnsObjectsAsFaults = false
            do {
                let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
                if result.count > 0 {
                    arrSavedData = Common.shared.convertToJSONArray(moArray: result) as! [[String : Any]]
                    print("ArrSaved Data is:\(arrSavedData)")
                    btnSave_AddOrder.setTitle("Update Reservation", for: .normal)
                    btnSaveOrder.isHidden = true
                } else  {
                    btnSave_AddOrder.setTitle("Save & Add an Additional Order", for: .normal)
                    btnSaveOrder.isHidden = false
                }
                self.setupUI()
            } catch {
                print("Fetching data Failed")
            }
        }
    }
    
    func setupUI() {
        self.contblChairPadReqHeight.constant = 0
        self.conlblChairPadReqHeight.constant = 0
        
        self.conlblJoystickPosHeight.constant = 0
        self.contblJoystickPosHeight.constant = 0
       
        self.contblHandControllerHeight.constant = 0
        self.contblPrefferedWheelchairSizeHeight.constant = 0
        
        self.conlblPrefferedWheelchairSizeHeight.constant = 0
        self.conlblHandControllerHeight.constant = 0
        
        self.tblHandController.updateConstraintsIfNeeded()
        self.tblHandController.layoutIfNeeded() //1
        self.tblPrefferedWheelchairSize.updateConstraintsIfNeeded()
        self.tblPrefferedWheelchairSize.layoutIfNeeded() //2
        self.tblJoystickPosition.updateConstraintsIfNeeded()
        self.tblJoystickPosition.layoutIfNeeded() //3
        self.tblChairPadReq.updateConstraintsIfNeeded()
        self.tblChairPadReq.layoutIfNeeded() // 4
        
        self.lblHandController.updateConstraintsIfNeeded()
        self.lblHandController.layoutIfNeeded() //1
        self.lblPrefferedWheelchairSize.updateConstraintsIfNeeded()
        self.lblPrefferedWheelchairSize.layoutIfNeeded() //2
        self.lblJoystickPosition.updateConstraintsIfNeeded()
        self.lblJoystickPosition.layoutIfNeeded() //3
        self.lblChairPadReq.updateConstraintsIfNeeded()
        self.lblChairPadReq.layoutIfNeeded() // 4

        Utils.showProgressHud()
            self.txtArrivalDate.text = APP_DELEGATE.dictEditedData["arrivalDate"] as? String
            self.txtDepatureDate.text = APP_DELEGATE.dictEditedData["depatureDate"] as? String
            self.txtDepatureTime.text = APP_DELEGATE.dictEditedData["depatureTime"] as? String
            self.txtArrivalTime.text = APP_DELEGATE.dictEditedData["arrivalTime"] as? String
            self.txtRentalPeriod.text = APP_DELEGATE.dictEditedData["rentalPeriod"] as? String
        self.txtRiderRewards.text = "\(APP_DELEGATE.dictEditedData["rewardPoint"] as? Int ?? 0)"
            self.lblPrice.text = "$\(APP_DELEGATE.dictEditedData["originalPrice"] as? String ?? "0.00") (excl.tax)"
         self.txtSelectAccType .text  = APP_DELEGATE.dictEditedData["accessoryName"] as? String ?? ""
        self.strDevicePropertyIDs  = APP_DELEGATE.dictEditedData["strDevicePropertyIds"] as? String ?? ""
      //  self.flotPriceAdjustment = APP_DELEGATE.dictEditedData["priceAdjustment"] as? Float ?? 0.00
        if strDevicePropertyIDs != ""{
            strPrefferedWheelchairSize = APP_DELEGATE.dictEditedData["strPreffWheel"] as? String ?? ""
            strChairPadReq = APP_DELEGATE.dictEditedData["strChairpad"] as? String ?? ""
            strHandController = APP_DELEGATE.dictEditedData["strHandCon"] as? String ?? ""
            strJoystickPos = APP_DELEGATE.dictEditedData["strJoyStick"] as? String ?? ""
        }
        getchairPadPrice = APP_DELEGATE.dictEditedData["chairPadPrice"] as? Float ?? 0.00
        self.isDefaultOperator = APP_DELEGATE.dictEditedData["isDefaultOperator"] as? NSNumber == 1 ? true:false
        self.totalPrice = Float(APP_DELEGATE.dictEditedData["originalPrice"] as? String ?? "0.00")!
        OccuId = APP_DELEGATE.dictEditedData["occuId"] as? Int ?? 0
        OperatorId = APP_DELEGATE.dictEditedData["opeId"] as? Int ?? 0
        gettaxRate = Float(APP_DELEGATE.dictEditedData["taxRate"] as? String ?? "0.00")!
        selectAccId = APP_DELEGATE.dictEditedData["accessoryId"] as? Int ?? 0 
        deliveryFee = Float(APP_DELEGATE.dictEditedData["deliveryFee"] as? String ?? "0.00")!
        billingProfileId = APP_DELEGATE.dictEditedData["billingProfileId"] as? Int ?? 0
        strSelectedLoc = APP_DELEGATE.dictEditedData["pickupLoc"] as? String ?? ""
        self.callParallelApi()
    }
    
   
    //MARK: - UIAction Method
    @IBAction func btnBackClick(_ sender: Any) {
//        if strIsEditOrder == "yes" || strIsEditOrder == "back" {
//            strIsEditOrder = ""
//            APP_DELEGATE.dictEditedData = [:]
//            self.navigationController?.popToRootViewController(animated: false)
//        } else{
            self.navigationController?.popViewController(animated: false)
//        }
    }

    @IBAction func btnHomeClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnSaveClick(_ sender: Any) {
        self.view.endEditing(true)
        
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<Users>(entityName: "Users")
        do{
            let result = try managedObjectContext.fetch(request)
            if result.count > 0 {
                let managedObject = result[0]
                if managedObject.isExtendOrder == "yes" {
                    Common.shared.deleteUserDatabase()
                    Common.shared.deleteDatabase()
                    savetoDatabase(completionHandler: {success in
                        if success == true {
                            let help = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                            self.navigationController?.pushViewController(help, animated: true)

                        }
                    })
                } else {
                    savetoDatabase(completionHandler: {success in
                        if success == true {
                            let help = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                            self.navigationController?.pushViewController(help, animated: true)

                        }
                    })

                }
            } else {
                savetoDatabase(completionHandler: {success in
                    if success == true {
                        let help = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                        self.navigationController?.pushViewController(help, animated: true)

                    }
                })
            }
            }catch {
            print("Fetching data Failed")
        }
    }
    
    @IBAction func  btnRewardClick(_ sender:AnyObject) {
        self.view.endEditing(true)
        APP_DELEGATE.isComeFrom = "reservation"
        APP_DELEGATE.strtxtDisplay = dictData["TemplateContent"]?.stringValue ?? ""
        traingView = TrainingVideo(frame: SCREEN_RECT)
        traingView.delegate = self
        self.view.addSubview(traingView)
        self.view.bringSubviewToFront(traingView)
    }
    
    @IBAction func  btnOccuClick(_ sender:AnyObject) {
        self.view.endEditing(true)
        APP_DELEGATE.isComeFrom = "occupant"
        APP_DELEGATE.strtxtDisplay = dictOccupantOperatorInfo.defineOccupant
        traingView = TrainingVideo(frame: SCREEN_RECT)
        traingView.delegate = self
        self.view.addSubview(traingView)
        self.view.bringSubviewToFront(traingView)
    }
    
    @IBAction func  btnOperatorClick(_ sender:AnyObject) {
        self.view.endEditing(true)
        APP_DELEGATE.isComeFrom = "operator"
        APP_DELEGATE.strtxtDisplay = dictOccupantOperatorInfo.defineOperator
        traingView = TrainingVideo(frame: SCREEN_RECT)
        traingView.delegate = self
        self.view.addSubview(traingView)
        self.view.bringSubviewToFront(traingView)
    }
    
    @IBAction func btnNewOpeClick(_ sender: Any) {
        self.view.endEditing(true)
        let retrive = AddEditOperatorVC.instantiate(fromAppStoryboard: .DashBoard)
        retrive.isNewOpe = "New"
        retrive.dictNewData = self.dictProfileData
            self.navigationController?.pushViewController(retrive, animated: true)
    }
    
    @IBAction func btnSelectDestClick(_ sender: Any) {
        self.view.endEditing(true)
        for controller in self.navigationController!.viewControllers as Array {
                   if controller.isKind(of: HomeVC.self) {
                       let getVC = controller as! HomeVC
                       getVC.isOpenFrom = "dest"
                       self.navigationController!.popToViewController(getVC, animated: true)
                       break
                   }
               }
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        self.view.endEditing(true)
        if btnSave_AddOrder.titleLabel?.text == "Update Reservation" {
            fetchAndUpdateData(completionHandler: {success in
                if success == true {
                    let help = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                    self.navigationController?.pushViewController(help, animated: true)
                }
            })
        } else {
            savetoDatabase(completionHandler: {success in
                if success == true {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
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
                    let help = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                    help.strCardTapped = "cart"
                    self.navigationController?.pushViewController(help, animated: true)
                }
            } else {
                        strIsEditOrder = ""
                let help = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                help.strCardTapped = "cart"
                self.navigationController?.pushViewController(help, animated: true)
                }
            }catch {
            print("Fetching data Failed")
        }
    }

    @IBAction func btnAddNewOccupantClick(_ sender: Any) {
        if txtSelectOperator.text ==  "" {
            return Utils.showMessage(type: .error, message: "Please select operator first")
        } else {
            let help = AddOccupantVC.instantiate(fromAppStoryboard: .DashBoard)
            help.operatorId = OperatorId
           // help.dictOpeInfo = dictSameOccu
            help.isCome = "reservation"
            self.navigationController?.pushViewController(help, animated: true)
        }
    }
    
    @IBAction func btnCheckboxOccupantClick(_ sender: Any) {
        if txtSelectOperator.text ==  "" {
            return Utils.showMessage(type: .error, message: "Please select operator first")
        } else {
            btnCheckboxOccupant.isSelected = !btnCheckboxOccupant.isSelected
            if btnCheckboxOccupant.isSelected == false {
                self.txtSelectOccupant.text  = ""
                if OperatorId != 0  && strOccupantAvailable == "Yes"{
                    self.txtSelectOccupant.isUserInteractionEnabled = true
                    CommonApi.callOccupantList(CustId: OperatorId, completionHandler: { [self](success) in
                        if success == true {
                            self.view.endEditing(true)
                            self.arrOccupantList = Arr_OccupantList
                            if self.arrOccupantList.count > 0 {
                                self.txtSelectOccupant.isUserInteractionEnabled = true
                            } else {
                                self.txtSelectOccupant.isUserInteractionEnabled = false
                            }
                        } else {
                            self.view.endEditing(true)
                            self.txtSelectOccupant.isUserInteractionEnabled = false
                            Utils.showMessage(type: .error, message:"No Occupants found")
                        }
                    })
                }
                
            } else {
                btnCheckboxOccupant.isSelected = true
                callAddCheckSameOccupantApi(completionHandler: {(success) in
                    if success == true {
                        self.txtSelectOccupant.text = self.arrSameOccuMapper[1].fullName
                        OccuId = self.arrSameOccuMapper[1].iD
                    }
                })
            }
        }
    }
    
    //MARK: - Function
    
    func fetchExtendData() {
        print("Fetching Data..")
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            request.returnsObjectsAsFaults = false
            do {
                let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
                if result.count > 0 {
                    for dict in result as [NSManagedObject] {
                        if dict.value(forKey: "isExtendOrder") as? String == "yes" {
                            Common.shared.deleteDatabase()
                            Common.shared.deleteUserDatabase()
                        }
                    }
                }
            } catch {
                print("Its an error")
            }
    }
    
    func fetchAndUpdateData(completionHandler: @escaping  (Bool) -> ()) {
        print("Fetching Data..")
        if getIndex != nil {
            let index = IndexPath(row: getIndex!, section: 0)
            let cell: LocationCell = self.tblLocation.cellForRow(at: index) as! LocationCell
            if cell.txtCity.text == "" {
                completionHandler(false)
                return Utils.showMessage(type: .error, message: "Please enter city")
            } else if cell.txtState.text == "" {
                completionHandler(false)
                return Utils.showMessage(type: .error, message: "Please select state")
            } else if cell.txtZip.text == "" {
                completionHandler(false)
                return Utils.showMessage(type: .error, message: "Please enter zipcode")
            }
        } else { }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            request.returnsObjectsAsFaults = false
            do {
                let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
                if result.count > 0 {
                    for dict in result as [NSManagedObject] {
                        if dict.value(forKey: "isEditedOrder") as? Int == 1 {
                                dict.setValue("\(totalPrice)", forKey: "total")
                                dict.setValue("\(totalPrice)", forKey: "originalPrice")
                            if APP_DELEGATE.dictEditedData["occupantName"] as? String != "" {
                                dict.setValue(self.txtSelectOccupant.text, forKey: "occupantName")
                            }
                            if txtArrivalDate.text == APP_DELEGATE.dictEditedData["arrivalDate"] as? String &&  txtDepatureDate.text == APP_DELEGATE.dictEditedData["depatureDate"] as? String && txtArrivalTime.text == APP_DELEGATE.dictEditedData["arrivalTime"] as? String && txtDepatureTime.text == APP_DELEGATE.dictEditedData["depatureTime"] as? String {
                            } else {
                                dict.setValue( dictgetBillingInfo.regularPrice, forKey: "regPrice")
                                dict.setValue(dictgetBillingInfo.regularPrice, forKey: "itemPrice")
                                if APP_DELEGATE.dictEditedData["isRiderRewardApply"]  as? NSNumber == 1 {
                                    dict.setValue(0, forKey: "isRiderRewardApply")
                                    dict.setValue(0.00, forKey: "priceAdjustment")
                                }
                                if APP_DELEGATE.dictEditedData["isPromoapply"]  as? NSNumber == 1 {
                                    dict.setValue(0, forKey: "isPromoapply")
                                    dict.setValue("0.00", forKey: "promoValue")
                                }
                            }
                            if getIndex != nil {
                                let index = IndexPath(row: getIndex!, section: 0)
                                let cell: LocationCell = self.tblLocation.cellForRow(at: index) as! LocationCell
                                dict.setValue(cell.txtBillingAdd.text, forKey:DatabaseStringName.shippingAddressLine1)
                                dict.setValue(cell.txtAppartment.text, forKey:DatabaseStringName.shippingAddressLine2)
                                dict.setValue(cell.txtCity.text, forKey:DatabaseStringName.shippingCity)
                                dict.setValue(cell.txtState.text, forKey:DatabaseStringName.shippingStateName)
                                
                                dict.setValue(Int32(APP_DELEGATE.otherStateId ?? 0), forKey:DatabaseStringName.shippingStateID)
                                dict.setValue(cell.txtZip.text, forKey:DatabaseStringName.shippingZipcode)
                                dict.setValue(cell.txtContactNo.text, forKey:DatabaseStringName.shippingDeliveryNote)
                                dict.setValue(cell.btnCheckbox.isSelected == true ? true : false , forKey: "shippingCheckBox")
                                dict.setValue(true, forKey: "isShippingAddress")
                            } else {
                                dict.setValue(false, forKey: "isShippingAddress")
                                dict.setValue("", forKey:DatabaseStringName.shippingAddressLine1)
                                dict.setValue("", forKey:DatabaseStringName.shippingAddressLine2)
                                dict.setValue("", forKey:DatabaseStringName.shippingCity)
                                dict.setValue("", forKey:DatabaseStringName.shippingStateName)
                                dict.setValue(0, forKey:DatabaseStringName.shippingStateID)
                                dict.setValue("", forKey:DatabaseStringName.shippingZipcode)
                                dict.setValue("", forKey:DatabaseStringName.shippingDeliveryNote)
                                dict.setValue( false , forKey: "shippingCheckBox")
                            }
                            dict.setValue(strSelectedLoc, forKey: "pickupLoc")
                            dict.setValue(self.txtRentalPeriod.text!, forKey: "rentalPeriod")
                            dict.setValue(selectAccId, forKey: "accessoryId")
                            dict.setValue(strDevicePropertyIDs, forKey: "strDevicePropertyIds")
                            dict.setValue(APP_DELEGATE.dictEditedData["destination"] as? String ?? "", forKey: "destination")
                            dict.setValue(APP_DELEGATE.dictEditedData["deviceTypeId"] as? Int ?? 0, forKey: "deviceTypeId")
                            dict.setValue(self.txtArrivalDate.text!, forKey: "arrivalDate")
                            dict.setValue(self.txtArrivalTime.text!, forKey: "arrivalTime")
                            dict.setValue(self.txtDepatureDate.text!, forKey: "depatureDate")
                            dict.setValue(txtSelectAccType.text == "Select Accessory Type" ? "" : txtSelectAccType.text, forKey: "accessoryName")
                            dict.setValue(self.txtDepatureTime.text!, forKey: "depatureTime")
                            dict.setValue(APP_DELEGATE.dictEditedData["itemName"] as? String ?? "", forKey: "itemName")
                            dict.setValue( btnCheckboxOccupant.isSelected ? true:false, forKey: "isDefault")
                            dict.setValue(self.txtSelectOperator.text!, forKey: "operatorName")
                            dict.setValue(OccuId, forKey: "occuId")
                            dict.setValue(OperatorId, forKey: "opeId")
                            dict.setValue("\(gettaxRate)", forKey: "taxRate")
                            dict.setValue("\(deliveryFee)", forKey: "deliveryFee")
                            dict.setValue(billingProfileId, forKey: "billingProfileId")
                        let creditTotal = deliveryFee + gettaxRate + totalPrice
                            dict.setValue("\(creditTotal)", forKey: "creditTotal")
                            dict.setValue("\(creditTotal)", forKey: "creditTotal")
                            dict.setValue(strJoystickPos == "" ? "" :strJoystickPos, forKey: DatabaseStringName.strJoy)
                            dict.setValue(strPrefferedWheelchairSize == "" ? "":strPrefferedWheelchairSize , forKey: DatabaseStringName.strPrefWheel)
                            dict.setValue(strChairPadReq, forKey: DatabaseStringName.strChairPad)
                            dict.setValue(strHandController == "" ? "" : strHandController, forKey: DatabaseStringName.strHandCon)
                            dict.setValue(UserLocId, forKey: "pickupLocId")
                            dict.setValue(intJoystickPosId, forKey: DatabaseStringName.joyId)
                            dict.setValue(intChairPadReqId, forKey: DatabaseStringName.chairPadId)
                            dict.setValue(intHandControllerId, forKey: DatabaseStringName.handConId)
                            dict.setValue(intPrefferedWheelchairSizeId, forKey: DatabaseStringName.prefWheelId)
                            dict.setValue(getchairPadPrice, forKey: DatabaseStringName.chairPrice)
                            dict.setValue(Int(txtRiderRewards.text!), forKey: "rewardPoint")
                            do {
                                try managedObjectContext.save()
                                completionHandler(true)
                            } catch {
                                print("Storing data Failed")
                            }
                        } else {
                            print("Nothing will changed")
                        }
                    }
                }
            } catch {
                print("Fetching data Failed")
            }
    }
   
    
    //MARK: - UITableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblHandController{
            return arrHandController.count
        } else if tableView == tblJoystickPosition{
            return arrJoystickPos.count
        } else if tableView == tblPrefferedWheelchairSize{
            return arrPrefferedWheelchairSize.count
        } else if tableView == tblChairPadReq{
            return arrChairpadReq.count
        } else {
            return arrPickupLocation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblJoystickPosition {
        let cell:LocationCell = tblJoystickPosition.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
         cell.lblLocName.text = arrJoystickPos[indexPath.row].devicePropertyOption
                if arrJoystickPos[indexPath.row].isSelect == 0 {
                    cell.btnRadio.isSelected = false
                } else {
                    cell.btnRadio.isSelected = true
                    intJoystickPosId = arrJoystickPos[indexPath.row].devicePropertyOptionID
                    strJoystickPos =  arrJoystickPos[indexPath.row].devicePropertyOption
                }
            cell.btnRadio.tag = indexPath.row
           // checkValEveryTime()
            cell.isCome  = ""
            return cell
        } else if tableView == tblHandController {
            let cell:LocationCell = tblHandController.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            cell.lblLocName.text = arrHandController[indexPath.row].devicePropertyOption
                if arrHandController[indexPath.row].isSelect == 0 {
                    cell.btnRadio.isSelected = false
                } else {
                    cell.btnRadio.isSelected = true
                    intHandControllerId = arrHandController[indexPath.row].devicePropertyOptionID
                    strHandController =  arrHandController[indexPath.row].devicePropertyOption

                }
            cell.btnRadio.tag = indexPath.row
            cell.isCome  = ""
            return cell
        } else if tableView == tblChairPadReq {
            let cell:LocationCell = tblChairPadReq.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            cell.lblLocName.text = arrChairpadReq[indexPath.row].devicePropertyOption + "    " + "$\(String(format: "%.2f", getchairPadPrice))"
            arrChairpadReq[indexPath.row].isSelect = 1
            cell.btnRadio.isSelected = true
            intChairPadReqId = arrChairpadReq[indexPath.row].devicePropertyOptionID
            strChairPadReq = arrChairpadReq[indexPath.row].devicePropertyOption
            cell.btnRadio.tag = indexPath.row
            cell.isCome  = ""
            return cell
        } else if tableView == tblPrefferedWheelchairSize {
            let cell:LocationCell = tblPrefferedWheelchairSize.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            cell.lblLocName.text = arrPrefferedWheelchairSize[indexPath.row].devicePropertyOption
                    if arrPrefferedWheelchairSize[indexPath.row].isSelect == 0 {
                        cell.btnRadio.isSelected = false
                    } else {
                        cell.btnRadio.isSelected = true
                        intPrefferedWheelchairSizeId = arrPrefferedWheelchairSize[indexPath.row].devicePropertyOptionID
                        strPrefferedWheelchairSize = arrPrefferedWheelchairSize[indexPath.row].devicePropertyOption
        }
            cell.btnRadio.tag = indexPath.row
            cell.isCome  = ""
            return cell
            
        } else {
            let cell:LocationCell = tblLocation.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationCell
            cell.lblLocName.text = arrPickupLocation[indexPath.row].customerPickuplocationName
                if arrPickupLocation[indexPath.row].isSelected == 0 {
                    cell.btnRadio.isSelected = false
                } else {
                    cell.btnRadio.isSelected = true
                }
            cell.setDelegate = self
            cell.arrState = APP_DELEGATE.arrGetState
            Common.shared.addSkyTextfieldwithAssertick(to: cell.txtBillingAdd, placeHolder: "Building Name and/or Building No./Address")
            Common.shared.setFloatlblTextField(placeHolder: "Appartment,suit,unit,etc", textField: cell.txtAppartment)
            Common.shared.addSkyTextfieldwithAssertick(to: cell.txtCity, placeHolder: "City")
            Common.shared.addSkyTextfieldwithAssertick(to: cell.txtState, placeHolder: "State")
            Common.shared.addSkyTextfieldwithAssertick(to: cell.txtZip, placeHolder: "Zip")
            Common.shared.setFloatlblTextField(placeHolder: "Contact Person's phone number & delivery location", textField: cell.txtContactNo)
            getIndex = nil
            cell.btnRadio.tag = indexPath.row
            cell.btnCheckbox.tag = indexPath.row
            cell.btnInfo.tag = indexPath.row
            cell.btnInfo.isHidden = true
            if arrPickupLocation[indexPath.row].isAvailableOrNot == true {
                cell.isCome  = "yes"
            }else { cell.isCome  = ""}
            cell.btnInfo.addTarget(self, action: #selector(cellbtnInfoTapped), for: .touchUpInside)
            cell.btnCheckbox.isSelected = false
            cell.dictSetData = dictProfileData
            cell.txtCity.text = ""
            cell.txtState.text = ""
            cell.txtZip.text = ""
            cell.txtAppartment.text = ""
            cell.txtBillingAdd.text = ""
            cell.txtContactNo.text = ""
            APP_DELEGATE.otherStateId = nil
    
            if arrPickupLocation[indexPath.row].isSelected == 1 && arrPickupLocation[indexPath.row].customerPickuplocationName == "OTHER: DIFFERS FROM BILLING ADDRESS AS FOLLOWS:" {
                if strIsEditOrder == "yes" || strIsEditOrder == "back" {
                    if APP_DELEGATE.dictEditedData["isShippingAddress"] as? NSNumber  == 1 && APP_DELEGATE.dictEditedData["shippingCheckBox"] as? NSNumber  == 1 {
                        cell.btnCheckbox.isSelected = true
                    } else {
                        cell.btnCheckbox.isSelected = false
                    }
                    cell.txtBillingAdd.text = APP_DELEGATE.dictEditedData["shippingAddressLine1"] as? String  ?? ""
                    cell.txtAppartment.text! =  APP_DELEGATE.dictEditedData[DatabaseStringName.shippingAddressLine2] as? String ?? ""
                    cell.txtCity.text =  APP_DELEGATE.dictEditedData[DatabaseStringName.shippingCity] as? String ?? ""
                    cell.txtState.text =  APP_DELEGATE.dictEditedData[DatabaseStringName.shippingStateName] as? String ?? ""
                    APP_DELEGATE.otherStateId =  APP_DELEGATE.dictEditedData[DatabaseStringName.shippingStateID] as? Int ?? 0
                    cell.txtZip.text =  APP_DELEGATE.dictEditedData[DatabaseStringName.shippingZipcode] as? String ?? ""
                    cell.txtContactNo.text =  APP_DELEGATE.dictEditedData[DatabaseStringName.shippingDeliveryNote] as? String ?? ""
                }
                contblHeight.constant = CGFloat((self.arrPickupLocation.count * (UIDevice.current.userInterfaceIdiom == .pad ? 28:28) + (UIDevice.current.userInterfaceIdiom == .pad ? 400:400)))
                getIndex = indexPath.row
            } else {
                contblHeight.constant = CGFloat((self.arrPickupLocation.count * (UIDevice.current.userInterfaceIdiom == .pad ? 28:28)))
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

         if tableView == tblPrefferedWheelchairSize{
            arrPrefferedWheelchairSize.filter{ $0.isSelect == 1 }.first?.isSelect = 0
            arrPrefferedWheelchairSize[indexPath.row].isSelect = 1
            checkValEveryTime()
            // DispatchQueue.main.async {
                 self.tblPrefferedWheelchairSize.reloadData()
             //}
        }
        else if tableView == tblJoystickPosition{
            arrJoystickPos.filter{ $0.isSelect == 1 }.first?.isSelect = 0
            arrJoystickPos[indexPath.row].isSelect = 1
            checkValEveryTime()
           // DispatchQueue.main.async {
                self.tblJoystickPosition.reloadData()

           // }
        }
        else if tableView == tblHandController{
            arrHandController.filter{ $0.isSelect == 1 }.first?.isSelect = 0
            arrHandController[indexPath.row].isSelect = 1
            checkValEveryTime()
           // DispatchQueue.main.async {
                self.tblHandController.reloadData()
           // }
        } else {
            arrPickupLocation.filter{ $0.isSelected == 1 }.first?.isSelected = 0
            arrPickupLocation[indexPath.row].isSelected = 1
            
            strSelectedLoc = arrPickupLocation[indexPath.row].customerPickuplocationName
            UserLocId = arrPickupLocation[indexPath.row].customerPickupLocationID
            checkValEveryTime()
            self.tblLocation.reloadData()
           // }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblChairPadReq || tableView == tblJoystickPosition || tableView == tblHandController ||  tableView == tblPrefferedWheelchairSize{
            return UIDevice.current.userInterfaceIdiom == .pad ?  30 : 28
        }
        else {
            if arrPickupLocation[indexPath.row].isSelected == 1 && arrPickupLocation[indexPath.row].customerPickuplocationName == "OTHER: DIFFERS FROM BILLING ADDRESS AS FOLLOWS:" {
                return UIDevice.current.userInterfaceIdiom == .pad ?  400 : 400
            } else {
                return UIDevice.current.userInterfaceIdiom == .pad ?  28 : 28
            }
        }
    }
    
    @objc func cellbtnInfoTapped(_ sender:UIButton) {
        UserLocId = arrPickupLocation[sender.tag].customerPickupLocationID
        self.callCellInfoApi(pickupLocId: UserLocId)
    }
    
    //MARK: - UItextfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtArrivalDate {
            txtArrivalDate.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtExpirationClick), isDob: false, isTime: false)
            
        }
        else if textField == txtDepatureDate {
            if txtArrivalDate.text == ""{
                self.view.endEditing(true)
                return Utils.showMessage(type: .error, message: "Please select arrival date first")
            }
            
            txtDepatureDate.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtDepatureOnClick), isDob: false, isTime: false)
        }
        
        else if textField == txtArrivalTime {
            if txtArrivalDate.text == ""{
                self.view.endEditing(true)
                return Utils.showMessage(type: .error, message: "Please select  arrival date first")
            }
            
            txtArrivalTime.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtTimeClick), isDob: false,isTime: true)
            
        }
        else  if textField == txtSelectAccType {
            txtSelectAccType.isUserInteractionEnabled = true
            if arrAccTypeList.count == 0 {
                txtSelectAccType.endEditing(true)
                PickerAccessory.reloadAllComponents()
                return Utils.showMessage(type: .error,  message: "No accessory type found")
            } else {
                strPickerTapped = "accessory"
            }
        }
        else  if textField == txtSelectOperator {
            strPickerTapped = "operator"
            picker.reloadAllComponents()
        }
        
        else  if textField == txtSelectOccupant {
            txtSelectOperator.endEditing(true)
            if txtSelectOperator.text == "" {
                txtSelectOccupant.endEditing(true)
                return Utils.showMessage(type: .error, message: "Please select operator first")
            }
            strPickerTapped = "occupant"
            txtSelectOccupant.isUserInteractionEnabled = true
            txtSelectOccupant.inputView = self.PickerOccupant
            txtSelectOccupant.inputAccessoryView = self.PickerOccupant.toolbar
            PickerOccupant.reloadAllComponents()
        }
        
        else if textField == txtDepatureTime {
            if txtDepatureDate.text == ""{
                self.view.endEditing(true)
                return Utils.showMessage(type: .error, message: "Please select  depature date first")
            }
            txtDepatureTime.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtDepatureTimeClick), isDob: false,isTime: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {}
    
    @objc func onDoneTxtExpirationClick() {
        if let  datePicker = self.txtArrivalDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            let currentDateTime = Date()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let getDay = datePicker.date.dayOfWeek()!
            print("getDay is:\(getDay)")
            let currentDate = dateFormatter.string(from: currentDateTime)
            selectArriDate = datePicker.date
            self.txtArrivalDate.text = dateFormatter.string(from: datePicker.date)
            if  dateFormatter.string(from: datePicker.date) == currentDate {
                callSameDayApi(day: getDay)
            } else {
                isSameday = ""
            }
            if txtArrivalDate.text != "" && txtDepatureDate.text != nil && txtArrivalTime.text != "" && txtDepatureTime.text != "" {
                callApi()
            }
            //checkValEveryTime()
        }
        self.txtArrivalDate.resignFirstResponder()
    }
    
    
    
    
    @objc func onDoneTxtDepatureOnClick() {
        self.view.endEditing(true)
        
        if let  datePicker = self.txtDepatureDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MM/dd/yyyy"
            if compareDates(dateA:selectArriDate, dateB: datePicker.date) == false{
                txtDepatureDate.text = ""
                self.view.endEditing(true)
                return
            }

            self.txtDepatureDate.text = dateFormatter.string(from: datePicker.date)
            if txtArrivalDate.text != "" && txtDepatureDate.text != "" && txtArrivalTime.text != "" && txtDepatureTime.text != "" {
                callApi()
            }
           // checkValEveryTime()
        }
        self.txtDepatureDate.resignFirstResponder()
    }
    
    //MARK: - Disable time display()
    
    @objc func onDoneTxtTimeClick() {
        self.view.endEditing(true)
        if let  datePicker = self.txtArrivalTime.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            datePicker.datePickerMode = .time
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
            if isSameday == "yes"{
                let calendar = Calendar.current

                let divideStartHour_Min = self.getStartTime .components(separatedBy: ":")
                let divideEndHour_Min = self.getEndTime.components(separatedBy: ":")
                let now = datePicker.date
                let eight_today = calendar.date(
                    bySettingHour: Int(divideStartHour_Min[0]) ?? 8,
                    minute: Int(divideStartHour_Min[1]) ?? 0,
                    second: 0,
                    of: now)!
                
                let four_thirty_today = calendar.date(
                    bySettingHour:Int(divideEndHour_Min[0]) ?? 16 ,
                    minute: Int(divideEndHour_Min[1]) ?? 0,
                    second: 0,
                    of: now)!

                if now >= eight_today &&
                    now <= four_thirty_today
                {
                    print("The time is between \(self.getStartTime) and \(self.getEndTime)")
                    var dateComponents = calendar.dateComponents([.month, .day, .year, .hour, .minute], from: datePicker.date)
                    guard var hour = dateComponents.hour, var minute = dateComponents.minute else {
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
                    self.txtArrivalTime.text = dateFormatter.string(from: datePicker.date)
                }
                else  {
                    Utils.showMessage(type: .error, message: "Please select time in between \(self.getStartTime) to \(self.getEndTime)")
                    self.txtArrivalTime.text = ""
                }
            }
            else {
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
                self.txtArrivalTime.text = dateFormatter.string(from: datePicker.date)
            }
            
            if txtArrivalDate.text != "" && txtDepatureDate.text != "" && txtArrivalTime.text != "" && txtDepatureTime.text != "" {
                callApi()
            }
           // checkValEveryTime()
        }
        self.txtArrivalTime.resignFirstResponder()
    }
    
    
    @objc func onDoneTxtDepatureTimeClick() {
        self.view.endEditing(true)
        
        if txtArrivalTime.text ==  "" {
            txtDepatureTime.endEditing(true)
            return Utils.showMessage(type: .error, message: "Please select  arrival  time first")
        }
        
        if let  datePicker = self.txtDepatureTime.inputView as? UIDatePicker {
            let calendar = Calendar.current
            let dateFormatter = DateFormatter()
            datePicker.datePickerMode = .time
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "hh:mm a"
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
            self.txtDepatureTime.text = dateFormatter.string(from: datePicker.date)
            
            if txtArrivalDate.text != "" && txtDepatureDate.text != "" && txtArrivalTime.text != "" && txtDepatureTime.text != "" {
                self.view.endEditing(true)
                callApi()
            }

        }
        self.txtDepatureTime.resignFirstResponder()
    }
    
    func compareDates(dateA:Date,dateB:Date) -> (Bool){
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        switch dateA.compare(dateB) {
        case .orderedAscending     :
            return true
        case .orderedDescending    :
            Utils.showMessage(type: .error, message: "Arrival date can't be greater than depature date")
            return false
        case .orderedSame :  print("The two dates are the same")
            return true
        }
    }
    
    func checkValEveryTime() {

            if txtSelectOperator.text == ""  || strSelectedLoc == "" || txtArrivalTime.text  == "" || txtArrivalDate.text == "" || txtDepatureTime.text ==  "" || txtDepatureDate.text == "" {
                btnSaveOrder.backgroundColor = UIColor.gray
                btnSave_AddOrder.backgroundColor = UIColor.gray
                btnSaveOrder.isUserInteractionEnabled  = false
                btnSave_AddOrder.isUserInteractionEnabled = false
            } else {
                btnSaveOrder.backgroundColor = AppConstants.kColor_Primary
                btnSave_AddOrder.backgroundColor = AppConstants.kColor_Primary
                btnSaveOrder.isUserInteractionEnabled  = true
                btnSave_AddOrder.isUserInteractionEnabled = true
            }
//    }
        
        
        }
    
    //MARK: - Pickerview Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == PickerAccessory {
            return arrAccTypeList.count
        }
        else if pickerView == PickerOccupant {
            return arrOccupantList.count
        }
        return arrOperatorList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == PickerAccessory {
            let name  = arrAccTypeList[row].accessoryTypeName
            return name
        } else if pickerView == PickerOccupant {
            let name  = arrOccupantList[row].fullName
            return name
        }
        //let name  = arrOperatorList[row].firstName + " " + arrOperatorList[row].lastName
        let name  = arrOperatorList[row].fullName

        return name
    }

    //MARK: - Api Calling
    func callApi() {
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.CheckOut.getBillingData
        let getUId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID)
       
        var param = ["pickupDate":txtArrivalDate.text!,
                     "pickupTime":txtArrivalTime.text!,
                     "returnDate":txtDepatureDate.text!,
                     "returnTime":txtDepatureTime.text!,
                     "CustomerID":getUId!,
                     "newReturnDate":"",
                     "newReturnTime":"",
                     "orderId":"",
        ] as [String : Any]
        if strIsEditOrder == "yes" || strIsEditOrder == "back"{
            param["devicetypid"]  = APP_DELEGATE.dictEditedData["deviceTypeId"] as? Int ?? 0
            param ["locationID"] = APP_DELEGATE.dictEditedData["destinationId"] as? Int ?? 0
        } else {
            param["devicetypid"]  = APP_DELEGATE.deviceTypeId
            param ["locationID"] = USER_DEFAULTS.value(forKey: AppConstants.selDestId)!
        }
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
                            weakSelf.totalPrice = weakSelf.dictgetBillingInfo.regularPrice + Float(getchairPadPrice) + weakSelf.flotPriceAdjustment
                            weakSelf.lblPrice.text = String(format: "$%.2f (excl.tax)",weakSelf.totalPrice)
                            weakSelf.txtRiderRewards.text = "\(weakSelf.dictgetBillingInfo.rewardPoint)"
                            weakSelf.billingProfileId = weakSelf.dictgetBillingInfo.billingProfileID
                            weakSelf.txtRentalPeriod.text = weakSelf.dictgetBillingInfo.shortDescription
                            APP_DELEGATE.rewardPoint = weakSelf.dictgetBillingInfo.rewardPoint
                            weakSelf.checkValEveryTime()
                            Utils.hideProgressHud()
                        } else{
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message:weakSelf.dictgetBillingInfo.message)
                            self!.btnSaveOrder.backgroundColor = UIColor.gray
                            self!.btnSave_AddOrder.backgroundColor = UIColor.gray
                            self!.btnSaveOrder.isUserInteractionEnabled  = false
                            self!.btnSave_AddOrder.isUserInteractionEnabled = false
                            
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
    
    func callSameDayApi(day:String) {
        let getDestId = USER_DEFAULTS.value(forKey: AppConstants.selDestId)
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.getSameDay
        let param = ["Day":day,
                     "DeviceTypeId":APP_DELEGATE.deviceTypeId,
                     "LocationId":getDestId!,
        ] as [String : Any]
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
                        weakSelf.dictSamdayRes = SameDayReserModel().initWithDictionary(dictionary: dicResponseData)
                        if weakSelf.dictSamdayRes.statusCode == "OK" {
                            weakSelf.getStartTime = weakSelf.dictSamdayRes.startTime
                            weakSelf.getEndTime = weakSelf.dictSamdayRes.endTime
                            weakSelf.isSameday = "yes"
                            Utils.hideProgressHud()
                        } else{
                            Utils.hideProgressHud()
                            weakSelf.txtDepatureDate.text = ""
                            Utils.showMessage(type: .error, message:"Same day reservations are not allowed")
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

    func callParallelApi(){
        Utils.showProgressHud()
        var destId = Int()
        var deviceId = Int()
        if strIsEditOrder == "yes" ||  strIsEditOrder == "back" {
            destId = APP_DELEGATE.dictEditedData["destinationId"] as? Int ?? 0
            deviceId = APP_DELEGATE.dictEditedData["deviceTypeId"] as? Int ?? 0
        } else {
            destId =  USER_DEFAULTS.value(forKey: AppConstants.selDestId) as!
                Int
            deviceId = APP_DELEGATE.deviceTypeId
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter() // <<---
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        //OPERATOR LIST
        CommonApi.callOperatorListApi(completionHandler: {(success) in
            if success == true {
                DispatchQueue.main.async {
                    self.arrOperatorList = APP_DELEGATE.arrOperatorList
                    if self.arrOperatorList.count > 0 {
                        self.txtSelectOperator.isUserInteractionEnabled = true
                        if strIsEditOrder == "yes" || strIsEditOrder == "back" {
                            self.OperatorId = APP_DELEGATE.dictEditedData["opeId"] as? Int ?? 0
                            self.txtSelectOperator.text  = APP_DELEGATE.dictEditedData["operatorName"] as? String ?? ""
                            if APP_DELEGATE.dictEditedData["occupantName"] as? String == ""{
                                if APP_DELEGATE.dictEditedData["isOccupant"] as? NSNumber == 0 {
                                    DispatchQueue.main.async {
                                        self.conViewOccheight.constant = (UIDevice.current.userInterfaceIdiom == .pad ? 200:130)
                                        self.txtSelectOccupant.isHidden = false
                                    }
                                CommonApi.callOccupantList(CustId: self.OperatorId, completionHandler: {success  in
                                        if success == true {
                                            self.arrOccupantList = Arr_OccupantList
                                        if self.arrOccupantList.count > 0 {
                                            self.txtSelectOccupant.isUserInteractionEnabled = true
                                            let dict = OccupantListModel()
                                            dict.fullName = "Select Occupant".uppercased()
                                            self.arrOccupantList.append(dict)
                                                if APP_DELEGATE.dictEditedData["isDefault"] as? NSNumber == 1 {
                                                    self.btnCheckboxOccupant.isSelected = true
                                                    self.callAddCheckSameOccupantApi(completionHandler: {(success) in
                                                        if success == true {
                                                            self.txtSelectOccupant.text = self.arrSameOccuMapper[0].fullName
                                                            OccuId = self.arrSameOccuMapper[0].iD
                                                        }
                                                        })
                                                } else {
                                                    self.btnCheckboxOccupant.isSelected = false
                                                }
                                                self.PickerOccupant.reloadAllComponents()
                                                self.txtSelectOccupant.text = self.arrOccupantList.filter{$0.iD == APP_DELEGATE.dictEditedData["occuId"] as? Int }.first?.fullName
                                            }
                                        } else {
                                            self.txtSelectOccupant.isUserInteractionEnabled = false
                                        }
                                    })
                                } else {
                                    self.conViewOccheight.constant = 0
                                    self.txtSelectOccupant.isHidden = true
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.conViewOccheight.constant = (UIDevice.current.userInterfaceIdiom == .pad ? 200:130)
                                    self.txtSelectOccupant.isHidden = false
                                }
                                CommonApi.callOccupantList(CustId: self.OperatorId, completionHandler: {success  in
                                    if success == true {
                                        self.arrOccupantList = Arr_OccupantList
                                        if self.arrOccupantList.count > 0 {
                                            if APP_DELEGATE.dictEditedData["isDefault"] as? NSNumber == 1 {
                                                self.btnCheckboxOccupant.isSelected = true
                                                self.callAddCheckSameOccupantApi(completionHandler: {(success) in
                                                    if success == true {
                                                        self.txtSelectOccupant.text = self.arrSameOccuMapper[0].fullName
                                                        OccuId = self.arrSameOccuMapper[0].iD
                                                    }
                                                    })
                                            } else {
                                                self.btnCheckboxOccupant.isSelected = false
                                            }
                                            self.PickerOccupant.reloadAllComponents()
                                            self.txtSelectOccupant.text = self.arrOccupantList.filter{$0.iD == APP_DELEGATE.dictEditedData["occuId"] as? Int }.first?.fullName
                                        }
                                    } else {
                                        self.txtSelectOccupant.isUserInteractionEnabled = false
                                    }
                                })
                            }
                    }
                    }
                    dispatchGroup.leave()   // <<----
                }
            } else {
                self.txtSelectOperator.isUserInteractionEnabled = false
            }
        }, con: self)
        dispatchGroup.enter() // <<---
        Utils.showProgressHud()
        CommonApi.callPickUpLocation(destinationId: destId, devicetypeId: deviceId,completionHandler: {(success) in
            if success == true {
                self.arrPickupLocation  = APP_DELEGATE.arrgetPickupLoc
                if strIsEditOrder == "yes"  || strIsEditOrder == "back"{
                    self.UserLocId = APP_DELEGATE.dictEditedData["pickupLocId"] as? Int ?? 0
                    self.arrPickupLocation.filter{$0.customerPickupLocationID ==  self.UserLocId}.first?.isSelected = 1
                }
                
                DispatchQueue.main.async {
                    self.tblLocation.reloadData()
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        self.contblHeight.constant = CGFloat(self.arrPickupLocation.count * 50)
                    } else {
                        self.contblHeight.constant = CGFloat(self.arrPickupLocation.count * 35)
                    }
                    dispatchGroup.leave()
                }
            }
        })
        dispatchGroup.enter()
        Utils.showProgressHud() // <<---
        //MARK: -Accessory List API
        CommonApi.callAccessoryTypeList(destinationId: destId, deviceTypeId: deviceId,completionHandler: {(success) in
            if success == true {
                self.arrAccTypeList.removeAll()
                self.arrAccTypeList = arrAcceTypeList
                if strIsEditOrder == "yes" || strIsEditOrder == "back" {
                    self.selectAccId = APP_DELEGATE.dictEditedData["accessoryId"] as? Int ?? 0
                    self.txtSelectAccType.text = self.arrAccTypeList.filter{
                        $0.iD == self.selectAccId
                    }.first?.accessoryTypeName
                }
                
                dispatchGroup.leave()   // <<----
            }
        })
        dispatchGroup.enter()
        Utils.showProgressHud() // <<---
        callLocationbyId(completionHandler: {(success) in
            if success == true {
                dispatchGroup.leave()   // <<----
            }
        })
        dispatchGroup.enter() // <<---
        Utils.showProgressHud()
        CommonApi.callGetCustomerProfile(completionHandler: {(success) in
            if success == true {
                self.dictProfileData = dictGetProfileData
                dispatchGroup.leave()
            }
        }, controll: self)

        dispatchGroup.enter()// <<---
        Utils.showProgressHud()
        callRiderRewardApi(completionHandler: {(success) in
            if success == true {
                //Utils.hideProgressHud()
                dispatchGroup.leave()   // <<----
            }
        })
        
        dispatchGroup.enter()// <<---
        Utils.showProgressHud()
        self.callOptionsApi(completionHandler: {(success)in
            if success == true {
                dispatchGroup.leave()   // <<----
            }
        })
        dispatchGroup.notify(queue: .main) {
            Utils.hideProgressHud()
        }
        
    }

    func callLocationbyId(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getLocationById
        var sendDestId = Int()
        if  strIsEditOrder ==  "yes" || strIsEditOrder == "back" {
            sendDestId = APP_DELEGATE.dictEditedData["destinationId"] as? Int ?? 0
        } else{
            sendDestId = USER_DEFAULTS.value(forKey: AppConstants.selDestId) as! Int
        }
        
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(sendDestId)") {[weak self] (dicResponseWithSuccess ,_)  in
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
    
    func callRiderRewardApi(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Policy.getRewardPolicy
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "") {[weak self] (dicResponseWithSuccess ,_)  in
            if let weakSelf = self {
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        weakSelf.dictData = dicResponseData
                        Utils.hideProgressHud()
                        completionHandler(true)
                    }
                } else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                    completionHandler(false)
                    
                }
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
            }
        }
    }
    
    func callOptionsApi(completionHandler: @escaping  (Bool) -> ()) {
        if self.strDevicePropertyIDs != "" {
            Utils.showProgressHud()
            
            if strDevicePropertyIDs.contains("1") {
                CommonApi.callDevicePropertyOptionsApi(id: 1, controll: self, completionHandler: {(success) in
                    if success == true {
                            self.arrJoystickPos = arrPropertyIds
                       
                        if strIsEditOrder == "yes" || strIsEditOrder == "back" {
                            intJoystickPosId = APP_DELEGATE.dictEditedData[DatabaseStringName.joyId] as? Int ?? 0
                            self.arrJoystickPos.filter{$0.devicePropertyOptionID == intJoystickPosId}.first?.isSelect = 1
                        }else {
                            self.arrJoystickPos[0].isSelect  = 1
                            intJoystickPosId =  self.arrJoystickPos[0].devicePropertyOptionID
                            strJoystickPos =  self.arrJoystickPos[0].devicePropertyOption
                        }
                        self.conlblJoystickPosHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? 31 :21
                            self.tblJoystickPosition.reloadData()
                        self.contblJoystickPosHeight.constant = CGFloat(self.arrJoystickPos.count * (UIDevice.current.userInterfaceIdiom == .pad ? 50:30))
                        self.lblJoystickPosition.updateConstraintsIfNeeded()
                        self.lblPrefferedWheelchairSize.layoutIfNeeded()
                        self.tblJoystickPosition.updateConstraintsIfNeeded()
                        self.tblJoystickPosition.layoutIfNeeded()
                        completionHandler(true)
                    }
                })
            }
            
            if strDevicePropertyIDs.contains("2") {
                Utils.showProgressHud()
                CommonApi.callDevicePropertyOptionsApi(id: 2, controll: self, completionHandler: {(success) in
                    if success == true {
                        self.arrPrefferedWheelchairSize = arrPropertyIds

                        if strIsEditOrder == "yes" || strIsEditOrder == "back" {
                            intPrefferedWheelchairSizeId = APP_DELEGATE.dictEditedData[DatabaseStringName.prefWheelId] as? Int ?? 0
                            self.arrPrefferedWheelchairSize.filter{$0.devicePropertyOptionID == intPrefferedWheelchairSizeId}.first?.isSelect = 1
                        }else {
                            self.arrPrefferedWheelchairSize[0].isSelect  = 1
                            intPrefferedWheelchairSizeId =  self.arrPrefferedWheelchairSize[0].devicePropertyOptionID
                            strPrefferedWheelchairSize =  self.arrPrefferedWheelchairSize[0].devicePropertyOption

                        }
                        self.conlblPrefferedWheelchairSizeHeight.constant =  UIDevice.current.userInterfaceIdiom == .pad ? 31:21
                        self.tblPrefferedWheelchairSize.reloadData()
                        self.contblPrefferedWheelchairSizeHeight.constant = CGFloat(self.arrPrefferedWheelchairSize.count *  (UIDevice.current.userInterfaceIdiom == .pad ? 50 : 30))
                        self.lblPrefferedWheelchairSize.updateConstraintsIfNeeded()
                        self.lblPrefferedWheelchairSize.layoutIfNeeded()
                        self.tblPrefferedWheelchairSize.updateConstraintsIfNeeded()
                        self.tblPrefferedWheelchairSize.layoutIfNeeded()
                        completionHandler(true)
                    }
                })
            }
            
            if strDevicePropertyIDs.contains("3") {
                Utils.showProgressHud()
                CommonApi.callDevicePropertyOptionsApi(id: 3, controll: self, completionHandler: {(success) in
                    if success == true {
                        self.arrChairpadReq = arrPropertyIds
                        self.arrChairpadReq[0].isSelect  = 1
                        if strIsEditOrder == "yes" || strIsEditOrder == "back"{
                            intChairPadReqId = APP_DELEGATE.dictEditedData[DatabaseStringName.chairPadId] as? Int ?? 0
                            self.arrChairpadReq.filter{$0.devicePropertyOptionID == intChairPadReqId}.first?.isSelect = 1

                        }
                        self.conlblChairPadReqHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? 31 : 21
                        self.tblChairPadReq.reloadData()
                        self.contblChairPadReqHeight.constant = CGFloat(self.arrChairpadReq.count *  (UIDevice.current.userInterfaceIdiom == .pad ? 50 :30))
                        self.lblChairPadReq.layoutIfNeeded()
                        self.lblChairPadReq.updateConstraintsIfNeeded()
                        self.tblChairPadReq.layoutIfNeeded()
                        self.tblChairPadReq.updateConstraintsIfNeeded()

                        completionHandler(true)
                    }
                })
            }
            
            if strDevicePropertyIDs.contains("4") {
                Utils.showProgressHud()
                CommonApi.callDevicePropertyOptionsApi(id: 4, controll: self, completionHandler: {(success) in
                    if success == true {
                        self.arrHandController = arrPropertyIds
                        if strIsEditOrder == "yes" || strIsEditOrder == "back"{
                            intHandControllerId = APP_DELEGATE.dictEditedData[DatabaseStringName.handConId] as? Int ?? 0
                            self.arrHandController.filter{$0.devicePropertyOptionID == intHandControllerId}.first?.isSelect = 1

                        }else {
                            intHandControllerId =  self.arrHandController[0].devicePropertyOptionID
                            strHandController =  self.arrHandController[0].devicePropertyOption
                            self.arrHandController[0].isSelect  = 1
                        }
                        self.conlblHandControllerHeight.constant =  UIDevice.current.userInterfaceIdiom == .pad ? 31 : 21
                        self.tblHandController.reloadData()
                        self.contblHandControllerHeight.constant = CGFloat(self.arrHandController.count *  (UIDevice.current.userInterfaceIdiom == .pad ? 50:30))
                        self.lblHandController.layoutIfNeeded()
                        self.lblHandController.updateConstraintsIfNeeded()
                        self.tblHandController.layoutIfNeeded()
                        self.tblHandController.updateConstraintsIfNeeded()
                        completionHandler(true)
                    }
                })
            }
        }
        
    }
    
    func callCellInfoApi(pickupLocId:Int){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Policy.getPickupLocationInfo
        let getLocId = USER_DEFAULTS.value(forKey: AppConstants.selDestId)
        let param = ["DeviceTypeID":APP_DELEGATE.deviceTypeId,"LocationID":getLocId!,"PickupLocationID":pickupLocId] as [String : Any]
        API_SHARED.uploadDictToServer(apiUrl: apiUrl , dataToUpload:param) { (dicResponseWithSuccess ,_)  in
            Utils.hideProgressHud()
            if  let jsonResponse = dicResponseWithSuccess {
                guard jsonResponse.dictionary != nil else {
                    return
                }
                self.strPickupLocInfo = (jsonResponse.dictionary?["PickupInstructionContent"]!.stringValue)!
                APP_DELEGATE.strtxtDisplay = self.strPickupLocInfo
                self.webView = WebDataText(frame: SCREEN_RECT)
                self.webView.delegate = self
                self.view.addSubview(self.webView)
                self.view.bringSubviewToFront(self.webView)
                
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
            }
            
        }
    }
    
    func updateAttributedStringWithCharacter(title : String, uilabel: UILabel) {
        let text = title + "*"
        let range = (text as NSString).range(of: "*")
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        uilabel.attributedText = attributedString }

    
    func callAddCheckSameOccupantApi(completionHandler: @escaping  (Bool) -> ()){
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.getAddSameOccu
        API_SHARED.callCommonParseApi(strUrl:apiUrl, controller: self, passValue: "\(OperatorId)") { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        self.dictSameOccu = SameOccupantModel().initWithDictionary(dictionary: dicResponseData)

                        if self.dictSameOccu.statusCode == "OK" {
                            Utils.hideProgressHud()
                            self.arrSameOccuMapper = self.dictSameOccu.arrOccupantMapper
                            let dict = OccupantListModel()
                            dict.fullName = "Select Occupant".capitalized
                            self.arrSameOccuMapper.insert(dict, at: 0)
                            completionHandler(true)
                        } else {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message: self.dictSameOccu.message)
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
}
