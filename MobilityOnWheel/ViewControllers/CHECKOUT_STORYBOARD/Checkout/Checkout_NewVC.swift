//
//  Checkout_NewVC.swift
//  MobilityOnWheel
//
//  Created by Verve on 07/03/22.
//  Copyright © 2022 Verve_Sys. All rights reserved.
//


import UIKit
import CoreData
import WebKit
import SwiftyJSON
//import SwiftyJSON
class Checkout_NewVC: SuperViewController , onClickbtnClose,UITextViewDelegate ,UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate{
    
    
    @IBOutlet var btnNotif:AddBadgeToButton!

    
    @IBOutlet weak var viewHeaderPromotion:UIView!
    @IBOutlet weak var txtPromocode:SkyFloatingLabelTextField!
    @IBOutlet weak var lblHeaderPromoCode:UILabel!
    @IBOutlet weak var btnPromocode:UIButton!
    @IBOutlet weak var viewEnterPromo:UIView!

    
    @IBOutlet weak var viewRiderRewards:UIView!
    @IBOutlet weak var btnCheckRideReward:UIButton!
    @IBOutlet weak var lblRiderRewardPoint:UILabel!


    @IBOutlet weak var lblBillingAddValue:UILabel!
    @IBOutlet weak var btnChangeAdd:UIButton!

    @IBOutlet weak var txtNotes:TLFloatLabelTextView!
    
    @IBOutlet weak var tblItemList: UITableView!
    @IBOutlet weak var contblOrderDetailHeight:NSLayoutConstraint!

    @IBOutlet weak var viewPromoData:UIView!
    @IBOutlet weak var lblPromoDataValue:UILabel!
    @IBOutlet weak var lbltitlePromo:UILabel!

    @IBOutlet weak var viewBonus:UIView!
    @IBOutlet weak var lblBonusDataValue:UILabel!

    @IBOutlet weak var lblProductSubtotalValue:UILabel!
    @IBOutlet weak var lblDeliveryFeeValue:UILabel!
    @IBOutlet weak var lblProductTotalValue:UILabel!
    @IBOutlet weak var lblTaxvalue:UILabel!

    @IBOutlet weak var contblPayHeight:NSLayoutConstraint!
    @IBOutlet weak var tblListCard: UITableView!
    @IBOutlet weak var btnAddCard:UIButton!

    @IBOutlet weak var txtWebText:UITextView!
    
    @IBOutlet var btnTerms:UIButton!

    @IBOutlet weak var btnPlaceOrder:UIButton!

    lazy var arrGetRes  = [AgreeTermsModel]()
    lazy var dictsetRes  =  AgreeTermsModel()
    lazy var arrOpe_DevID = [datastruct]()
    lazy var dictPaidBillingInfo = PaidBillingProfileResponse()
    lazy var dictRewardData = ApplyBonusModel()
    lazy var isRewardTurn:Bool = false
    lazy var arrTrainingParam = [[String:Any]]()
    lazy var arrValidateCartRes = [ValidateCartModel]()
    
    lazy var index: Int = -1
    lazy var isExpand:Bool = false

    lazy var paidBillingProfileId:Int = 0
    lazy var paidDesc:String = ""
    lazy var paidBonusDayProfile:Bool = false
    lazy var paidRewardPoint:Float = 0
    lazy var  deleteId:Int =  0
    
    func onClickbtnClose() {
       
        if APP_DELEGATE.isAgree == true {
            btnTerms.isSelected = true
            setbtnEnabled()
        } else {
            btnTerms.isSelected = false
            setbtnEnabled()
        }
    }
    
    lazy var arrData = [[String:Any]]()
    lazy var arrDataCard  = [CardListSubModel]()
    var cardView: CardAgrement!
    lazy var dictAddress = CustomerAdressModel()
    lazy var arrCheckout = [[String:Any]]()
    lazy var isPromocodeApply:Bool = false
    lazy var isRewardApply:Bool = false

    
    lazy var dictPromotionDetail = PromoCodeModel()
    lazy var arrOpeIdData = [[String:Any]]()
    lazy var isComing  = String()
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        APP_DELEGATE.getPaymentProfileId = 0
        tblItemList.register(UINib(nibName: "PItemCell", bundle: nil), forCellReuseIdentifier: "PItemCell")
        tblListCard.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        APP_DELEGATE.isComeFrom = ""
        txtNotes.textColor = UIColor.black
        txtNotes.keyboardType = .default
        txtNotes.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        txtNotes.text = txtNotes.text.uppercased()
        txtNotes.layer.cornerRadius = 8
        txtNotes.placeholderTextColor = UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)
        txtNotes.titleActiveTextColour = UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)
        txtNotes.titleFont = setFont.regular.of(size: 14)!
        txtNotes.hint = "Special instructions for the entire reservation"
        txtNotes.hintLabel.font = setFont.regular.of(size: 12)!
        txtNotes.tintColor = UIColor.black
        txtNotes.delegate = self
        btnAddCard.imageView?.contentMode = .scaleAspectFit
        btnPlaceOrder.isUserInteractionEnabled = true
        btnPlaceOrder.backgroundColor = AppConstants.kColor_Primary
        self.lblBillingAddValue.text = ""
        APP_DELEGATE.isAgree = false
        self.txtWebText.text = ""
    }
    
    func setTextFieldBorder() {
         Common.shared.setFloatlblTextField(placeHolder: "Enter Code", textField: txtPromocode)
         txtPromocode.backgroundColor = .clear
         self.callParallelApi()
     }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        
        
        print(APP_DELEGATE.arrOpeIdNEW.count)
        
        if APP_DELEGATE.isAgree == true {
            btnTerms.isSelected = true
            setbtnEnabled()
        } else {
            btnTerms.isSelected = false
            setbtnEnabled()
        }
        setTextFieldBorder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isExpand = false
        index  = -1
    }
    
    func setUpUI(){
        Utils.showProgressHud()
            self.lblProductTotalValue.text  = ""
            self.lblTaxvalue.text  = ""
        let getArrPromo = self.arrData.filter {$0["isPromoapply"]as?NSNumber == 1}
        let getRewardPromo = self.arrData.filter {$0["isRiderRewardApply"]as?NSNumber == 1}
        if getArrPromo.count > 0 {
            self.setCalculation()
            self.viewRiderRewards.isHidden = false
        } else if getRewardPromo.count > 0 {
            self.btnCheckRideReward.isSelected = true
            self.setCalculation()
        } else {
            self.btnCheckRideReward.isSelected = false
            self.viewPromoData.isHidden = true
            self.viewBonus.isHidden = true
            self.viewEnterPromo.isHidden = false
            self.lblProductTotalValue.text = String(format: "$%.2f", flotPricewithTax)
            self.lblDeliveryFeeValue.text = strDeliveryFee
            self.lblProductSubtotalValue.text = strSubTotal
            self.lblTaxvalue.text = String(format: "(Include $%.2f Tax)", TaxRate)
            self.lblHeaderPromoCode.text = "Enter Promo Code below and click Submit"
            self.contblOrderDetailHeight.constant =  UIDevice.current.userInterfaceIdiom == .pad ?  CGFloat(self.arrData.count) * 90 : CGFloat(self.arrData.count) * 60
        }
            self.getTermsText ({
                
            CommonApi.callCardDataApi(completionHandler: {
            [self](success) in
                                    if success == true {
                                        self.arrDataCard  = arr_Card_Data
//                                        APP_DELEGATE.getPaymentProfileId == 0 ?
//                                        (self.arrDataCard[APP_DELEGATE.intCardIndex].isSel = "1"):[
                                        self.arrDataCard[APP_DELEGATE.intCardIndex].isSel = "1"
                                        DispatchQueue.main.async {
                                            self.tblListCard.reloadData()
                                        }
                                        self.contblPayHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? CGFloat(self.arrDataCard.count * 120)  : CGFloat(self.arrDataCard.count * 90)
                                    } else {
                                        self.contblPayHeight.constant = 5
                                        self.tblListCard.updateConstraintsIfNeeded()
                                        self.tblListCard.layoutIfNeeded()
                                    }
            }, controler: self)
        self.callGetCustomerAddres({ Utils.hideProgressHud()
        })
        self.tblItemList.updateConstraintsIfNeeded()
        self.tblItemList.layoutIfNeeded()

        })
    }
    func callParallelApi() {
        self.viewBonus.isHidden = true
        self.viewPromoData.isHidden = true
        self.setUpUI()
    }
    
    func setbtnEnabled() {
        btnPlaceOrder.backgroundColor = AppConstants.kColor_Primary
    }
    
    //MARK:- UITableMethod
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblItemList {
            return arrData.count
        }
        return arrDataCard.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblListCard {
            let cell:CardCell = tblListCard.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
            cell.iconSuccess.isHidden = false
            if arrDataCard[indexPath.row].isSel == "1" {
                cell.btndelete.isHidden = true
                cell.iconSuccess.image = UIImage(named: "icon_radio_select")
                APP_DELEGATE.getPaymentProfileId = self.arrDataCard[indexPath.row].iD
            } else  {
                cell.iconSuccess.image = UIImage(named: "icon_radio_unselect")
                cell.btndelete.isHidden = false
            }
            
            cell.lblCardNo.text = arrDataCard[indexPath.row].cardNumber
            let stringToArray = arrDataCard[indexPath.row].ddItem
            let gettingArr = stringToArray.components(separatedBy: " ")
            var createArr = [String]()
            createArr.append(gettingArr[1])
            createArr.append(gettingArr[2])
            createArr.append(gettingArr[3])
            if gettingArr.count > 4 {
                createArr.append(gettingArr[4])
            } else {}
            switch CardType(rawValue:arrDataCard[indexPath.row].cardType) {
            case .Visa:
                cell.imgCard.image = UIImage(named: "icon_visa")
            case .MasterCard:
                cell.imgCard.image = UIImage(named: "icon_master_card")
            case .AmericanExpress:
                cell.imgCard.image = UIImage(named: "icon_american_card")
            case .Discover:
                cell.imgCard.image = UIImage(named: "icon_discover_card")
            default:
                cell.imgCard.image = UIImage(named: "icon_deselect")
            }
            let getResStr = createArr.joined()
            let badchar = CharacterSet(charactersIn: "( )")
            let cleanedstring = getResStr.components(separatedBy: badchar).joined()
            cell.btndelete.tag = indexPath.row
            cell.btndelete.addTarget(self, action: #selector(deleteTapped(_ :)), for: .touchUpInside)
            cell.lblCardName.text = cleanedstring
            return cell
        } else {
            var findTotalPrice = Float()
            let cell:PItemCell = tblItemList.dequeueReusableCell(withIdentifier: "PItemCell", for: indexPath) as! PItemCell
                        cell.lblItemName.text = "\(indexPath.row + 1)." +  "  " + (arrData[indexPath.row]["itemName"] as? String ?? "")
                cell.lblItemQuantity.text  = arrData[indexPath.row]["rentalPeriod"] as? String
                        cell.lblOperatorName.text  = "Operator Name: \(arrData[indexPath.row]["operatorName"] as? String ?? "")"
                        if arrData[indexPath.row]["chairPadPrice"] as? Float != 0 {
                            cell.lblChairPadPrice.isHidden = false
                            cell.lblChairPadPrice.isHidden = false
                            cell.lblChairPadPrice.text = String(format: "$%.2f",arrData[indexPath.row]["chairPadPrice"] as! Float)
                        } else {
                            cell.lblChairPadPrice.isHidden = true
                            cell.lblChairPadReq.isHidden = true
                        }
           ( self.isExpand == true && index == indexPath.row) ? (cell.imgDropDown?.image = UIImage(named: "icon_upside")):(cell.imgDropDown?.image = UIImage(named: "icon_dropDown"))
            
                        if arrData[indexPath.row]["isPromoapply"] as? NSNumber == 1 {
                            cell.lblItemPrice.text = String(format: "$%.2f", ((arrData[indexPath.row]["regPrice"] as! Float) + (arrData[indexPath.row]["priceAdjustment"] as! Float)))
                        } else if arrData[indexPath.row]["isRiderRewardApply"] as? NSNumber == 1 {
                            cell.lblItemPrice.text = String(format: "$%.2f", ((arrData[indexPath.row]["itemPrice"] as! Float) + (arrData[indexPath.row]["priceAdjustment"] as! Float)))
                        } else {
                            cell.lblItemPrice.text = String(format: "$%.2f", ((arrData[indexPath.row]["regPrice"] as! Float) + (arrData[indexPath.row]["priceAdjustment"] as! Float)))
                        }

            
            if arrData[indexPath.row]["occupantName"] as? String != "" && arrData[indexPath.row]["occupantName"] as? String != "Select Occupant" {
                cell.lblRiderFullname.text = "Occupant Name: \(arrData[indexPath.row]["occupantName"] as? String ?? "")"
                cell.conlblOccupantNameHeight.constant = 20
                cell.lblRiderFullname.layoutIfNeeded()
                cell.lblRiderFullname.updateConstraintsIfNeeded()
                
            } else {
                cell.conlblOccupantNameHeight.constant = 0
                cell.lblRiderFullname.layoutIfNeeded()
                cell.lblRiderFullname.updateConstraintsIfNeeded()
            }

            if arrData[indexPath.row]["strPreffWheel"] as? String != "" && arrData[indexPath.row]["strPreffWheel"] as? String != "0" {
                cell.conlbldevicePropertyHeight.constant = 15
                cell.lblDeviceProperty.text = "Wheelchair Size: " +  (arrData[indexPath.row]["strPreffWheel"] as? String ?? "")
                cell.lblDeviceProperty.layoutIfNeeded()
                cell.lblDeviceProperty.updateConstraintsIfNeeded()
            }
             else if arrData[indexPath.row]["strJoyStick"] as? String != "" && arrData[indexPath.row]["strJoyStick"] as? String != "0" {
                cell.conlbldevicePropertyHeight.constant = 15
                cell.lblDeviceProperty.text = "Joystick Position: "+(arrData[indexPath.row] ["strJoyStick"] as? String ?? "")
                cell.lblDeviceProperty.layoutIfNeeded()
                cell.lblDeviceProperty.updateConstraintsIfNeeded()
            }
             else if arrData[indexPath.row]["strHandCon"] as? String != "" && arrData[indexPath.row]["strHandCon"] as? String != "0"{
                cell.conlbldevicePropertyHeight.constant = 15
                cell.lblDeviceProperty.text = "Hand Controller: " + (arrData[indexPath.row]["strHandCon"] as? String ?? "")
                cell.lblDeviceProperty.layoutIfNeeded()
                cell.lblDeviceProperty.updateConstraintsIfNeeded()
            }else {
                cell.conlbldevicePropertyHeight.constant = 0
                cell.lblDeviceProperty.layoutIfNeeded()
                cell.lblDeviceProperty.updateConstraintsIfNeeded()
            }
            
            cell.lblComplimentary.text = "Complimentary Accessory: \(arrData[indexPath.row]["accessoryName"] as? String ?? "")"
            if arrData[indexPath.row]["isPromoapply"] as? NSNumber == 1 {
                let getFlotPrice = (arrData[indexPath.row]["regPrice"] as!Float)  +
                (arrData[indexPath.row]["priceAdjustment"] as!Float)
                cell.lblItemPrice.text = String(format: "Price:   $%.2f",
                                                getFlotPrice)
            }  else if arrData[indexPath.row]["isRiderRewardApply"] as? NSNumber == 1 {
                
                let getFlotPrice = (arrData[indexPath.row]["itemPrice"] as!Float)  +   (arrData[indexPath.row]["priceAdjustment"] as! Float)
                cell.lblItemPrice.text = String(format: "$%.2f",
                                                getFlotPrice)


            } else {
                let getFlotPrice = (arrData[indexPath.row]["regPrice"] as!Float)  +  (arrData[indexPath.row]["priceAdjustment"] as!Float)
                cell.lblItemPrice.text = String(format: "$%.2f",
                                                getFlotPrice)
            }
            cell.lblRental.text = "Rental Period: \(arrData[indexPath.row]["rentalPeriod"] as? String ?? "")"
            if arrData[indexPath.row]["isShippingAddress"] as? NSNumber == 1 {
                cell.lblPickupLoc.text = "Pickup Location: \(arrData[indexPath.row]["pickupLoc"] as! String) \n \(arrData[indexPath.row]["shippingAddressLine1"] as! String) \n \(arrData[indexPath.row]["shippingAddressLine2"] as! String), \(arrData[indexPath.row]["shippingCity"] as! String) \n \(arrData[indexPath.row]["shippingStateName"] as! String),\(arrData[indexPath.row]["shippingZipcode"]  as! String) \n \(arrData[indexPath.row]["shippingDeliveryNote"] as? String ?? "Note:")"
            } else  {
                cell.lblPickupLoc.text = "Pickup Location: \(arrData[indexPath.row]["pickupLoc"] as? String ?? "")"
            }
            cell.lblArrivalTime.text = "Arrival Time: \(arrData[indexPath.row]["arrivalTime"]as? String ?? "")"
                cell.lblDepatureDate.text = "Depature Date: \(arrData[indexPath.row]["depatureDate"] as? String ?? "")"
            cell.lblArrivalDate.text = "Arrival Date: \(arrData[indexPath.row]["arrivalDate"] as? String ?? "")"
            cell.lblDepatureTime.text = "Depature Time: \(arrData[indexPath.row]["depatureTime"] as? String ?? "")"
            cell.lblDestination.text = "Destination: \(arrData[indexPath.row] ["destination"]as? String ?? "")"
            let getTotal = arrData[indexPath.row] ["total"] as? String ?? "0.00"
            findTotalPrice = findTotalPrice + Float(getTotal)!
            //isEditedOrder
            return cell
        }
            
            
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblListCard {
            return  UIDevice.current.userInterfaceIdiom == .pad ? 120 : 90
        } else {
            if indexPath.row == index && isExpand {
                if arrData[indexPath.row]["isShippingAddress"] as? NSNumber == 1 {
                    if arrData[indexPath.row]["strDevicePropertyIds"] as? String != "" && arrData[indexPath.row]["occupantName"] as? String != "" {
                        return (UIDevice.current.userInterfaceIdiom == .pad ? 460:430)
                    } else if arrData[indexPath.row]["occupantName"] as? String == "" &&   arrData[indexPath.row]["strDevicePropertyIds"] as? String != "" {
                        return (UIDevice.current.userInterfaceIdiom == .pad ? 540:400)
                    } else {
                        if arrData[indexPath.row]["strDevicePropertyIds"] as? String != "" {
                            return (UIDevice.current.userInterfaceIdiom == .pad ? 440:370)
                        } else if arrData[indexPath.row]["occupantName"] as? String == "" &&   arrData[indexPath.row]["strDevicePropertyIds"] as? String != "" {
                            return (UIDevice.current.userInterfaceIdiom == .pad ? 420:430)
                        }
                    }
                    return (UIDevice.current.userInterfaceIdiom == .pad ? 450:450)
                } else {
                    if arrData[indexPath.row]["strDevicePropertyIds"] as? String != ""  && arrData[indexPath.row]["occupantName"] as? String != ""  {
                        return (UIDevice.current.userInterfaceIdiom == .pad ? 410:330)
                    } else {
                        if arrData[indexPath.row]["strDevicePropertyIds"] as? String == "" && arrData[indexPath.row]["occupantName"] as? String != "" {
                            return (UIDevice.current.userInterfaceIdiom == .pad ? 410:410)
                        } else {
                            return (UIDevice.current.userInterfaceIdiom == .pad ? 320:280)
                        }
                    }
                }
            } else {
                    return (UIDevice.current.userInterfaceIdiom == .pad ? 60:50)
                }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblListCard {
            for i in 0..<arrDataCard.count {
                if arrDataCard[i].isSel  == "1" {
                    arrDataCard[i].isSel = "0"
                }
            }
            APP_DELEGATE.getPaymentProfileId = arrDataCard[indexPath.row].iD
            arrDataCard[indexPath.row].isSel  = "1"
            APP_DELEGATE.intCardIndex = indexPath.row
            self.setbtnEnabled()
            self.tblListCard.reloadData()
        } else {
            if self.index != -1 {
                self.tblItemList.cellForRow(at: NSIndexPath(row: self.index, section: 0) as IndexPath)?.backgroundColor = UIColor.clear
             }
             if index != indexPath.row {
                 self.isExpand = true
                 self.index = indexPath.row
             } else {
                 // there is no cell selected anymore
                 self.isExpand = false
                 self.index = -1
             }
            DispatchQueue.main.async {
                self.tblItemList.reloadData()
                self.tblItemList.layoutIfNeeded()
                self.contblOrderDetailHeight.constant = self.tblItemList.contentSize.height
                self.tblItemList.updateConstraintsIfNeeded()
            }

        }
    }
    
    @objc func deleteTapped(_ sender:UIButton) {
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to delete selected credit/debit card?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] (action: UIAlertAction!) in
                    deleteId = self.arrDataCard[sender.tag].iD
                    self.callRemoveCard(completionHandler:{(success) in
                        if success == true {
                            Utils.hideProgressHud()
                                Utils.showMessage(type: .success, message: "Remove card successfully!")
                            self.arrDataCard.remove(at: sender.tag)
                            contblPayHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? CGFloat(self.arrDataCard.count * 120) : CGFloat(self.arrDataCard.count * 90)
                            DispatchQueue.main.async {
                                self.tblListCard.reloadData()
                            }
                        } else {
                            Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                        }
                    })
                }) )
        
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.btnCheckRideReward.isSelected = false
                  }))
            present(refreshAlert, animated: true, completion: nil)
        
    }
    //MARK:- UITextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            textView.textColor = UIColor.black
        txtNotes.text =  txtNotes.text.uppercased()
        txtNotes.hintLabel.textColor = UIColor.clear
            txtNotes.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }
    
    func textViewDidChange(_ textView: UITextView) {
        txtNotes.text =  txtNotes.text.uppercased()
        txtNotes.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            txtNotes.hintLabel.textColor = UIColor.lightGray
        }else {
            txtNotes.hintLabel.textColor = UIColor.clear
        }
        textView.textColor = UIColor.black
        txtNotes.text =  txtNotes.text.uppercased()
    }

    //MARK:- UIAction
    
    @IBAction func btnPromocodeClick(_ sender: Any) {
        if txtPromocode.text == "" {
            return Utils.showMessage(type: .error, message: "Please enter promocode")
        } else {
            self.callApplyPromocode()
            self.setbtnEnabled()
        }
    }
    @IBAction func btnHomeClick(_ sender: Any) {
        isComing = ""
        APP_DELEGATE.intCardIndex = 0
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnBackClick(_ sender: Any) {
        APP_DELEGATE.intCardIndex = 0
        self.navigationController?.popViewController(animated: true)
    }


    @IBAction func btnTearmsClick(_ sender: Any) {
        print("APP_DELEGATE.arrOpeIdNEW",APP_DELEGATE.arrOpeIdNEW.count)
        print("APP_DELEGATE.arrOpeId",APP_DELEGATE.arrOpeId.count)
        
        if  APP_DELEGATE.arrOpeIdNEW.count > 0 {
            let activeOrder = TrainingVideo_VC.instantiate(fromAppStoryboard: .CheckOut)
            activeOrder.modalPresentationStyle = .fullScreen
            self.present(activeOrder, animated: true, completion: {
                activeOrder.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            })


        }
}
    
    func getTermsText(_ completionFunc : @escaping()->()) {
        Utils.showProgressHud()
        APP_DELEGATE.arrOpeIdNEW.removeAll()
        APP_DELEGATE.arrOpeId.removeAll()
        arrOpe_DevID.removeAll()
        arrTrainingParam.removeAll()

        var seen = Set<Int>()
        arrData.forEach{ dict in
           // if !seen.contains(dict["deviceTypeId"] as! Int) {
                let dictAdd  = datastruct()
                dictAdd.deviceTypeId = dict["deviceTypeId"] as? Int
                dictAdd.opeId =  dict["opeId"] as? Int
                dictAdd.isDefaultOper = dict["isDefaultOperator"] as? NSNumber == 1 ? true : false
                arrOpe_DevID.append(dictAdd)
              //  seen.insert(dict["deviceTypeId"] as! Int)
           // }
        }
        
        if arrOpe_DevID.count > 0 {
            arrOpe_DevID.forEach{ dict in
                var getDesId = Int()
                var dict1   =  [String:Any]()
                let getUserId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID)
                isComing == "extend" ? (getDesId = arrData[0]["destinationId"] as? Int ?? 0 ) : (                        getDesId = USER_DEFAULTS.value(forKey: AppConstants.selDestId) as! Int)
                dict1["DeviceTypeID"] = dict.deviceTypeId
                dict1["LocationID"] = getDesId
                dict1["CustomerID"] = getUserId ?? 0
                dict1["OperatorID"] = dict.opeId
                dict1["AttestationID"] = 0
                dict1["IsDefaultOperator"] = dict.isDefaultOper
                dict1["RemovedTermsAndConditionCheckbox"] = false
                arrTrainingParam.append(dict1)
            }
            
            callApi(passOpeIdData: arrTrainingParam, completionHandler:{success in
                        if success == true {
                            Utils.hideProgressHud()
                            completionFunc()
                        } else {
                            Utils.hideProgressHud()
                        }
            } )
        }
    }
    
    @IBAction func btnPlaceOrderClick(_ sender: Any) {
        if APP_DELEGATE.getPaymentProfileId  == 0 {
            return Utils.showMessage(type: .error, message: "Please select your payment card")
        }
//        else
     if APP_DELEGATE.isAgree != true {
            setbtnEnabled()
            if APP_DELEGATE.arrOpeIdNEW.count > 0 {
                let activeOrder = TrainingVideo_VC.instantiate(fromAppStoryboard: .CheckOut)
                activeOrder.modalPresentationStyle = .fullScreen
                self.present(activeOrder, animated: true, completion: {
                    activeOrder.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
                })
            }
        } else {
            Common.shared.deleteDatabase()
            if isComing == "extend" {
                self.checkValidateLicApi()
            } else  {
                var arrSetValidateCart = [[String:Any]]()
                for i in 0..<arrData.count {
                    var dictAppend  = [String:Any]()
                    dictAppend["PickUpDate"] = arrData[i]["arrivalDate"] as? String
                    dictAppend["PickUpTime"] = arrData[i]["arrivalTime"] as? String
                    dictAppend["LocationId"] = arrData[i]["destinationId"] as? Int
                    dictAppend["ReturnTime"] = arrData[i]["depatureTime"] as? String
                    dictAppend["ReturnDate"] = arrData[i]["depatureDate"] as? String
                    dictAppend["DeviceId"] = arrData[i]["deviceTypeId"] as? Int
                    arrSetValidateCart.append(dictAppend)
                }
                
                
            callcheckvalidateOrderApi(arrPass: arrSetValidateCart, completionHandler: { success in
                    if success == true {
                        Utils.hideProgressHud()
                        var alertMsg = String()
                        if self.arrValidateCartRes.count > 0 {
                            self.arrValidateCartRes.forEach{ element in
                                alertMsg.append(element.message)
                            }
                            let refreshAlert = UIAlertController(title: "Alert", message: alertMsg, preferredStyle: UIAlertController.Style.alert)
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                        } else  {
                            self.checkValidateLicApi()
                        }
                        }
                    })

            }
        }
    }
    func callcheckvalidateOrderApi(arrPass:[[String:Any]],completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.checkValidateOrder
        API_SHARED.uploadDataToServer(apiUrl: apiUrl , dataToUpload:arrPass) { [self] (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.array != nil else {
                        return
                    }
                    arrValidateCartRes .removeAll()
                    if let jsonArr = jsonResponse.array {
                            for i in 0 ..< jsonArr.count {
                                let objDic = jsonArr[i].dictionary
                                let user = ValidateCartModel().initWithDictionary(dictionary: objDic!)
                                if user.message != "" {
                                    self.arrValidateCartRes.append(user)
                                }
                            }
                            completionHandler(true)
                    }
                    } else {
                        Utils.hideProgressHud()
                        completionHandler(false)
                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                    }
            }
        
        
    }
    
    
    @IBAction func btnCheckReviewClick(_ sender: Any) {}
    
    @IBAction func btnCheckRideRewardClick(_ sender: Any) {
        self.view.endEditing(true)
        if btnCheckRideReward.isSelected == false {
            let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to select Bonus Day profile?", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.callApplyRiderRewardApi()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                self.btnCheckRideReward.isSelected = false
              }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnChangeAddClick(_ sender: Any) {
        let help = ChangeAddressVC.instantiate(fromAppStoryboard: .DashBoard)
        self.navigationController?.pushViewController(help, animated: true)
    }
    
    @IBAction func btnAddCardClick(_ sender: Any) {
        let loginScene = AddCardVC.instantiate(fromAppStoryboard: .DashBoard)
        self.navigationController?.pushViewController(loginScene, animated: true)
    }
    

    //MARK: -CoreData Function
    func UpdateUserData() {
        let request = NSFetchRequest<Users>(entityName: "Users")
        do{
            let result = try managedObjectContext.fetch(request)
            let mangedObj = result[0]
            mangedObj.promoValue = "\(dictPromotionDetail.promotionFigure)"
            mangedObj.isPromoapply = true
            let getItemVal = Float(self.arrData[0]["total"] as? String ?? "0.00")!
         let getcreditTotal = Float(self.arrData[0]["creditTotal"] as? String ?? "0.00")!
        let getRegPrice = self.arrData[0]["itemPrice"] as? Float ?? 0.00
            mangedObj.promoId = Int32((self.arrData[0]["promoId"]as? Int)!)
            mangedObj.promoCode = self.arrData[0]["promoCode"]as? String
            mangedObj.total = "\(getItemVal)"
            mangedObj.creditTotal = "\(getcreditTotal)"
            mangedObj.itemPrice = getRegPrice
            mangedObj.promotionType = (self.arrData[0]["promotionType"] as? Bool)!
            try managedObjectContext.save()
            let result1 = try managedObjectContext.fetch(request)
            arrData = Common.shared.convertToJSONArray(moArray: result1) as! [[String : Any]]
            setCalculation()
        } catch{
            print("Fetching data Failed")
        }
    }


    func updateRewardPointsData() {
        let request = NSFetchRequest<Users>(entityName: "Users")
        do{
            let result = try managedObjectContext.fetch(request)
            let mangedObj = result[0]
            mangedObj.isRiderRewardApply = true
            mangedObj.billingProfileId = Int32((self.arrData[0]["billingProfileId"]as?Int)!)
            mangedObj.itemPrice = self.arrData[0]["itemPrice"] as! Float
            mangedObj.priceAdjustment = self.arrData[0]["priceAdjustment"] as! Float
            mangedObj.extentionPrice = self.arrData[0]["extentionPrice"] as! Float
            mangedObj.extenstionDays = self.arrData[0]["extenstionDays"] as? String
            if self.arrData[0]["paidBilingProfileId"] as! Int != 0 {
                mangedObj.paidBilingProfileId = Int32((self.arrData[0]["paidBilingProfileId"]as?Int)!)
                mangedObj.paidDesricption = self.arrData[0]["paidDesricption"] as? String
                mangedObj.paidRewardPoints = self.arrData[0]["paidRewardPoints"] as! Float
                if self.arrData[0]["paidBonusDayProfile"] as? NSNumber == 1 {
                    mangedObj.paidBonusDayProfile = true
                }
            }
            mangedObj.totalBonusDays = Int32((self.arrData[0]["totalBonusDays"]as?Int)!)
            if arrData[0]["generateBonus"] as? NSNumber == 1 {
                mangedObj.generateBonus = true
            }
            mangedObj.rewardPoint = Int32((self.arrData[0]["rewardPoint"]as?Int)!)
                try managedObjectContext.save()
            let result1 = try managedObjectContext.fetch(request)
            arrData = Common.shared.convertToJSONArray(moArray: result1) as! [[String : Any]]
            setCalculation()
        } catch{
            print("Fetching data Failed")
        }
    }
    
    func setPromoData() {
            if self.isPromocodeApply == true {
                let getItemVal = (self.arrData[0]["itemPrice"] as! Float )
                let deliFee = Float(self.arrData[0]["deliveryFee"] as? String ?? "0.00")!
            if dictPromotionDetail.promotionType == true {
                self.lbltitlePromo.text = "Promo"
                let getPerVal = String(format: "%.2f", (dictPromotionDetail.promotionFigure))
                self.lblPromoDataValue.text = "$\(getPerVal).off"
                let getChairPad = self.arrData[0]["chairPadPrice"] as! Float
                let priceAdj = self.arrData[0]["priceAdjustment"] as! Float
                let getSubtotal =  Float(getItemVal - Float(dictPromotionDetail.promotionFigure)) + getChairPad + priceAdj
                let getCreditTotal =  deliFee + getSubtotal

                self.arrData[0]["total"] = "\(getSubtotal)"
                self.arrData[0]["creditTotal"] = "\(getCreditTotal)"
                self.arrData[0]["itemPrice"] = (getItemVal - Float(dictPromotionDetail.promotionFigure))
                self.arrData[0]["promotionType"] = true
                self.arrData[0]["promoId"] = dictPromotionDetail.promotionID
                self.arrData[0]["promoCode"] = txtPromocode.text!
                self.arrData[0]["promoValue"] = "\(dictPromotionDetail.promotionFigure)"
                
                UpdateUserData()
                        } else {
                        self.lblPromoDataValue.text = String(format: "%.2f%.off", Float(dictPromotionDetail.promotionFigure))
                        let less = getItemVal*(Float(dictPromotionDetail.promotionFigure))/100
                            let getChairPad = self.arrData[0]["chairPadPrice"] as! Float
                            let priceAdj = self.arrData[0]["priceAdjustment"] as! Float
                            let getSubtotal =   (getItemVal - less) + getChairPad + priceAdj
                                let getCreditTotal =   deliFee + getSubtotal
                                self.arrData[0]["total"] = "\(getSubtotal)"
                                self.arrData[0]["creditTotal"] = "\(getCreditTotal)"
                                self.arrData[0]["itemPrice"] = (getItemVal  - less)
                            self.arrData[0]["promoId"] = dictPromotionDetail.promotionID
                            self.arrData[0]["promoCode"] = txtPromocode.text!
                                  self.arrData[0]["promotionType"] = false
                            self.arrData[0]["promoValue"] = "\(dictPromotionDetail.promotionFigure)"
                                        UpdateUserData()
                                }
            }
        if self.isRewardApply == true {
            self.lbltitlePromo.text = "Price Adjustment: Bonus Day(s)"
            self.arrData[0]["extentionPrice"] = self.dictRewardData.price
            self.arrData[0]["extenstionDays"] = self.dictRewardData.extensionDescription
            self.arrData[0]["rewardPoints"] = self.dictRewardData.rewardPoint
            self.dictPaidBillingInfo = self.dictRewardData.dictPaidBillingProfileResponse
                self.arrData[0]["paidBilingProfileId"] = self.dictPaidBillingInfo.billingProfileID
                self.arrData[0]["paidDesricption"] = self.dictPaidBillingInfo.descriptionField
                self.arrData[0]["paidBonusDayProfile"] = self.dictPaidBillingInfo.isBonusDayProfile
                self.arrData[0]["paidRewardPoints"] = self.dictPaidBillingInfo.rewardPoint

            self.lblPromoDataValue.text = "-$\(dictRewardData.priceAdjustment).off"
            self.arrData[0]["itemPrice"] = self.dictRewardData.price
            self.arrData[0]["priceAdjustment"] = self.dictRewardData.priceAdjustment
            self.arrData[0]["rewardPoint"] = Int(self.dictRewardData.rewardPoint)
            self.arrData[0]["generateBonus"] = self.dictRewardData.isBonusDayProfile
            self.arrData[0]["rentalPeriod"] = self.dictRewardData.descriptionField
            self.arrData[0]["totalBonusDays"] = self.dictRewardData.totalBonusDay
            self.arrData[0]["billingProfileId"] = self.dictRewardData.billingProfileID
            self.arrData[0]["chairPadPrice"] = self.dictRewardData.chairPadPrice
            updateRewardPointsData()
        }
    }
    
    // MARK: Get Context
    func openDatabse() {
            self.getAndUpdateDeliveryFeeValue()
        }
    //MARK:- Checkout Data
    func saveData() {
        var getPrimaryOrder : Bool = false
        var generateBonus:Bool =  false
        var promoValue :Float =  0.00
        var isFullBonusDayProfile = false
        var arrListEquip = [[String:Any]]()

        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CheckoutData", in: managedObjectContext)
        for i in 0..<arrData.count {
                let getDict = arrData[i]
                let newUser = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                //Fix Value To Pass JSON
                newUser.setValue(0 , forKey: DatabaseStringName.createdBy)
                newUser.setValue(false , forKey: DatabaseStringName.isCompanyOrder)
                newUser.setValue(0 , forKey: DatabaseStringName.bounceBack)
                newUser.setValue(0, forKey: DatabaseStringName.cashTotal)
                newUser.setValue(0 , forKey: DatabaseStringName.companyID)
                newUser.setValue(0.0 , forKey: DatabaseStringName.companyTaxRate)
                //CALCULATION
                let getDeliveryFee = Float(getDict["deliveryFee"] as!String)!
                let findTaxRate = Float(getDict["taxRate"]as? String ?? "0.00")!
            let totalDeliveryFeeWithTax = Float(String(format:"%.2f",(getDeliveryFee + (getDeliveryFee * (findTaxRate/100.0)))))
                if getDict["isPrimaryOrder"] as? NSNumber == 1 {
                    getPrimaryOrder = true
                } else {
                    getPrimaryOrder  = false
                }
                let getOrignalItemwithChairPad = Float((getDict["regPrice"] as!Float)  +  (getDict ["chairPadPrice"] as!Float))
            let  getItemPrice = getDict["itemPrice"] as!Float
            let strChairPad = getDict[DatabaseStringName.strChairPad] as?  String  ==  "" ? "":"Chair Pad Requirement"
            var strJoy :String = ""
            var strHandCon :String = ""
            var strPrefWheel :String = ""
            if getDict[DatabaseStringName.strJoy] as?  String != "" {
                strJoy = String(format: "Joystick Position:%@", getDict[DatabaseStringName.strJoy] as?  String ?? "")
            }
            if getDict[DatabaseStringName.strHandCon] as?  String != "" {
                strHandCon = String(format:"Hand Controller:%@",  getDict[DatabaseStringName.strHandCon] as?  String ?? "")
            }
            if getDict[DatabaseStringName.strPrefWheel] as?  String != "" {
                strPrefWheel = String(format:"Preferred Wheelchair Size:%@",getDict[DatabaseStringName.strPrefWheel] as?  String ?? "")
            }
            if getDict["generateBonus"] as? NSNumber == 1 {
                    generateBonus = true
                } else {
                    generateBonus = false
                }
                if getDict["isPromoapply"] as?NSNumber == 1 {
                    if getDict["promotionType"] as? NSNumber == 1  {
                        promoValue = 0
                    } else {
                        let promoVal = (Float(getDict["promoValue"]as! String)!)
                        promoValue = ((getDict["regPrice"]as!Float) + (getDict["priceAdjustment"] as! Float) * promoVal) / 100
                        promoValue = (promoValue*10).rounded()/100
                }
        }
            let cashTotal =   getItemPrice - (promoValue)
            let cashTax = (cashTotal.rounded() + getDeliveryFee + (getDict ["chairPadPrice"] as!Float)) * (findTaxRate/100.0)
            newUser.setValue(Double(cashTax).roundToDecimal(2), forKey: DatabaseStringName.taxOnPrice)
            let priceWithTax = Float((Float(String(format: "%.2f",cashTax)) ?? 0.00) + cashTotal.rounded() + getDeliveryFee + +(getDict ["chairPadPrice"] as!Float))
                //PASS VALUE JSON ---- Main Object
                newUser.setValue(getDict["totalBonusDays"]as! Int, forKey: DatabaseStringName.totalBonusDays)
                newUser.setValue(getDict["priceAdjustment"] as! Float, forKey:DatabaseStringName.priceAdjustment)
                newUser.setValue(getDict["occuId"]  as? Int , forKey: DatabaseStringName.occupantID)
                newUser.setValue(getDict["orderId"], forKey: DatabaseStringName.orderID)
                newUser.setValue(getDict["orderId"] , forKey: DatabaseStringName.primaryOrderID)
                newUser.setValue(getPrimaryOrder, forKey: DatabaseStringName.isPrimaryOrder)
                newUser.setValue(getDict["customerId"]as? Int , forKey: DatabaseStringName.customerID)
                newUser.setValue(getDict["destinationId"]as? Int , forKey: DatabaseStringName.pickupLocationID)
                newUser.setValue(Float(getDeliveryFee), forKey: DatabaseStringName.deliveryFee)
                newUser.setValue(totalDeliveryFeeWithTax, forKey: DatabaseStringName.deliveryFeeWithTax)
                newUser.setValue(getDict["opeId"]as?Int, forKey: DatabaseStringName.operatorID)
                newUser.setValue(getDict["pickupLocId"] , forKey: DatabaseStringName.customerPickupLocationId)
                newUser.setValue(getOrignalItemwithChairPad, forKey: DatabaseStringName.deviceOrignalPriceWithChairPad)
                newUser.setValue(findTaxRate , forKey: DatabaseStringName.pickupLocationTaxRate)
                newUser.setValue(generateBonus , forKey: DatabaseStringName.isAcceptBonusDayLocation)
                newUser.setValue(isRewardTurn , forKey: DatabaseStringName.isRewardTurnOn)
            newUser.setValue((btnCheckRideReward.isSelected == true && lblProductSubtotalValue.text!.contains("$0.00")) ? 0 : APP_DELEGATE.getPaymentProfileId , forKey: DatabaseStringName.paymentProfileID)
            let strValue  = String(format:"%.2f",priceWithTax)
                newUser.setValue(Float(strValue), forKey: DatabaseStringName.priceWithTax)
                newUser.setValue(Float(strValue) , forKey: DatabaseStringName.creditTotal)
    //newUser.setValue(Float(String(format:"%.2f",dict["taxRate"])), forKey: DatabaseStringName.taxOnPrice)

    // ADD SAME DATA FOR  SUB ARRAY ---- EQUOPMENT ORDER DETAIL
    var dictEquipOrderDetail = [String:Any]()
    dictEquipOrderDetail[DatabaseStringName.accessoryTypeID] =  getDict["accessoryId"] as? Int
    dictEquipOrderDetail[DatabaseStringName.deviceTypeID] =  getDict["deviceTypeId"]
    dictEquipOrderDetail[DatabaseStringName.equipCustomerID] = getDict["customerId"]as? Int
    dictEquipOrderDetail[DatabaseStringName.equipOperatorID] = getDict["opeId"]as?Int
            dictEquipOrderDetail[DatabaseStringName.note] = strChairPad + strJoy + strHandCon + strPrefWheel +  txtNotes.text
    dictEquipOrderDetail[DatabaseStringName.isSignOnFile] = false
    dictEquipOrderDetail[DatabaseStringName.arrivalDate] = "\(                getDict["arrivalDate"]as?String ?? "") \(getDict["arrivalTime"]as?String ?? "")"
            
    dictEquipOrderDetail[DatabaseStringName.departureDate] = "\(                getDict["depatureDate"]as?String ?? "") \(getDict["depatureTime"]as?String ?? "")"
    dictEquipOrderDetail[DatabaseStringName.joystickID] = getDict[DatabaseStringName.joyId]
    dictEquipOrderDetail[DatabaseStringName.wheelchairSizeID] = getDict[DatabaseStringName.prefWheelId]
    dictEquipOrderDetail[DatabaseStringName.handControllerID] = getDict[DatabaseStringName.handConId]
    dictEquipOrderDetail[DatabaseStringName.chairpadID] = getDict[DatabaseStringName.chairPadId]
    dictEquipOrderDetail[DatabaseStringName.chairPadPrice] = getDict[DatabaseStringName.chairPrice]
    dictEquipOrderDetail[DatabaseStringName.equipPickupLocationID] = getDict["pickupLocId"]as? Int

                  if getDict[DatabaseStringName.isShippingAddress]as?NSNumber == 1 {
                      dictEquipOrderDetail[DatabaseStringName.isShippingAddress] = true
                      dictEquipOrderDetail[DatabaseStringName.shippingAddressLine1] = getDict[DatabaseStringName.shippingAddressLine1]
                      dictEquipOrderDetail[DatabaseStringName.shippingCity] = getDict[DatabaseStringName.shippingCity]
                      dictEquipOrderDetail[DatabaseStringName.shippingAddressLine2] = getDict[DatabaseStringName.shippingAddressLine2]
                      dictEquipOrderDetail[DatabaseStringName.shippingStateName] = getDict[DatabaseStringName.shippingStateName]
                      dictEquipOrderDetail[DatabaseStringName.shippingStateID] = getDict[DatabaseStringName.shippingStateID]
                      dictEquipOrderDetail[DatabaseStringName.shippingZipcode] = getDict[DatabaseStringName.shippingZipcode]
                      dictEquipOrderDetail[DatabaseStringName.shippingDeliveryNote] = getDict[DatabaseStringName.shippingDeliveryNote]
                  } else {
                    dictEquipOrderDetail[DatabaseStringName.isShippingAddress] = false
                }
                  
    // SETUP FOR PROMO CODE CALCULATION
   let getVal = getDict["isPromoapply"]as? NSNumber ?? 0
    if getVal == 1 {
                    dictEquipOrderDetail[DatabaseStringName.promotionID] = getDict["promoId"] as? Int
                    dictEquipOrderDetail[DatabaseStringName.promotionCode] = getDict["promoCode"] as? String
                    dictEquipOrderDetail[DatabaseStringName.promotionType] = getDict["promotionType"] as? NSNumber == 1 ? true : false
                    dictEquipOrderDetail[DatabaseStringName.promotionFigure] = Float(getDict["promoValue"] as? String ?? "0.00")
                    dictEquipOrderDetail[DatabaseStringName.isPromoCodeUsed] = getDict["isPromoapply"] as? NSNumber == 1 ? true : false //isPromoapply
                }
    // ADD SAME DATA FOR  SUB ARRAY ---- LIST OF EQUIPMENT ORDER DETAIL REQUEST
                if getDict["isRiderRewardApply"] as? NSNumber == 1 {
                    if getDict["billingProfileId"] as? Int != 0 && (getDict["paidBilingProfileId"] as? Int == 0  || getDict["paidBilingProfileId"] as? Int == nil){
                        isFullBonusDayProfile = true
                    }
                    dictEquipOrderDetail =  checkRewardUsed(isBonusDayProfile: true, isFullBonusDayProfile:isFullBonusDayProfile , addDataTodictionary: dictEquipOrderDetail, getMainDict: getDict)
                    let jsonData = try? JSONSerialization.data(withJSONObject:dictEquipOrderDetail)
                    newUser.setValue(jsonData, forKey: DatabaseStringName.equipmentOrderDetailRequest)
                    if   getDict["paidBilingProfileId"] as? Int != nil {
                        let getListBilingProfile = checkRewardUsed(isBonusDayProfile: false, isFullBonusDayProfile: isFullBonusDayProfile, addDataTodictionary: dictEquipOrderDetail, getMainDict: getDict)
                        arrListEquip.append(getListBilingProfile)
                        if arrListEquip.count > 0 {
                            let newjsonData = try? JSONSerialization.data(withJSONObject:arrListEquip,options: [])
                            newUser.setValue(newjsonData, forKey: DatabaseStringName.listEquipmentOrderDetail)
                        }
                    }
                } else {
                    arrListEquip.removeAll()
                    dictEquipOrderDetail =  checkRewardUsed(isBonusDayProfile: false, isFullBonusDayProfile:false , addDataTodictionary: dictEquipOrderDetail, getMainDict: getDict)
                    let jsonData = try? JSONSerialization.data(withJSONObject:dictEquipOrderDetail)
                    newUser.setValue(jsonData, forKey: DatabaseStringName.equipmentOrderDetailRequest)
                }
      }
        do {
            try managedObjectContext.save()
        } catch {
            print("Storing data Failed")
        }
        print("Storing Data..")
        fetchSavedData()
    }
 //REWARD FUNCTION
    func checkRewardUsed(isBonusDayProfile:Bool,isFullBonusDayProfile:Bool, addDataTodictionary:[String:Any],getMainDict:[String:Any]) -> [String:Any] {
        
        var dict = [String:Any]()
        dict = addDataTodictionary
        /*
        1) FULL BONUS
        isBonusBillingProfile = TRUE
        isBonusDayProfile = TRUE
        isFullBonusDayProfile = TRUE

        2) HALF BONUS

        2.1 HALF FREE
        isBonusBillingProfile = TRUE
        isBonusDayProfile = TRUE
        isFullBonusDayProfile = FALSE

        2.2 HALF PAID
        isBonusBillingProfile = TRUE
        isBonusDayProfile = FALSE
        isFullBonusDayProfile = FALSE

        3) NOT BONUS PROFILE
         */
        
        if (getMainDict["isRiderRewardApply"] as? NSNumber == 1) {
            if isBonusDayProfile {
                if isFullBonusDayProfile {
                    dict[DatabaseStringName.isBonusBillingProfile] =  true
                    dict[DatabaseStringName.billingProfileID] = getMainDict["billingProfileId"] as? Int
                    dict[DatabaseStringName.riderRewardPoint] = getMainDict["rewardPoint"] as? Int
                    dict[DatabaseStringName.extPrice] = ((getMainDict["itemPrice"] as! Float) + (getMainDict["chairPadPrice"] as! Float))
                    dict[DatabaseStringName.rentalPeriod] = getMainDict["rentalPeriod"] as? String
                    dict[DatabaseStringName.paymentMethodID] = 4
                    let OrgPrice = Float(getMainDict["itemPrice"] as! Float)
                    let strConPrice = String(format: "%.2f", OrgPrice)
                    dict[DatabaseStringName.price] = Float(strConPrice)
                } else {
                    dict[DatabaseStringName.isBonusBillingProfile] =  true
                    dict[DatabaseStringName.billingProfileID] = getMainDict["billingProfileId"] as? Int
                    dict[DatabaseStringName.riderRewardPoint] = Int(getMainDict["paidRewardPoints"] as? Float ?? 0)
                    dict[DatabaseStringName.extPrice] = round((getMainDict["itemPrice"] as! Float) + (getMainDict["chairPadPrice"] as! Float))
                    dict[DatabaseStringName.rentalPeriod] = getMainDict["rentalPeriod"] as? String
                    dict[DatabaseStringName.paymentMethodID] = 1
                    let OrgPrice = Float(getMainDict["itemPrice"] as! Float)
                    let strConPrice = String(format: "%.2f", OrgPrice)
                    dict[DatabaseStringName.price] = Float(strConPrice)

                }
            } else {
                dict[DatabaseStringName.isBonusBillingProfile] =  false
                dict[DatabaseStringName.billingProfileID] = getMainDict["paidBilingProfileId"] as? Int
                dict[DatabaseStringName.riderRewardPoint] = getMainDict["rewardPoint"] as? Int
                dict[DatabaseStringName.extPrice] = (round(getMainDict["itemPrice"] as! Float))
                dict[DatabaseStringName.rentalPeriod] = getMainDict["extenstionDays"] as? String
                dict[DatabaseStringName.paymentMethodID] = 4
                dict[DatabaseStringName.price] = 0.00
            }
        } else {
            dict[DatabaseStringName.isBonusBillingProfile] =  getMainDict["isRiderRewardApply"] as? NSNumber
            dict[DatabaseStringName.billingProfileID] = getMainDict["billingProfileId"] as? Int
            dict[DatabaseStringName.riderRewardPoint] = getMainDict["rewardPoint"] as? Int
            dict[DatabaseStringName.rentalPeriod] = getMainDict["rentalPeriod"] as? String
            dict[DatabaseStringName.paymentMethodID] = 1
            let OrgPrice = Float(getMainDict["itemPrice"] as! Float)
            let strConPrice = String(format: "%.2f", OrgPrice)
            dict[DatabaseStringName.price] = Float(strConPrice)
            
            if getMainDict["isPromoapply"] as? NSNumber ==  1 {
                if getMainDict ["promotionType"] as? NSNumber == 1 {
                    let price = Float(((getMainDict["regPrice"] as! Float) + (getMainDict["chairPadPrice"] as! Float)) - Float(getMainDict["promoValue"]as! String)!)
                    let strPrice = String(format: "%.2f", price)
                    dict[DatabaseStringName.extPrice] = Float(strPrice)
                } else {
                    let less = (getMainDict["regPrice"] as! Float)*(Float(getMainDict["promoValue"]as! String)!)/100
                    let price = Float(((getMainDict["regPrice"] as! Float) + (getMainDict["chairPadPrice"] as! Float)) - less)
                    let strPrice = String(format: "%.2f", price)
                    dict[DatabaseStringName.extPrice] = Float(strPrice)

                }
            } else {
                let price  = Float(((getMainDict["regPrice"] as! Float) + (getMainDict["chairPadPrice"] as! Float)))
                let strPrice = String(format: "%.2f", price)
                dict[DatabaseStringName.extPrice] = Float(strPrice)
            }

        }
        
   return dict
    }
    
    func CheckoutData() {
        openDatabse()
    }
    
    func fetchSavedData() {
        arrCheckout.removeAll()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CheckoutData")
        request.returnsObjectsAsFaults = false
        var dictCheckout = [String:Any] ()
        var arrListOfJSON = [[String:Any]]()
                do{
                    let result1 = try managedObjectContext.fetch(request) as! [NSManagedObject]
                    var getArr = Common.shared.convertToJSONArray(moArray: result1) as! [[String : Any]]
                        for i in 0..<getArr.count {
                            var dict = getArr[i]
                            let getListEquipArr = dict[DatabaseStringName.listEquipmentOrderDetail] as? NSData
                            if  getListEquipArr != nil {
                                let jsonArr = try JSONSerialization.jsonObject(with: getListEquipArr! as Data,options: []) as? [[String : Any]]
                                if jsonArr!.count > 0 {
                                    arrListOfJSON = jsonArr ?? []
                                }
                                dict[DatabaseStringName.listEquipmentOrderDetail] = arrListOfJSON
                            }
                            let getData = dict[DatabaseStringName.equipmentOrderDetailRequest] as? NSData
                         
                            do{
                                let json = try JSONSerialization.jsonObject(with: getData! as Data) as? [String : Any]
                                dictCheckout = json ?? [:]
                                dict[DatabaseStringName.equipmentOrderDetailRequest]  = dictCheckout
                                
                                getArr[i]  = dict
                            }catch{ print("erroMsg") }
                    }
                        arrCheckout = getArr
                        for i  in 0..<arrCheckout.count {
                            var dict = arrCheckout[i]
                        var getSubDict = dict[DatabaseStringName.equipmentOrderDetailRequest] as! [String:Any]
                            if (dict[DatabaseStringName.listEquipmentOrderDetail] != nil){
                                var arrListEquip = dict[DatabaseStringName.listEquipmentOrderDetail] as! [[String:Any]]
                                    dict[DatabaseStringName.isBonusBillingProfile] = Common.shared.convertNumberToBoolValue(getValue: dict[DatabaseStringName.isBonusBillingProfile] as? NSNumber ?? 0)
                                        if arrListEquip.count > 0 {
                                            for  i in 0..<arrListEquip.count {
                                                var dictList = arrListEquip[i]
                                            //CAPITALIZE KEYS
                                                dictList.CapitalizecaseKeys()
                                                arrListEquip[i] = dictList
                                            }
                                        }
                                    dict[DatabaseStringName.listEquipmentOrderDetail] = arrListEquip

                            }

                            //GET NUMBER TO BOOL VALUES
                            let promoBoolValue = Common.shared.convertNumberToBoolValue(getValue: getSubDict[ DatabaseStringName.isPromoCodeUsed] as? NSNumber ?? 0)
                            getSubDict[ DatabaseStringName.isPromoCodeUsed] = promoBoolValue

                            //CAPITALIZE KEYS
                            getSubDict.CapitalizecaseKeys()
                            dict[DatabaseStringName.equipmentOrderDetailRequest] = getSubDict
                            
                            //CONVERT NUMBER TO BOOL VALUES
                            let newRewardBoolValue = Common.shared.convertNumberToBoolValue(getValue: dict[ DatabaseStringName.isRewardTurnOn] as? NSNumber ?? 0)
                            let newPrimaryOrdrBoolValue = Common.shared.convertNumberToBoolValue(getValue:  dict[ DatabaseStringName.isPrimaryOrder] as? NSNumber ?? 0)
                            let newCompanyOrderBoolValue = Common.shared.convertNumberToBoolValue(getValue: dict[ DatabaseStringName.isCompanyOrder] as? NSNumber ?? 0)
                            let newAcceptBonusDayBoolValue = Common.shared.convertNumberToBoolValue(getValue: dict[ DatabaseStringName.isAcceptBonusDayLocation] as? NSNumber ?? 0)
                            
                            dict[DatabaseStringName.isRewardTurnOn] = newRewardBoolValue
                            dict[DatabaseStringName.isPrimaryOrder] = newPrimaryOrdrBoolValue
                            dict[DatabaseStringName.isCompanyOrder] = newCompanyOrderBoolValue
                            dict[DatabaseStringName.isAcceptBonusDayLocation] = newAcceptBonusDayBoolValue
                            let getstr = dict[DatabaseStringName.note] as? String ?? ""
                            dict[DatabaseStringName.note] = txtNotes.text + getstr
                            dict.CapitalizecaseKeys()
                            
                            dict.changeKey(from: AppConstants.equipmentOrderDetailRequest, to: DatabaseStringName.equipmentOrderDetailRequest)
                            dict.changeKey(from: AppConstants.listEquipmentOrderDetail, to: DatabaseStringName.listEquipmentOrderDetail)
                            arrCheckout[i] = dict
                        }
                        print("Final Array is:\(arrCheckout.toJSONString())")
                        callSaveOrderApi()
                    } catch {
                        print("Fetching data Failed")
                    }
}
    
    func updateUI() {

        let getArrPromo = self.arrData.filter {$0["isPromoapply"]as?NSNumber == 1}
        let getRewardPromo  = self.arrData.filter {$0["isRiderRewardApply"]as?NSNumber == 1}
        if getArrPromo.count > 0 {
            self.viewBonus.isHidden = true
            self.viewEnterPromo.isHidden = true
            self.viewPromoData.isHidden = false
            self.viewRiderRewards.isHidden = true
            self.viewHeaderPromotion.isHidden = false
            self.lbltitlePromo.text = "Promo"
            self.lblHeaderPromoCode.text = "Promo code is accepted"
            self.contblOrderDetailHeight.constant = CGFloat(self.arrData.count * 60)
                self.tblItemList.updateConstraintsIfNeeded()
                self.tblItemList.layoutIfNeeded()
        }
        
        if getRewardPromo.count > 0 {
            self.viewBonus.isHidden = true
            self.viewEnterPromo.isHidden = true
            self.viewPromoData.isHidden = false
            self.viewRiderRewards.isHidden = false
            self.viewHeaderPromotion.isHidden = true
            
            self.lblHeaderPromoCode.text = ""
            self.lbltitlePromo.text = "Price Adjustment: Bonus Day(s)"
            self.contblOrderDetailHeight.constant = CGFloat(self.arrData.count * 60)
            self.tblItemList.updateConstraintsIfNeeded()
            self.tblItemList.layoutIfNeeded()
        }
    }
    
    //MARK:- Proper Calculations
    func setCalculation() {
        let getArrPromo = self.arrData.filter {$0["isPromoapply"]as?NSNumber == 1}
        let getRewardPromo  = self.arrData.filter {$0["isRiderRewardApply"]as?NSNumber == 1}
        if getArrPromo.count > 0 {
            self.lbltitlePromo.text = "Promo"
            if getArrPromo[0]["promotionType"] as? NSNumber == 1 {
                self.lblPromoDataValue.text = String(format: "$%.2f.off", Float("\(getArrPromo[0]["promoValue"] as? String  ?? "0.00")")!)
                
            } else {
                self.lblPromoDataValue.text = "\(getArrPromo[0]["promoValue"] as? String  ?? "0.00")%off"
            }
        }
        
        if getRewardPromo.count > 0 {
            self.lbltitlePromo.text = "Price Adjustment: Bonus Day(s)"
            self.lblPromoDataValue.text = String(format: "-$%.2f", (getRewardPromo[0]["priceAdjustment"] as! Float))
           // self.lblExtenstionDay.text =  self.arrData[0]["extenstionDays"] as? String ?? "0 Day"
        }
        var mainTotal = Float()
        var setSubTotal = Float()
        var deliveryFee =   Float()
        var arrSetofData =  Set<DeliveryFeeStruct>()
        var setNewDeliveryFee:Float = 0.0
        TaxRate = 0
        for i in 0..<arrData.count {
            var dict = arrData[i]
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
            let strTotal = (dict["itemPrice"] as? Float ?? 0.00) + (dict ["chairPadPrice"] as!Float)
            setSubTotal = strTotal + setSubTotal //1
            let findTaxRate  =  dict["taxRate"] as? String ?? "0.00"
            let getFlotPriceTax = ((dict["itemPrice"] as!Float)  +  (dict ["chairPadPrice"] as!Float) + setNewDeliveryFee )  * ((Float(findTaxRate)!)/100)
            TaxRate = TaxRate + (getFlotPriceTax)
        }
        self.lblProductSubtotalValue.text = String(format: "$%.2f (excl.tax)",setSubTotal )
        mainTotal = setSubTotal  + (TaxRate*100).rounded() / 100 + deliveryFee
        self.lblProductTotalValue.text = String(format: "$%.2f", (mainTotal))
        self.lblTaxvalue.text = String(format: "(Include $%.2f Tax)", (TaxRate))
        let setDeliveyFee = String(format: "%.2f",deliveryFee )
        self.lblDeliveryFeeValue.text = "$\(setDeliveyFee)"
        flotPricewithTax = (mainTotal)
        updateUI()
    }

    func updateDeliveryFeeCalculation(newdeliveryFee:Float,index:Int){
        
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do{
            let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
            let  dict =  result[index]
            dict.setValue("\(newdeliveryFee)", forKey: "deliveryFee")
            try managedObjectContext.save()
            let result1 = try managedObjectContext.fetch(request) as! [NSManagedObject]
            arrData = Common.shared.convertToJSONArray(moArray: result1) as! [[String : Any]]
        } catch {
                print("Fetching data Failed")
            }
    }
    
    func getAndUpdateDeliveryFeeValue() {
        var arrSetofData =  Set<DeliveryFeeStruct>()
        var deliveryFee =   Float()
        var setNewDeliveryFee:Float = 0.0
        for i in 0..<arrData.count {
            var dict = arrData[i]
            let arrTime =   dict["arrivalTime"] as! String
            let arrDate = dict["arrivalDate"] as! String
            let combineString = arrDate + arrTime
            if arrSetofData.contains(where: {subdict in (subdict.arrivalDate_Time == combineString) && (subdict.loctionId == dict["destinationId"]as? Int) }) {
                                setNewDeliveryFee = 0
                                updateDeliveryFeeCalculation(newdeliveryFee: setNewDeliveryFee, index: i)
                            } else {
                                let createDict = DeliveryFeeStruct()
                                deliveryFee = deliveryFee + Float(dict["deliveryFee"] as? String ?? "0.00")!
                                createDict.loctionId = dict["destinationId"] as? Int
                                createDict.arrivalDate_Time = combineString
                                arrSetofData.insert(createDict)
                                dict["itemDeliveryFee"] = Float(dict["deliveryFee"] as? String ?? "0.00")!
                                setNewDeliveryFee = Float(dict["deliveryFee"] as? String ?? "0.00")!
                                updateDeliveryFeeCalculation(newdeliveryFee: setNewDeliveryFee, index: i)
            }
        }
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        saveData()
    }
    
    //MARK:- Call Api -----Checkout API
    func callSaveOrderApi(){
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.CheckOut.saveOrder
        Utils.showProgressHud()

        API_SHARED.uploadDataToServerWithStringParam(apiUrl: apiUrl , dataToUpload:arrCheckout.toJSONString()) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    Utils.hideProgressHud()
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    
                    let getDict = jsonResponse.dictionary!
                        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                        do {
                            let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
                            self.isComing = ""
                            for dict in result as [NSManagedObject] {
                                dict.setValue(true, forKey: "isOrderComplete")
                            }
                            try managedObjectContext.save()
                            flotPricewithTax = (flotPricewithTax * 100).rounded() / 100
                            APP_DELEGATE.getPaymentProfileId = 0
                        } catch {
                            print("Fetching data Failed")
                        }
                    CommonApi.callRewardPointsApi(completionHandler: {success in
                        if success ==  true {
                            Utils.hideProgressHud()
                            let orderComplete = OrderCompleteVC.instantiate(fromAppStoryboard: .CheckOut)
                                  orderComplete.dictRes = getDict
                                 self.navigationController?.pushViewController(orderComplete, animated: true)

                        }
                    })
                } else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type:.error, message: AppConstants.ErrorMessage)
                    }
                }
    }
    
    func callApplyPromocode() {
        self.view.endEditing(true)
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.CheckOut.applyPromo
        var getDesId = Int()
        if isComing == "extend" {
            getDesId = arrData[0]["destinationId"] as? Int ?? 0
        } else {
            getDesId = USER_DEFAULTS.value(forKey: AppConstants.selDestId) as! Int
        }
        let param = ["promocode":txtPromocode.text!,"DestinationID":getDesId] as [String : Any]
        API_SHARED.uploadDictToServer(apiUrl: apiUrl , dataToUpload:param) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        self.dictPromotionDetail = PromoCodeModel().initWithDictionary(dictionary: dicResponseData)
                        if self.dictPromotionDetail.statusCode == "OK" {
                            self.isPromocodeApply = true
                            self.setPromoData()
                            Utils.hideProgressHud()
                        } else {
                            Utils.hideProgressHud()
                            self.txtPromocode.text = ""
                            Utils.showMessage(type: .error, message: self.dictPromotionDetail.message)
                        }

                    } else {
                            Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: self.dictPromotionDetail.errorMessage)
                    }
                }
            }
}
    
    func callGetCustomerAddres(_ completionFunc : @escaping()->()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Address.getAddress
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(getDesId)") {[weak self] (dicResponseWithSuccess ,_)  in
          
            print("apiUrl", apiUrl)
            print("dicResponseWithSuccess", dicResponseWithSuccess)
            
            if let weakSelf = self {
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        weakSelf.dictAddress = CustomerAdressModel().initWithDictionary(dictionary: dicResponseData)
                        if weakSelf.dictAddress.statusCode == "OK" {
                            Utils.hideProgressHud()
                            weakSelf.lblBillingAddValue.text = weakSelf.dictAddress.billAddress1 + " " + weakSelf.dictAddress.billAddress2 + "," + weakSelf.dictAddress.billCity + "," +  weakSelf.dictAddress.stateName + "," + weakSelf.dictAddress.billZip + "," + weakSelf.dictAddress.country
                            APP_DELEGATE.rewardPoint = (weakSelf.dictAddress.rewardPoints)
                            weakSelf.isRewardTurn = weakSelf.dictAddress.rewardTurn
                            if APP_DELEGATE.rewardPoint >= 14 {
                                weakSelf.btnCheckRideReward.isUserInteractionEnabled = true
                            } else {
                                weakSelf.btnCheckRideReward.isUserInteractionEnabled = false
                            }
                            let getDays =   Int(round(Double(APP_DELEGATE.rewardPoint / 14)))
                            weakSelf.lblRiderRewardPoint.text = String(format: "Rider Rewards:%.2f (%d Day)", Float(weakSelf.dictAddress.rewardPoints),getDays)
                            completionFunc()
                        } else {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message: weakSelf.dictAddress.message)
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
    func callApi(passOpeIdData:[[String:Any]],completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()

        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.CheckOut.agreeStatement
        
        API_SHARED.uploadDataToServer(apiUrl: apiUrl , dataToUpload:passOpeIdData) { [self] (dicResponseWithSuccess ,_)  in
            
            print("apiUrl ", apiUrl)
                print("response chcek ", dicResponseWithSuccess)
            
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.array != nil else {
                        return
                    }
                    print("APP_DELEGATE.arrOpeIdNEW",APP_DELEGATE.arrOpeIdNEW.count)
                    print("APP_DELEGATE.arrOpeId",APP_DELEGATE.arrOpeId.count)
                    APP_DELEGATE.arrOpeIdNEW.removeAll()
                    self.arrGetRes.removeAll()
                    APP_DELEGATE.arrOpeId.removeAll()
                    if let jsonArr = jsonResponse.array {
                            for i in 0 ..< jsonArr.count {
                                let objDic = jsonArr[i].dictionary
                                let user = AgreeTermsModel().initWithDictionary(dictionary: objDic!)
                                self.arrGetRes.append(user)
                            }
                        self.dictsetRes = self.arrGetRes[0]
                        self.txtWebText.text = self.dictsetRes.checkOutText.htmlToString
                        APP_DELEGATE.arrOpeIdNEW = self.arrGetRes
                        completionHandler(true)
                    }
                    } else {
                        Utils.hideProgressHud()
                        completionHandler(false)
                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                    }
            }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WEB NAVIGATION CALLED")
    }
    
    func callApplyRiderRewardApi() {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        var getDesId = Int()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.CheckOut.applyRiderReward
        if isComing == "extend" {
            getDesId = arrData[0]["destinationId"] as? Int ?? 0

        } else {
            getDesId = USER_DEFAULTS.value(forKey: AppConstants.selDestId) as! Int
        }
        
        let param = ["ChairPadPrice":self.arrData[0]["chairPadPrice"] as!Float,
                     "DeliveryFee":Float(self.arrData[0]["deliveryFee"] as!String)!,
                     "LocationID":getDesId,
                     "OrderRegularPrice":(self.arrData[0]["regPrice"] as!Float),
                     "DeviceTypeID":self.arrData[0]["deviceTypeId"] as! Int,
                     "PickUpDate":self.arrData[0]["arrivalDate"] as! String,
                     "PickUpTime":self.arrData[0]["arrivalTime"] as! String,
                     "ReturnDate":self.arrData[0]["depatureDate"] as! String,
                     "ReturnTime":self.arrData[0]["depatureTime"] as! String,
                     "PickupLocationTaxRate":Float(self.arrData[0]["taxRate"] as! String)!,
                     "RewardPoint":APP_DELEGATE.rewardPoint] as [String : Any]
        
        print("param",param)

        API_SHARED.uploadDictToServer(apiUrl: apiUrl , dataToUpload:param) { (dicResponseWithSuccess ,_)  in
            Utils.hideProgressHud()
            if  let jsonResponse = dicResponseWithSuccess {
                guard jsonResponse.dictionary != nil else {
                    return
                }
                if let jsondict = jsonResponse.dictionary {
                    self.dictRewardData = ApplyBonusModel().initWithDictionary(dictionary: jsondict)
                    
                    if self.dictRewardData.statusCode == "OK" {
                        self.isRewardApply = true
                        self.btnCheckRideReward.isSelected = true
                        self.setPromoData()
                        Utils.hideProgressHud()
                    } else {
                        self.btnCheckRideReward.isSelected = false
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: self.dictRewardData.message)
                    }
                }


            } else {
                self.btnCheckRideReward.isSelected = false
            }
    }
}
    
   
    
    func callRemoveCard(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Card.removeCard
        let getUserId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID)
         let param = ["AuthorizedPaymentProfileID":deleteId,"CustomerID":getUserId ?? 0]
        API_SHARED.callCommonParseApiwithDictParameter(strUrl:apiUrl, passValue:param ) { (dicResponseWithSuccess ,_)  in
       
            if  let jsonResponse = dicResponseWithSuccess {
                guard jsonResponse.dictionary != nil else {
                    return
                }
                if let dicResponseData = jsonResponse.dictionary {
                    print("Response in:\(dicResponseData)")
                    if dicResponseData["StatusCode"]?.stringValue == "OK"{
                        completionHandler(true)
                    } else {
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
    
    //MARK: -Check ValidateLicense API
    func checkValidateLicApi() {
        
        APP_DELEGATE.validateLicenseApi(completionHandler: {success in
             if success ==  true {
                 self.CheckoutData()
             } else {
                 if APP_DELEGATE.saveDictLicenseRes["IsValidLicenseForPayor"]?.boolValue == true {
                     if arrNotUploadLicense.count  > 0 {
                         for i in 0..<self.arrData.count {
                             let dict = self.arrData[i]
                             if arrNotUploadLicense.contains(dict["opeId"] as? Int ?? 0 ) {
                                 APP_DELEGATE.setProfileRootVC()
                             }else { print("Nothing")}
                         }
                     }
                     if arrExpiredicense.count > 0 {
                         for i in 0..<self.arrData.count {
                             let dict = self.arrData[i]
                             if arrExpiredicense.contains(dict["opeId"] as? Int ?? 0 ) {
                                 APP_DELEGATE.setProfileRootVC()
                             }else { print("Nothing")}
                         }
                     } else {
                         self.CheckoutData()
                     }
                 } else {
                       APP_DELEGATE.setProfileRootVC()
                 }
             }
         })

        
    }
}

extension Dictionary {
    mutating func CapitalizecaseKeys() {
        for key in self.keys {
            var str = (key as! String)
            str = String(str.prefix(1)).uppercased() + String(str.dropFirst())
            self[str as! Key] = self.removeValue(forKey:key)
        }
    }
    mutating func changeKey(from: Key, to: Key) {
        self[to] = self[from]
        self.removeValue(forKey: from)
    }
}

class datastruct : NSObject {

    var deviceTypeId: Int?
    var opeId: Int?
    var isDefaultOper:Bool?
}
