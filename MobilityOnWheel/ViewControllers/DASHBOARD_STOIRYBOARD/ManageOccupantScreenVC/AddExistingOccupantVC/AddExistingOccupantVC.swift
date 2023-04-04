
//
//  AddExistingOccupantVC.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 21/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire
class AddExistingOccupantVC: SuperViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    @IBOutlet weak var tblExistiongOccupant: UITableView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblSelect: UILabel!
    @IBOutlet weak var lblOperatorName: UILabel!
    @IBOutlet weak var lblOccupantName: UILabel!

    var arrExistingOccList = [ExistingOccupantModel]()
    var OccuId:Int = 0
    var OperatorId :Int = 0
    var search:String=""
    var searchResults:[ExistingOccupantModel] = []
    var arrOccuList = [OccupantListModel]()
    
    //MARK:- UIView Lifecycle Method
    override func viewDidLoad() {
        Common.shared.setStatusBarColor(view: view, color: AppConstants.kColor_Primary)
        tblExistiongOccupant.register(UINib(nibName: "ExistingOccupantTblCell", bundle: nil), forCellReuseIdentifier: "ExistingOccupantTblCell")
        Common.shared.addPaddingAndBorder(to: txtSearch, placeholder: "Please enter Occupant Name")
        lblSelect.isHidden = true
        lblOperatorName.isHidden = true
        lblOccupantName.isHidden = true
        self.navigationController?.view.removeGestureRecognizer((self.navigationController?.interactivePopGestureRecognizer!)!)
    }
    
    //MARK:- UITableview Method

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrExistingOccList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExistingOccupantTblCell", for: indexPath) as? ExistingOccupantTblCell
        cell?.lblOperatorName.text = "\(arrExistingOccList[indexPath.row].operatorName)"
        cell?.lblOccupantName.text = "\(arrExistingOccList[indexPath.row].occupantName)"
        if arrExistingOccList[indexPath.row].isSelect == 1 {
            cell?.btnRadio.isSelected  = true
        }
        else {
            cell?.btnRadio.isSelected  = false
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for dict in arrExistingOccList {
            if dict.isSelect == 1 {
                dict.isSelect = 0
            }
        }
        arrExistingOccList[indexPath.row].isSelect = 1
        callOccuDetails(opeId:arrExistingOccList[indexPath.row].occupantID)
        self.tblExistiongOccupant.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    
    //MARK:- IBActionClick
    @IBAction func btnHomeClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func btnBackClick(_ sender:UIButton){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    //MARK:UITextfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty
        {
            search = String(search.dropLast())
        } else
        {
            search=textField.text!+string
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if search != "" || search.count != 0{
            self.view.endEditing(true)
            callExistingOccuList()
        }
        else {
          //  self.view.endEditing(true)
        }
    }
    
    
    //MARK:- ApiCall
    
    func callExistingOccuList() {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()

        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.existingOccupant
        let getUserId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID)
        let param = ["CustomerID":getUserId ?? 0,"SearchText":txtSearch.text!,"OperatorID":OperatorId] as [String : Any]
        API_SHARED.uploadDictToServer(apiUrl: apiUrl , dataToUpload:param) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.array != nil else {
                        return
                    }
                    self.arrExistingOccList.removeAll()
                        if let jsonArr = jsonResponse.array {
                            for i in 0 ..< jsonArr.count {
                                let objDic = jsonArr[i].dictionary
                                let user = ExistingOccupantModel().initWithDictionary(dictionary: objDic!)
                                self.arrExistingOccList.append(user)
                                self.tblExistiongOccupant.reloadData()
                            }
                            if self.arrExistingOccList.count > 0 {
                                self.lblSelect.isHidden = false
                                self.lblOperatorName.isHidden = false
                                self.lblOccupantName.isHidden = false
                            }
                            Utils.hideProgressHud()

                    }
                        else{
                            Utils.hideProgressHud()
                        }
                       
                    } else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                    }
                
            }
    }
    

    
    func callOccuDetails(opeId:Int) {
                if !InternetConnectionManager.isConnectedToNetwork() {
                    Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
                    return
                }
                Utils.showProgressHud()
                let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.getOccuDetails
                
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(opeId)") { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {
                            Utils.hideProgressHud()
                            self.callAddExistingOccupant(notes: dicResponseData["Notes"]?.stringValue ?? "", firstName: dicResponseData["FirstName"]?.stringValue ?? "", lastName: dicResponseData["LastName"]?.stringValue ?? "", heightFeet: dicResponseData["HeightFeet"]?.intValue ?? 0, heightInch: dicResponseData["HeightInch"]?.intValue ?? 0, weight: dicResponseData["Weight"]?.intValue ?? 0, IsDefault:  false, middleName: dicResponseData["MiddleName"]?.stringValue ?? "")
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
    func callAddExistingOccupant(notes:String,firstName:String,lastName:String,heightFeet:Int,heightInch:Int,weight:Int,IsDefault:Bool,middleName:String) {

        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.addOccupant
        let param1 = [ "ID":0, //occupantID
                       "Notes":notes,
                     "FirstName":firstName,
                     "MiddleName":middleName,
                     "LastName":lastName,
                     "HeightFeet":heightFeet,
                    "HeightInch":heightInch,
                    "Weight":weight,
                    "isDefault":IsDefault,
                    "OperatorID":OperatorId] as [String : Any]


        let gettoken  = USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? ""
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":gettoken,"DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]

        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:param1, httpMethodForGetOrPost: .post, setheaders: header) {[weak self] (dicResponseWithSuccess ,_)  in
            if let weakSelf = self {
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .success, message:"Add occupant successfully")
                            weakSelf.navigationController?.popViewController(animated: true)
                            } else{
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message:dicResponseData["Message"]?.stringValue ?? AppConstants.ErrorMessage)
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
}




