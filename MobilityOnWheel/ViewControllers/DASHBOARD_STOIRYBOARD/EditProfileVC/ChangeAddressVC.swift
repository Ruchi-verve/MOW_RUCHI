//
//  ChangeAddressVC.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 02/03/22.
//  Copyright © 2022 Verve_Sys. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ChangeAddressVC: SuperViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,CommonPickerViewDelegate{

    //MARK: -Define Outlets
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
       @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
       @IBOutlet weak var txtMiddleName: SkyFloatingLabelTextField!
       @IBOutlet weak var txtSelectCountry: SkyFloatingLabelTextField!
       @IBOutlet weak var txtStreetAddress: SkyFloatingLabelTextField!
       @IBOutlet weak var txtAppartment: SkyFloatingLabelTextField!
       @IBOutlet weak var txtTownCity: SkyFloatingLabelTextField!
       @IBOutlet weak var txtState: SkyFloatingLabelTextField!
       @IBOutlet weak var txtZip: SkyFloatingLabelTextField!
      @IBOutlet weak var imgDropDown: UIImageView!

    
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var arrCountry = [String]()
    var picker = UIPickerView()
    var dictAddress = CustomerAdressModel()
    var arrState = [StateSubListModel]()
    fileprivate let pickerState = CommonPicker()
    var getStateId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
    }
    
    //MARK: -SetUI DESIGN
    func SetUI(){
        Common.shared.addSkyTextfieldwithAssertick(to: txtFirstName, placeHolder: "First Name")
        Common.shared.setFloatlblTextField(placeHolder:"Middle Name", textField: txtMiddleName)
        Common.shared.addSkyTextfieldwithAssertick(to: txtLastName, placeHolder: "Last Name")
        Common.shared.addSkyTextfieldwithAssertick(to: txtSelectCountry, placeHolder: "Select Country")
        Common.shared.addSkyTextfieldwithAssertick(to: txtStreetAddress, placeHolder: "Street Address")
        Common.shared.setFloatlblTextField(placeHolder: "Appartment,suit,unit,etc", textField: txtAppartment)
        Common.shared.addSkyTextfieldwithAssertick(to: txtTownCity, placeHolder: "Town/City")
        Common.shared.addSkyTextfieldwithAssertick(to: txtState, placeHolder: "State")
        Common.shared.addSkyTextfieldwithAssertick(to: txtZip, placeHolder: "Zip")
        
        arrCountry = ["USA","Other"]
        arrState = APP_DELEGATE.arrGetState
        pickerState.delegate = self
        pickerState.dataSource = self
        self.pickerState.toolbarDelegate = self

        txtState.inputView = pickerState
        txtState.inputAccessoryView = self.pickerState.toolbar
        self.pickerState.selectRow(0, inComponent: 0, animated: false)
        
        self.txtFirstName.textColor  = UIColor.lightGray
        self.txtLastName.textColor  = UIColor.lightGray
        self.txtMiddleName.textColor  = UIColor.lightGray

        self.txtFirstName.isUserInteractionEnabled  = false
        self.txtLastName.isUserInteractionEnabled  = false
        self.txtMiddleName.isUserInteractionEnabled  = false
        self.callGetProfileData()
    }

    //MARK:- Display Profile Info
    func callGetProfileData() {
        CommonApi.callGetCustomerProfile(completionHandler: {(success) in
            if success == true {
                Utils.hideProgressHud()
                self.dictAddress = dictGetProfileData
                if self.dictAddress.statusCode == "OK" {
                    self.txtFirstName.text =                         self.dictAddress.firstName
                    self.txtMiddleName.text = self.dictAddress.middleName
                    self.txtLastName.text = self.dictAddress.lastName
                    self.txtSelectCountry.text = self.dictAddress.country
                    self.txtStreetAddress.text = self.dictAddress.billAddress1
                    self.txtAppartment.text = self.dictAddress.billAddress2
                    self.txtTownCity.text = self.dictAddress.billCity
                    self.txtState.text = self.dictAddress.stateName
                    self.txtZip.text = self.dictAddress.billZip
                    self.getStateId = self.dictAddress.billStateId
                }
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
            }
        }, controll: self)
    }
    
    //MARK: -UIAction
    func didTapDone() {
        self.view.endEditing(true)
    }
    @IBAction func btnSaveChangesClick(_ sender: Any) {
        self.view.endEditing(true)
        checkValidation()
    }
    @IBAction func btnCountryClick(_ sender: Any) {
        self.view.endEditing(true)
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }

    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }

    //MARK:- Pickerview Delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerState {
            return arrState.count
        }
        return arrCountry.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerState {
            return arrState[row].stateName
        }
        return arrCountry[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerState {
            txtState.text = arrState[row].stateName
            getStateId = arrState[row].id
        } else {
        txtSelectCountry.text = arrCountry[row]
        if txtSelectCountry.text == "Other" {
            txtState.text = ""
            txtState.placeholder = "Other State"
            imgDropDown.isHidden = true
            txtState.keyboardType = .alphabet
            txtState.inputView = .none
            txtState.inputAccessoryView  = .none
        } else {
            txtState.text = ""
            txtState.placeholder = "State"
            imgDropDown.isHidden = false
            txtState.inputView = pickerState
            txtState.inputAccessoryView = self.pickerState.toolbar
            self.pickerState.selectRow(0, inComponent: 0, animated: false)
        }
}
    }

    //MARK:- UItextfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField == txtState {
            if txtSelectCountry.text == "" {
                txtState.resignFirstResponder()
                return Utils.showMessage(type: .error, message: "Please select country first")
            }
            else {
                pickerState.reloadAllComponents()
            }
        }

    }
    

    //MARK:- SetFunctions For Validation
    func checkValidation (){
        guard  let name  = txtFirstName.text, name != "" , !name.isEmpty else {
            return  Utils.showMessage(type: .error, message: "Please enter first name")
        }
        
        guard  let lastname  = txtLastName.text, lastname != "" , !lastname.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter last name")
        }

        guard  let country  = txtSelectCountry.text, country != "" , !country.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please select country")
        }

        guard  let address  = txtStreetAddress.text, address != "" , !address.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter street address")
        }
        
        guard  let town  = txtTownCity.text, town != "" , !town.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter town/city")
        }
        
        guard  let state  = txtState.text, state != "" , !state.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter state")
        }
        
        guard  let zip  = txtZip.text, zip != "" , !zip.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter zip code")
        }
        
        if txtZip.text!.count < 5 {
            return  Utils.showMessage(type: .error,message: "Please enter valid zip code")
        }
        callEditCustomerProfile()
    }
    
    //MARK:- Api Call
    
    func callEditCustomerProfile() {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Auth.register
        let getUId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        let strDobArr = self.dictAddress.dob.components(separatedBy: " ")
        let getstrDob = Common.shared.changeDateFormat(strDate: strDobArr[0])
        let strArr = self.dictAddress.expDate.components(separatedBy: " ")
        let getstrExpDate = Common.shared.changeDateFormat(strDate: strArr[0])
        let param1 = [
                      "ID":getUId,
                      "DOB":getstrDob,
                      "ExpiryDate":getstrExpDate,
                      "LicenseNo":dictAddress.licenseNo,
                     "FirstName":txtFirstName.text!,
                     "MiddleName":txtMiddleName.text!,
                     "LastName":txtLastName.text!,
                      "Email":dictAddress.email,
                      "CellNumber":dictAddress.cellNo,
                     "HomeNumber":dictAddress.homeNo,
                    "BillCity":txtTownCity.text!,
                    "BillAddress1":txtStreetAddress.text!,
                    "BillAddress2":txtAppartment.text!,
                    "Country":txtSelectCountry.text!,
                    "BillZip":txtZip.text!,
                    "OtherBillStateName":txtSelectCountry.text == "USA" ? "" : txtState.text!,
                     "BillStateID":txtSelectCountry.text == "USA" ? getStateId : 0,
        ] as [String : Any]


        let gettoken  = USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? ""
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":gettoken,"DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]

        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:param1, httpMethodForGetOrPost: .post, setheaders: header) {(dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .success, message:"Update profile successfully")
                            self.navigationController?.popViewController(animated: true)
                            }
                        else{
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
