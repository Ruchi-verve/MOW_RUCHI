//
//  OperatorListVC.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 25/02/22.
//  Copyright © 2022 Verve_Sys. All rights reserved.
//

import UIKit
import Alamofire

class OperatorListVC: SuperViewController, UITableViewDelegate,UITableViewDataSource {

    var arrOperatorList = [[String:Any]]()
    
    @IBOutlet weak var tblOperatorList:UITableView!
    @IBOutlet weak var btnAdd:UIButton!
    @IBOutlet weak var btnSignUp:UIButton!
    @IBOutlet weak var btnBack:UIButton!
    @IBOutlet weak var contblHeight: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOperatorList.register(UINib(nibName: "OperatorListCell", bundle: nil), forCellReuseIdentifier: "OperatorListCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        arrOperatorList = APP_DELEGATE.arrSaveOperatorList
        DispatchQueue.main.async {
            self.tblOperatorList.reloadData()
        }
        contblHeight.constant = CGFloat(self.arrOperatorList.count * 80)
        tblOperatorList.layoutIfNeeded()
        tblOperatorList.updateConstraintsIfNeeded()
    }
    //MARK: -Button Method
    @IBAction  func btnSignUpClick(_ sender: UIButton!) {
        callRegisterApi()
        
    }
    @IBAction  func btnBackTapped(_ sender: UIButton!) {
        for controller in self.navigationController!.viewControllers as Array {
                   if controller.isKind(of: RegisterVC.self) {
                       let getVC = controller as! RegisterVC
                       self.navigationController!.popToViewController(getVC, animated: true)
                       break
                   }
               }

       // self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction  func btnAddClick(_ sender: UIButton!) {
        let createOPe = AddOperator.instantiate(fromAppStoryboard: .Login)
        createOPe.isCome = "Add"
        self.navigationController?.pushViewController(createOPe, animated: true)
    }
    //MARK: -UITableview Method

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOperatorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblOperatorList.dequeueReusableCell(withIdentifier: "OperatorListCell", for: indexPath) as! OperatorListCell
        let dict = arrOperatorList[indexPath.row]
        cell.btnOccupant.isHidden = true
        cell.imgOccupant.isHidden = true
        cell.lblOperatorName.text! = String(format: "%@ %@", dict["firstName"] as? String ?? " ", dict["lastName"] as? String ?? "" )
        if dict["isSameData"] as? String == "1" {
            cell.contentView.backgroundColor = UIColor(red: 191/255, green: 252/255, blue: 91/255, alpha: 1)
        }else {
            cell.contentView.backgroundColor = UIColor.clear
        }
        cell.btnEdit.isUserInteractionEnabled = false
        cell.lblOperatorEmail.text! = dict["email"] as? String ?? ""
        cell.lblOpertatorContact.text! = "Cell:\(dict["cellNo"] as? String ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let retrive:AddOperator = AddOperator.instantiate(fromAppStoryboard: .Login)
        retrive.isCome = "Edit"
        retrive.index = indexPath.row
        retrive.dictSamedata = arrOperatorList[indexPath.row]
        self.navigationController?.pushViewController(retrive, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    //MARK: -register Api
    func callRegisterApi(){
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        var arrOpeList = [[String:Any]]()
        for dict in APP_DELEGATE.arrSaveOperatorList {
             var dictOpeList = [String:Any]()
            dictOpeList["FirstName"] = dict["firstName"] as? String ?? ""
            dictOpeList["MiddleName"] = dict["middleName"] as? String ?? ""
            dictOpeList["LastName"] = dict["lastName"] as? String ?? ""
            dictOpeList["OperatorID"] = 0
            dictOpeList["CustomerID"] = 0
            let heightArr = (dict["height"] as AnyObject).components(separatedBy: "-")
            dictOpeList["HeightFeet"] = Int(heightArr[0])!
            dictOpeList["HeightInch"] = Int(heightArr[1])!
            dictOpeList["Weight"] = Int(dict["weight"] as? String ?? "")!
            dictOpeList["DateOfBirth"] = dict["dob"] as? String ?? ""
            dictOpeList["LicenceNo"] = dict["licenseNo"] as? String ?? ""
            dictOpeList["ExpirationDate"] = dict["expiry"] as? String ?? ""
            dictOpeList["OperatorCellNumber"] = dict["cellNo"] as? String ?? ""
            dictOpeList["OperatorHomeNumber"] = dict["homeNo"] as? String ?? ""
            dictOpeList["EmailId"] = dict["email"] as? String ?? ""
            dictOpeList["Notes"] = ""

            if dict["isSameData"] as? String == "1" {
                dictOpeList["isdefault"] = true
            } else {
                dictOpeList["isdefault"] = false
            }
            //dictOpeList["isdefault"] = dict["isSameData"] as? String ?? ""
            let keyExists = dict["FileContent"] != nil
            if keyExists{
                print("The key is present in the dictionary")
            dictOpeList["FileContent"] = dict["FileContent"] as? String ?? ""
                dictOpeList["MimeType"] = dict["MimeType"] as? String ?? ""
                dictOpeList["FileName"] = dict["FileName"] as? String ?? ""
            } else {
                print("The key is not present in the dictionary")
            }
            arrOpeList.append(dictOpeList)
        }
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Auth.registerUser
        let getUId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        var param1 =   [String : Any]()
        param1 = APP_DELEGATE.dictPayorData
        param1["ID"] = getUId
        param1["listOperatorRequest"] =  arrOpeList
        
        let gettoken  = USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? ""
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":gettoken,"DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
     
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:param1, httpMethodForGetOrPost: .post, setheaders: header) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {
                            Utils.hideProgressHud()
                            APP_DELEGATE.arrSaveOperatorList.removeAll()
                            Utils.showMessage(type: .success, message:"Create account successfully")
                            APP_DELEGATE.arrSaveOperatorList.removeAll()
                            APP_DELEGATE.dictPayorData = [:]
                            self.navigationController?.popToRootViewController(animated: true)
                            } else{
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message:dicResponseData["Message"]?.stringValue ?? AppConstants.ErrorMessage)
                        }
                        }
                    } else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                    }
               
            }
    }
    
    
}
