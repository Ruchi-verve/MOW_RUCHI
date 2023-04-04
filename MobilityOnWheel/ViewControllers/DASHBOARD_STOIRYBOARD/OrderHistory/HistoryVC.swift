//
//  HistoryVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit
import Alamofire
import CoreData

class HistoryVC: SuperViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    func didTapDone() {
        pickerSorting.removeFromSuperview()

    }
    
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblRedeemPoints: UILabel!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var viewReardsPoint: UIView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var txtRewardPoint: UITextField!
    @IBOutlet weak var lblMesage: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSortBy: UIButton!
    @IBOutlet weak var btnNotification: AddBadgeToButton!

    
    @IBOutlet weak var viewSort: UIView!
    @IBOutlet weak var btnSortOrder: UIButton!
    @IBOutlet weak var btnSortDate: UIButton!
    @IBOutlet weak var btnSortDestination: UIButton!
    @IBOutlet weak var lblSortBy: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet var btnCart:AddBadgeToButton!


    var strPickerDate:String = ""
    var strPickerOrder:String = ""
    var strPickerDestination:String = ""
    var strPickerTapp :String = ""

    var dataSource:GenericDataSource<Any>!
    var arrData = [OrderHistorySubResModel]()
    var dictHistoryRes = OrderHistoryModel()
    var search:String=""
    var isComeFrom :String = ""
    var  SearchData = [OrderHistorySubResModel]()
    var dictExtendRes = ExtendOrderRes()
    var pickerSorting = UIPickerView()
    var toolBar = UIToolbar()
    var arrSorting = [String]()
    var strSORtingData = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
        Common.shared.addPaddingAndBorder(to: txtSearch, placeholder: "Search")
        arrSorting = ["Select Sort By","Order number","Arrival date","Destination"]
        
    }
    
    func SetUI(){
        btnMenu.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: UIControl.Event.touchUpInside)
        navigationController?.navigationBar.isHidden = true
        Common.shared.checkCartCount(btnCart)
        lblNoRecord.isHidden = true
        viewReardsPoint.isHidden = true
        viewSort.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        SetUI()
        callApi()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.search = ""
        self.txtSearch .text = ""
        self.strPickerTapp = ""
    }
    //MARK: -UITableview Method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryCell = tblList.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let cardExpDate = arrData[indexPath.row].CardExpDate.components(separatedBy: " ")
        if cardExpDate[0] != "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let date = dateFormatter.date(from: cardExpDate[0])
            dateFormatter.dateFormat = "MMMM yyyy"
            let goodDate1 = dateFormatter.string(from: date!)
            cell.lblExpDate.text = goodDate1
        }
        cell.lblStatus.textColor = UIColor.lightGray
        cell.lblStatus.isUserInteractionEnabled = false
        let endDateArr = arrData[indexPath.row].DepartureDate.components(separatedBy: " ")
        let dateFormatter = DateFormatter()

        let getDateArr = arrData[indexPath.row].CapturePaymentTransactionDate.components(separatedBy: " ")
        if getDateArr[0] != "" {
            cell.lblOrderDate.text = getDateArr[0].changeDate(getDateArr[0])
        }
        let DateArr = arrData[indexPath.row].ArrivalDate.components(separatedBy: " ")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let date = dateFormatter.date(from: DateArr[0])
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let goodDate = dateFormatter.string(from: date!)

        cell.lblOrderDate.text = goodDate
        cell.lblArrivalDateTime.text = goodDate
        cell.lblCardRetention.textColor = UIColor.lightGray
        cell.lblStatus.text = ""
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        let dict = arrData[indexPath.row]
        cell.lblStatus.tag = indexPath.row
        cell.lblRefund.tag = indexPath.row
        cell.lblCardRetention.text = dict.ResendAttestationTo
        cell.lblRefund.isHidden = true
        cell.lblCardRetention.isUserInteractionEnabled = false
        cell.lblCardRetention.textColor = UIColor.lightGray
        if dict.IsResendAttestationDisable == true  {
            cell.lblCardRetention.isUserInteractionEnabled = false
            cell.lblCardRetention.textColor = UIColor.lightGray
        }else {
            cell.lblCardRetention.isUserInteractionEnabled = true
            cell.lblCardRetention.textColor = AppConstants.kColor_Primary
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelResendAttPressed(_:)))
            cell.lblCardRetention.addGestureRecognizer(gestureRecognizer)
        }
        
        let getOrderStatusArr = dict.OrderStatus.components(separatedBy: "|")
        if getOrderStatusArr.count > 1 &&   dict.OrderStatus != ""  {
            cell.lblStatus.text = getOrderStatusArr[0]
            cell.lblStatus.textColor = AppConstants.kColor_Primary
            cell.lblStatus.isUserInteractionEnabled = true
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelPressed(_:)))
            cell.lblStatus.addGestureRecognizer(gestureRecognizer)
            cell.lblRefund.text =  getOrderStatusArr[1]
                cell.lblRefund.isHidden = false
                cell.lblRefund.isUserInteractionEnabled = true
                let gestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(labelCanelOrderPressed(_:)))
                cell.lblRefund.addGestureRecognizer(gestureRecognizer1)
        }
        else {
            if dict.OrderStatus.contains("Extend") {
                cell.lblStatus.textColor = AppConstants.kColor_Primary
                cell.lblStatus.isUserInteractionEnabled = true
                let gestureRecognizer = UITapGestureRecognizer(
                    target: self, action: #selector(labelPressed(_:)))
                cell.lblStatus.addGestureRecognizer(gestureRecognizer)
            } else {
                cell.lblStatus.text = getOrderStatusArr[0]
                cell.lblStatus.textColor = UIColor.lightGray
                cell.lblStatus.isUserInteractionEnabled = false
            }
            cell.lblStatus.text = getOrderStatusArr[0]
            cell.lblRefund.isHidden = true
        }
        cell.lblOrderId.text = arrData[indexPath.row].FormatedOrderID
        cell.lblOperator.text = arrData[indexPath.row].OperatorName
        cell.lblOpeOccName.text = arrData[indexPath.row].DeviceTypeName
        cell.lblCardNo.text = arrData[indexPath.row].CardLastFourDigit
        let cardName  =  arrData[indexPath.row].CardTypeName.components(separatedBy: ".")
        cell.lblCaredType.text = cardName[0]
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let enddate = dateFormatter.date(from: endDateArr[0] )
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let goodDate1 = dateFormatter.string(from: enddate!)
        cell.lblDepatureDateTime.text = goodDate1   //endDateArr[0]
        cell.lblDestination.text = arrData[indexPath.row].LocationName
        
        let getfirstName  =  USER_DEFAULTS.value(forKey: AppConstants.FIRST_NAME) as? String ?? "Steve"
        let getlastName  =  USER_DEFAULTS.value(forKey: AppConstants.LAST_NAME) as? String ?? "Steve"
        
        if arrData[indexPath.row].PayorEleAttestationUrl  == "" {
                  cell.lbloperatorName.text = ""
                  cell.btnoperatorName.isHidden = true
                  cell.topConstainLayout.constant = -10
              } else {
                  cell.lbloperatorName.text = (getfirstName.capitalized)+" "+(getlastName.capitalized)
                  //arrData[indexPath.row].OperatorName
                  cell.btnoperatorName.isHidden = false
                  cell.topConstainLayout.constant = 5
              }
              
              print("OPeratorName \(arrData[indexPath.row].OperatorName)")
           
              if arrData[indexPath.row].OperatorEleAttestationUrl == "" {
                  cell.lblpayorName.text = ""
                  cell.btnpayorName.isHidden = true
              } else {
                  cell.lblpayorName.text = arrData[indexPath.row].OperatorName
                  //(getfirstName.capitalized)+" "+(getlastName.capitalized)
                  cell.btnpayorName.isHidden = false
              }
              
              cell.buttonPressedOperatorName = {
                  self.PayorwebCallhere(indexPath: indexPath.row)
              }
        
              cell.buttonPressedpayorName = {
                  self.OperatorwebCallhere(indexPath: indexPath.row)
              }
        
        
        
        return cell
    }
    
    //** WEB VIEW FUNC HERE ** //
        func OperatorwebCallhere(indexPath: Int) {
            
            print("check index \(arrData[indexPath].OperatorEleAttestationUrl)")
                
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = arrData[indexPath].OperatorEleAttestationUrl
            scrFlag = 1
            self.navigationController?.pushViewController(help, animated: true)

          
        }
        
        //** WEB VIEW FUNC HERE ** //
        func PayorwebCallhere(indexPath: Int) {
            
            print("check index \(arrData[indexPath].PayorEleAttestationUrl)")
            
           
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = arrData[indexPath].PayorEleAttestationUrl
            scrFlag = 1
            self.navigationController?.pushViewController(help, animated: true)

    
        }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 230 : 180
    }
    
    @objc func labelResendAttPressed(_ tapGesture:UITapGestureRecognizer){
        self.callResendAttention(equipOrderId: arrData[tapGesture.view!.tag].EquipmentOrderID, equipOrderDetailId: 0)
    }

    @objc func labelCanelOrderPressed(_ tapGesture:UITapGestureRecognizer){
        self.callCancelOrder(OrderId: arrData[tapGesture.view!.tag].EquipmentOrderID, RefundType: arrData[tapGesture.view!.tag].RefundType, ComporId: 0, completionHandler:{success in
            if success == true {
                self.arrData[tapGesture.view!.tag].IsRefundCredit = true
//                self.tblList.reloadData()
                self.callApi()
            }
            })
    }

    @objc func labelPressed(_ tapGesture:UITapGestureRecognizer){
        self.callExtendOrderApi(OrderId: arrData[tapGesture.view!.tag].EquipmentOrderID, completionHandler: {success in
                        if success == true  {
                            let help = ExtendReservationVC.instantiate(fromAppStoryboard: .DashBoard)
                            help.strIsCome = "history"
                            help.operatorName = self.arrData[tapGesture.view!.tag].OperatorName
                            strIsEditOrder = ""
                            APP_DELEGATE.dictEditedData = [:]
                            help.OrderId = self.arrData[tapGesture.view!.tag].EquipmentOrderID
                            help.dictExtendRes = self.dictExtendRes
                            self.navigationController?.pushViewController(help, animated: true)
                        } else {
                            Utils.hideProgressHud()
                            Utils.showMessage(type:.error, message: self.dictExtendRes.message)
                        }
                    })
    }

    //MARK:- UIAction Method
    @IBAction func btnCloseClick(_ sender:Any) {
        viewReardsPoint.isHidden = true
    }
    
    @IBAction func btnShortByClick(_ sender:Any) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewSort.addGestureRecognizer(tap)
        viewSort.isHidden = false
}
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        viewSort.isHidden =  true
    }

    @IBAction func onDoneButtonTapped(_ sender:AnyObject) {
        self.btnSortTypeClicked(isClicked:(sender as? UIButton)!)
    }
    
    
    //MARK :-Sorting Function
    func btnSortTypeClicked(isClicked:UIButton) {
        if arrData.count  > 0 {
            if isClicked == btnSortOrder {
                strPickerTapp = "1"
              strPickerOrder =  strPickerOrder == "Desc" ? "Asce":"Desc"
                if strPickerOrder ==  "Asce" {
                arrData =  arrData.sorted(by: {$0.EquipmentOrderID < $1.EquipmentOrderID})
                    self.lblSortBy.text = "Select Sort By - Order number ▲"
                } else {strPickerOrder = "Desc"
                        arrData =  arrData.sorted(by: {$0.EquipmentOrderID > $1.EquipmentOrderID})
                            self.lblSortBy.text = "Select Sort By - Order number ▼"
                            }
                            DispatchQueue.main.async {
                                self.tblList.reloadData()
                                let indexPath = IndexPath(row: 0, section: 0)
                                self.tblList.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                viewSort.isHidden = true
            } else if isClicked == btnSortDate {
                strPickerTapp = "2"
                strPickerOrder =  strPickerOrder == "Desc" ? "Asce":"Desc"
                  if strPickerOrder ==  "Asce" {
                  arrData =  arrData.sorted(by: {$0.EquipmentOrderID < $1.EquipmentOrderID})
                      self.lblSortBy.text = "Select Sort By - Arrival date ▲"
                  } else {strPickerOrder = "Desc"
                          arrData =  arrData.sorted(by: {$0.EquipmentOrderID > $1.EquipmentOrderID})
                              self.lblSortBy.text = "Select Sort By - Arrival date ▼"
                              }
                              DispatchQueue.main.async {
                                  self.tblList.reloadData()
                                  let indexPath = IndexPath(row: 0, section: 0)
                                  self.tblList.scrollToRow(at: indexPath, at: .top, animated: true)
                              }
                viewSort.isHidden = true

            }else if isClicked == btnSortDestination {
                strPickerTapp = "3"
                strPickerOrder =  strPickerOrder == "Desc" ? "Asce":"Desc"
                  if strPickerOrder ==  "Asce" {
                  arrData =  arrData.sorted(by: {$0.EquipmentOrderID < $1.EquipmentOrderID})
                      self.lblSortBy.text = "Select Sort By - Destination ▲"
                  } else {strPickerOrder = "Desc"
                          arrData =  arrData.sorted(by: {$0.EquipmentOrderID > $1.EquipmentOrderID})
                              self.lblSortBy.text = "Select Sort By - Destination ▼"
                              }
                              DispatchQueue.main.async {
                                  self.tblList.reloadData()
                                  let indexPath = IndexPath(row: 0, section: 0)
                                  self.tblList.scrollToRow(at: indexPath, at: .top, animated: true)
                              }
                viewSort.isHidden = true
            }

        } else {
            viewSort.isHidden = true
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
    
    @IBAction func btnNoitificationClick(_ sender: Any) {
            self.view.endEditing(true)
            let loginScene = NotificationVC.instantiate(fromAppStoryboard: .DashBoard)
            self.navigationController?.pushViewController(loginScene, animated: true)
    }

    @IBAction func btnInfoClick(_ sender:Any) {
        viewReardsPoint.isHidden = false
        Common.shared.addPaddingAndBorder(to: txtRewardPoint, placeholder: "")
        txtRewardPoint.isUserInteractionEnabled = false
        txtRewardPoint.text = String(format: "%.1f", Float(self.dictHistoryRes.rewardPoints))
    }

    //MARK:- Api Call
    func callApi() {
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()

        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.orderHistory
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(getDesId)") {[weak self] (dicResponseWithSuccess ,_)  in
                        if let weakSelf = self {
                            if  let jsonResponse = dicResponseWithSuccess {
                                guard jsonResponse.dictionary != nil else {
                                    return
                                }
                                if let dicResponseData = jsonResponse.dictionary {
                                    weakSelf.dictHistoryRes = OrderHistoryModel().initWithDictionary(dictionary: dicResponseData)
            
                                    if weakSelf.dictHistoryRes.statusCode == "OK" {
                                        Utils.hideProgressHud()
                                        
                                        weakSelf.arrData = weakSelf.dictHistoryRes.arrHistory
                                        weakSelf.strPickerOrder = "Desc"
                                        weakSelf.strPickerDate = "Desc"
                                        weakSelf.strPickerDestination = "Desc"

                                        weakSelf.SearchData = weakSelf.arrData
                                        CommonApi.callNotificationBadgeInfo(completionHandler: {success in
                                            if success == true {
                                                Common.shared.addBadgetoButton(weakSelf.btnNotification,"\(NotificationBadge)", "icon_notification")
                                                Utils.hideProgressHud()
                                            }
                                        })
                                        DispatchQueue.main.async {
                                            weakSelf.tblList.reloadData()
                                        }
                                      

                                    }
                                        else {
                                            Utils.hideProgressHud()
                                            Utils.showMessage(type: .error, message: weakSelf.dictHistoryRes.errorMessage)
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
    //Mark:- Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            search = String(search.dropLast())
        } else {
            search=textField.text!+string
        }

        let filteredArray = SearchData.filter { $0.FormatedOrderID.contains(search) || $0.DeviceTypeName.contains(search) || $0.LocationName.contains(search)}
        if filteredArray.count > 0 {
            arrData.removeAll(keepingCapacity: true)
            arrData = filteredArray
            tblList.isHidden = false
            lblNoRecord.isHidden = true
            tblList.reloadData()
        } else if  search == "" {
            arrData = SearchData
            tblList.isHidden = false
            lblNoRecord.isHidden = true
            tblList.reloadData()
        } else {
                tblList.isHidden = true
                lblNoRecord.isHidden = false
        }
        return true
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
                                        print("DIc REs:\(dicResponseData)")
                                        self.dictExtendRes = ExtendOrderRes().initWithDictionary(dictionary: dicResponseData)
                
                                        if self.dictExtendRes.statusCode == "OK"  &&  self.dictExtendRes.message == "" {
                                            completionHandler(true)
                                            Utils.hideProgressHud()
                                            
                                        } else{
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
    
    func callResendAttention(equipOrderId:Int, equipOrderDetailId:Int) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.reSendAttestation
        let param1 = [
                    "EquipmentOrderID":equipOrderId,
                    "EquipmentOrderDetailID":equipOrderDetailId] as [String : Any]
        API_SHARED.uploadDictToServerwithstrRes(apiUrl: apiUrl , dataToUpload:param1) { (dicResponseWithSuccess ,_)  in
                     Utils.hideProgressHud()
            if dicResponseWithSuccess.contains("successfully") {
                Utils.showMessage(type: .success, message: dicResponseWithSuccess)
                self.tblList.reloadData()
            } else {
                Utils.showMessage(type: .error, message: dicResponseWithSuccess)
            }
        }
    }

    func callCancelOrder(OrderId:Int,RefundType:String, ComporId:Int,completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.cancelOrderByOrderId
        let param1 = [
                    "OrderId":OrderId,
                    "RefundType":RefundType,
            "ComporId":ComporId] as [String : Any]

        API_SHARED.uploadDictToServerwithstrRes(apiUrl: apiUrl , dataToUpload:param1) { (dicResponseWithSuccess ,_)  in
            if dicResponseWithSuccess.contains("successfully") {
                Utils.hideProgressHud()
                Utils.showMessage(type: .success, message: "Your order has been canceled successfully")
                completionHandler(true)
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: dicResponseWithSuccess)
                completionHandler(false)

            }
        }
    }


}
