
//
//  REditProfileVC.swift
//  AamluckyRetailer
//
//  Created by Arvind Kanjariya on 24/01/20.
//  Copyright © 2020 Arvind Kanjariya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVKit

class RegisterVC: SuperViewController,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CommonPickerViewDelegate {

    @IBOutlet weak var srlView: UIScrollView!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMiddleName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtSelectCountry: SkyFloatingLabelTextField!
    @IBOutlet weak var txtStreetAddress: SkyFloatingLabelTextField!
    @IBOutlet weak var txtAppartment: SkyFloatingLabelTextField!
    @IBOutlet weak var txtTownCity: SkyFloatingLabelTextField!
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    @IBOutlet weak var txtZip: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCellNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtHomeNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLicenseNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtExpirationDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDateofBirth: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!

    @IBOutlet weak var txtViewNote: UITextView!
    @IBOutlet weak var viewScan: UIView!
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var tblOperatorList: UITableView!
    @IBOutlet weak var contblHeight: NSLayoutConstraint!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var lblScan: UILabel!

    var arrList = [[String:Any]]()
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var arrCountry = [String]()
    var picker = UIPickerView()
    var getImage = UIImage()
    var dictgetScannerRes = [String:JSON]()
    var dictgetScannerResDup = [String:String]()
    var weight : String = ""
    var height : String = ""
    var arrState = [StateSubListModel]()
    fileprivate let pickerState = CommonPicker()
    fileprivate let pickerContry = CommonPicker()

    var getStateId = Int()
    var strBase64:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
    }

    func SetUI(){
        Common.shared.addSkyTextfieldwithAssertick(to: txtFirstName, placeHolder: "First Name")
        Common.shared.setFloatlblTextField(placeHolder: "Middle Name", textField: txtMiddleName)
        Common.shared.addSkyTextfieldwithAssertick(to: txtLastName, placeHolder: "Last Name")
        Common.shared.addSkyTextfieldwithAssertick(to: txtSelectCountry, placeHolder: "Select Country")
        Common.shared.addSkyTextfieldwithAssertick(to: txtStreetAddress, placeHolder: "Street Address")
        Common.shared.setFloatlblTextField(placeHolder: "Appartment,suit,unit,etc", textField: txtAppartment)
        Common.shared.addSkyTextfieldwithAssertick(to: txtTownCity, placeHolder: "Town/City")
        Common.shared.addSkyTextfieldwithAssertick(to: txtState, placeHolder: "State")
        Common.shared.addSkyTextfieldwithAssertick(to: txtZip, placeHolder: "Zip")
        Common.shared.addSkyTextfieldwithAssertick(to: txtCellNumber, placeHolder: "Cell Phone Number")
        Common.shared.setFloatlblTextField(placeHolder: "Home Phone Number", textField: txtHomeNumber)
        Common.shared.addSkyTextfieldwithAssertick(to: txtEmail, placeHolder: "Email")
        Common.shared.addSkyTextfieldwithAssertick(to: txtLicenseNumber, placeHolder: "License/Valid ID Number")
        Common.shared.addTextfieldwithAssertickForNonCapital(to: txtPassword, placeholder: "Password")
        Common.shared.addTextfieldwithAssertickForNonCapital(to: txtConfirmPassword, placeholder: "Confirm Password")
        Common.shared.addSkyTextfieldwithAssertick(to: txtExpirationDate, placeHolder: "Expiration Date")
        Common.shared.addSkyTextfieldwithAssertick(to: txtDateofBirth, placeHolder: "Date of Birth")

        txtPassword.isSecureTextEntry  = true
        txtLicenseNumber.isSecureTextEntry = false

        txtCellNumber.keyboardType = .numberPad
        txtZip.keyboardType = .numberPad
        txtHomeNumber.keyboardType = .numberPad
        txtEmail.keyboardType = .emailAddress
        txtLicenseNumber.keyboardType = .default
        
        viewScan.layer.cornerRadius = 8
        viewScan.layer.borderColor = AppConstants.kBorder_Color.cgColor
        viewScan.layer.borderWidth = 0.8

        arrCountry = ["USA","Other"]
        contblHeight.constant = 0
        arrState = APP_DELEGATE.arrGetState
        pickerState.delegate = self
        pickerState.dataSource = self
        self.pickerState.toolbarDelegate = self

        pickerContry.delegate = self
        pickerContry.dataSource = self
        self.pickerContry.toolbarDelegate = self

        txtSelectCountry.inputView = pickerContry
        txtSelectCountry.inputAccessoryView = self.pickerContry.toolbar
        self.pickerContry.selectRow(0, inComponent: 0, animated: false)

        txtState.inputView = pickerState
        txtState.inputAccessoryView = self.pickerState.toolbar
        self.pickerState.selectRow(0, inComponent: 0, animated: false)
        let text = "Scan Front of Payor's ID now *"
        let range = (text as NSString).range(of: "*")
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttributes([.foregroundColor : UIColor.red,.baselineOffset:3], range: range)
            //Apply to the label
        //btnScan.titleLabel?.attributedText = attributedString
        btnScan.setAttributedTitle(attributedString, for: .normal)
        
        CommonApi.callgetScannerApiKey(completionHandler: {(getStrVal) in
            if getStrVal != "" { APP_DELEGATE.scanerKey  =  getStrVal} else {
                APP_DELEGATE.scanerKey  = ""
            }
        }, controll: self)
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK:- UIAction

    func didTapDone() {
        self.view.endEditing(true)
    }
 
    @IBAction func btnSignupClick(_ sender: Any) {
        self.view.endEditing(true)
        checkValidation()

    }
    
    @IBAction func btnScannerClick(_ sender: Any) {
        self.view.endEditing(true)
        
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .camera;
//            imagePicker.modalPresentationStyle = .overCurrentContext
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
        
        
        checkCameraAccess()

    }
    
    //MARK: -check camera access
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            print("Authorized, proceed")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.modalPresentationStyle = .overCurrentContext
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    DispatchQueue.main.async {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.sourceType = .camera;
                        imagePicker.modalPresentationStyle = .overCurrentContext
                        imagePicker.allowsEditing = true
                        self.present(imagePicker, animated: true, completion: nil)
                    }
                } else {
                    print("Permission denied")
                }
            }
         default:
            break
        }
    }

    func presentCameraSettings() {
        let alertController = UIAlertController(title: "",
                                      message: "My Mobility does not have access to your camera.To enable access,tap Settings and turn on Camera",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default))
        alertController.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                    // Handle
                })
            }
        })

        present(alertController, animated: true)
    }



    @IBAction func btnSignInclick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnAddClick(_ sender: Any) {
        dictgetScannerResDup["firstName"] = txtFirstName.text!
        dictgetScannerResDup["lastName"] = txtLastName.text!
        dictgetScannerResDup["middleName"] = txtMiddleName.text!
        dictgetScannerResDup["cellNo"] = txtCellNumber.text!
        dictgetScannerResDup["homeNo"] = txtHomeNumber.text!
        dictgetScannerResDup["licenseNo"] = txtLicenseNumber.text!
        dictgetScannerResDup["expiry"] = txtExpirationDate.text!
        dictgetScannerResDup["dob"] = txtDateofBirth.text!
        dictgetScannerResDup["email"] = txtEmail.text!
        let retrive = AddOperator.instantiate(fromAppStoryboard: .Login)
        retrive.dictSamedata = dictgetScannerResDup
        self.navigationController?.pushViewController(retrive, animated: true)
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
//            txtState.placeholder = "Other State"
            Common.shared.addSkyTextfieldwithAssertick(to: txtState, placeHolder: "Other State")
            imgDropDown.isHidden = true
            txtState.keyboardType = .alphabet
            txtState.inputView = .none
            txtState.inputAccessoryView  = .none
        } else {
            txtState.text = ""
            Common.shared.addSkyTextfieldwithAssertick(to: txtState, placeHolder: "State")
            imgDropDown.isHidden = false
            txtState.inputView = pickerState
            txtState.inputAccessoryView = self.pickerState.toolbar
            self.pickerState.selectRow(0, inComponent: 0, animated: false)
        }
    }
    }

    //MARK:- SetFunctions For Validation
    func checkValidation (){
        
        if strBase64 == "" {
            return Utils.showMessage(type: .error, message: "Scan valid ID required")
        }

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
        
        guard  let cellNo  = txtCellNumber.text, cellNo != "" , !cellNo.isEmpty else {
           return  Utils.showMessage(type: .error,message:"Please enter cell number")
        }

        if !txtCellNumber.text!.isPhoneNumber {
            return  Utils.showMessage(type: .error,message:"Please enter valid cell number")
        }

        guard  let email  = txtEmail.text, email != "" , !email.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter email")
        }

        if !Common.shared.isValidEmail(testStr: txtEmail.text!) {
            Utils.showMessage(type: .error,message: "Please enter valid email")
        }
        guard  let pwd  = txtPassword.text, pwd != "" , !pwd.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter password")
        }
        
        if txtPassword.text!.count < 6 || txtPassword.text!.count > 12 {
            return  Utils.showMessage(type: .error,message: "Password should be in range of 6-12 characters")
        }
        
        guard  let pwd1  = txtConfirmPassword.text, pwd1 != "" , !pwd1.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter confirm password")
        }

        if txtConfirmPassword.text != txtPassword.text {
            return  Utils.showMessage(type: .error,message: "Password doesn't matched")
        }
        if txtSelectCountry.text == "USA" {
                getStateId = arrState.filter{$0.stateName.contains(txtState.text!)}.first!.id
            }

        dictgetScannerResDup["firstName"] = txtFirstName.text!
        dictgetScannerResDup["lastName"] = txtLastName.text!
        dictgetScannerResDup["middleName"] = txtMiddleName.text!
        dictgetScannerResDup["cellNo"] = txtCellNumber.text!
        dictgetScannerResDup["homeNo"] = txtHomeNumber.text!
        dictgetScannerResDup["licenseNo"] = txtLicenseNumber.text!
        dictgetScannerResDup["expiry"] = txtExpirationDate.text!
        dictgetScannerResDup["dob"] = txtDateofBirth.text!
        dictgetScannerResDup["email"] = txtEmail.text!
        
        if APP_DELEGATE.dictPayorData.isEmpty == true {
            APP_DELEGATE.dictPayorData["DateOfBirth"] = txtDateofBirth.text!
            APP_DELEGATE.dictPayorData["ExpirationDate"] = txtExpirationDate.text!
            APP_DELEGATE.dictPayorData["LicenseNo"] = txtLicenseNumber.text!
            APP_DELEGATE.dictPayorData["MimeType"] = "image/jpeg"
            APP_DELEGATE.dictPayorData["FileName"] = "RegPic.jpeg"
            APP_DELEGATE.dictPayorData["FirstName"] = txtFirstName.text!
            APP_DELEGATE.dictPayorData["MiddleName"] = txtMiddleName.text!
            APP_DELEGATE.dictPayorData["LastName"] = txtLastName.text!
            APP_DELEGATE.dictPayorData["Email"] = txtEmail.text!.uppercased()
            APP_DELEGATE.dictPayorData["FileContent"] = strBase64
            APP_DELEGATE.dictPayorData["CellNumber"] = txtCellNumber.text!
            APP_DELEGATE.dictPayorData["HomeNumber"] = txtHomeNumber.text!
            APP_DELEGATE.dictPayorData["BillCity"] = txtTownCity.text!
            APP_DELEGATE.dictPayorData["BillAddress1"] = txtStreetAddress.text!
            APP_DELEGATE.dictPayorData["BillAddress2"] = txtAppartment.text!
            APP_DELEGATE.dictPayorData["Country"] = txtSelectCountry.text!
            APP_DELEGATE.dictPayorData["Password"] = txtPassword.text!
            APP_DELEGATE.dictPayorData["OtherBillStateName"] = txtSelectCountry.text == "USA" ? "" : txtState.text!
            APP_DELEGATE.dictPayorData["BillStateID"] = txtSelectCountry.text == "USA" ? getStateId : 0
            APP_DELEGATE.dictPayorData["BillZip"] = txtZip.text!

        } else {
            
            
            APP_DELEGATE.dictPayorData["FirstName"]  = txtFirstName.text!
            APP_DELEGATE.dictPayorData["MiddleName"] = txtMiddleName.text!
            APP_DELEGATE.dictPayorData["LastName"] = txtLastName.text!
            APP_DELEGATE.dictPayorData["Email"] = txtEmail.text!.uppercased()
            APP_DELEGATE.dictPayorData["CellNumber"] = txtCellNumber.text!
            APP_DELEGATE.dictPayorData["HomeNumber"] = txtHomeNumber.text!
            APP_DELEGATE.dictPayorData["DateOfBirth"] = txtDateofBirth.text!
            APP_DELEGATE.dictPayorData["ExpirationDate"] = txtExpirationDate.text!
            APP_DELEGATE.dictPayorData["LicenseNo"] = txtLicenseNumber.text!
            APP_DELEGATE.dictPayorData["BillCity"] = txtTownCity.text!
            APP_DELEGATE.dictPayorData["BillAddress1"] = txtStreetAddress.text!
            APP_DELEGATE.dictPayorData["BillAddress2"] = txtAppartment.text!
            APP_DELEGATE.dictPayorData["Country"] = txtSelectCountry.text!
            APP_DELEGATE.dictPayorData["Password"] = txtPassword.text!
            APP_DELEGATE.dictPayorData["OtherBillStateName"] = txtSelectCountry.text == "USA" ? "" : txtState.text!
            APP_DELEGATE.dictPayorData["BillStateID"] = txtSelectCountry.text == "USA" ? getStateId : 0
            APP_DELEGATE.dictPayorData["BillZip"] = txtZip.text!



            dictgetScannerResDup["firstName"] =  APP_DELEGATE.dictPayorData["FirstName"] as? String
            dictgetScannerResDup["lastName"] = APP_DELEGATE.dictPayorData["LastName"] as? String
            dictgetScannerResDup["middleName"] = APP_DELEGATE.dictPayorData["MiddleName"] as? String
            dictgetScannerResDup["cellNo"] = APP_DELEGATE.dictPayorData["CellNumber"] as? String
            dictgetScannerResDup["homeNo"] = APP_DELEGATE.dictPayorData["HomeNumber"] as? String
            dictgetScannerResDup["licenseNo"] = APP_DELEGATE.dictPayorData["LicenseNo"] as? String
            dictgetScannerResDup["expiry"] = APP_DELEGATE.dictPayorData["ExpirationDate"] as? String
            dictgetScannerResDup["dob"] = APP_DELEGATE.dictPayorData["DateOfBirth"] as? String
            dictgetScannerResDup["email"] = APP_DELEGATE.dictPayorData["Email"] as? String
        }
        


        if APP_DELEGATE.arrSaveOperatorList.count > 0 {
            let retrive = OperatorListVC.instantiate(fromAppStoryboard: .Login)
            retrive.arrOperatorList = APP_DELEGATE.arrSaveOperatorList
            self.navigationController?.pushViewController(retrive, animated: true)
        } else {
            let retrive = AddOperator.instantiate(fromAppStoryboard: .Login)
            retrive.dictSamedata = dictgetScannerResDup
            retrive.isCome = "New"
            APP_DELEGATE.arrSaveOperatorList.removeAll()
            self.navigationController?.pushViewController(retrive, animated: true)
        }

    }
    

    func clearData() {
        self.txtEmail.text = ""
        self.txtHomeNumber.text = ""
        self.txtLicenseNumber.text = ""
        self.txtDateofBirth.text = ""
        self.txtFirstName.text = ""
        self.txtLastName.text = ""
        self.txtMiddleName.text = ""
        self.txtCellNumber.text = ""
        self.txtZip.text = ""
        self.txtAppartment.text = ""
        self.txtSelectCountry.text = ""
        self.txtConfirmPassword.text = ""
        self.txtPassword.text = ""
        self.txtStreetAddress.text = ""
        strBase64 = ""
        APP_DELEGATE.arrSaveOperatorList.removeAll()
        

    }

    //MARK:- PIckerDone Method
    @objc func onDoneTxtDobClick() {
        if let  datePicker = self.txtDateofBirth.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MM/dd/yyyy"
            self.txtDateofBirth.text = dateFormatter.string(from: datePicker.date)
            self.txtDateofBirth.resignFirstResponder()
            guard let  getstr = txtDateofBirth.text , getstr != "" else{
                self.txtDateofBirth.resignFirstResponder()
                return
            }
            let age = calcAge(birthday: txtDateofBirth.text!)
            print(age)
            if(age < 18){
                txtDateofBirth.text = ""
                Utils.showMessage(type: .error,message: "Minimum age should be 18")
            }
        }
     }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }

    @objc func onDoneTxtExpirationClick() {
        if let  datePicker = self.txtExpirationDate.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MM/dd/yyyy"
            self.txtExpirationDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.txtExpirationDate.resignFirstResponder()
     }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }


    //MARK:- UITextfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPassword ||  textField == txtConfirmPassword {
            textField.keyboardType = .default
            textField.autocapitalizationType  = .none
        }
        if textField == txtDateofBirth {
            txtDateofBirth.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtDobClick), isDob: true, isTime: false)
        }
        else if textField == txtState {
            if txtSelectCountry.text == "" {
                txtState.resignFirstResponder()
                return Utils.showMessage(type: .error, message: "Please select country first")
            }
            
            else {
                pickerState.reloadAllComponents()
            }
        }

        else if textField == txtExpirationDate {
            txtExpirationDate.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtExpirationClick), isDob: false, isTime: false)
        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtPassword ||  textField == txtConfirmPassword {
            textField.keyboardType = .default
            textField.autocapitalizationType  = .none
        }

        if textField == txtCellNumber || textField == txtHomeNumber {
            let maxLength = 13
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            textField.text =  Common.shared.formatPhoneLogin(textField.text!)
            return newString.length <= maxLength
            // All digits entered
        }
        
        else if  textField == txtZip{
            let maxLength = 12
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    

    func range(_ range: NSRange, containsLocation location: Int) -> Bool {
        if range.location <= location && range.location + range.length >= location {
            return true
        }

        return false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtDateofBirth.resignFirstResponder()
    }

    //MARK:- UITextView Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        textView.text =  textView.text?.uppercased()

    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = "NOTE"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }
        return false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "NOTE"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    
    //MARK:- Mlutipart Data Api
    func upload(image: Data, to url: Alamofire.URLRequestConvertible, params: [String: Any]) {
        
        Utils.showProgressHud()
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(image,withName: "file", fileName: "RegisterPic.jpeg", mimeType: "image/jpeg")
        }, with: url)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
        .responseJSON(completionHandler: { [self] data in
                //Do what ever you want to do with response
                print("Get Response is:\(data)")
                let json =  JSON(data.value as Any)
                Utils.hideProgressHud()
                if let error = json["error"].dictionary {
                    Utils.showMessage(type: .error, message: error["message"]!.stringValue)
                } else {
                    Utils.hideProgressHud()
                   // let getAuthentication = json["authentication"].dictionary
                    if  json["matchrate"].stringValue != "0"{
                        dictgetScannerRes = json["result"].dictionary!
                        if dictgetScannerRes["documentSide"] == "FRONT" {
                            strBase64 = image.base64EncodedString()
                            self.callSetData(dictdata: json["result"].dictionary!)
                        } else {
                            Utils.showMessage(type: .error, message: "Request you to scan front of ID")

                        }
                    } else {
                        Utils.showMessage(type: .error, message: "Please capture proper image")
                    }
                }
            })
    }
    
    func callSetData(dictdata:[String:JSON]) {
        self.txtFirstName.text = dictdata["firstName"]?.string?.uppercased()
        self.txtLastName.text = dictdata["lastName"]?.string?.uppercased()
        self.txtMiddleName.text = dictdata["middleName"]?.string?.uppercased()
        self.txtSelectCountry.text = dictdata["nationality_iso3"]?.string?.uppercased()
        self.txtStreetAddress.text = dictdata["address1"]?.string?.uppercased()
        let arrSep =  dictdata["address2"]?.string?.uppercased().components(separatedBy: ",")
        if arrSep?.count ?? 1>0  {
            self.txtTownCity.text = arrSep?[0]
        } else {
            self.txtTownCity.text = ""
        }
       // self.txtAppartment.text = dictdata["address2"]?.string?.uppercased()

        
        let month = "\(dictdata["dob_month"]?.intValue ?? 0)"
        let day = "\(dictdata["dob_day"]?.intValue ?? 0 )"
        let monthExp = "\(dictdata["expiry_month"]?.intValue ?? 0)"
        let dayExp = "\(dictdata["expiry_day"]?.intValue ?? 0)"
        self.txtDateofBirth.text = (month != "" && !month.isEmpty && month != "0") ? "\(month.PadLeft(totalWidth: 2, byString: "0"))/\(day.PadLeft(totalWidth: 2, byString: "0"))/\(dictdata["dob_year"]?.intValue ?? 0)" : ""
        self.txtExpirationDate.text = (monthExp != "" && !monthExp.isEmpty && monthExp != "0") ? "\(monthExp.PadLeft(totalWidth: 2, byString: "0"))/\(dayExp.PadLeft(totalWidth: 2, byString: "0"))/\(dictdata["expiry_year"]?.intValue ?? 0)"  : ""
        


        self.txtZip.text = dictdata["postcode"]?.string?.uppercased()
        self.txtLicenseNumber.text = dictdata["documentNumber"]?.string?.uppercased()
        self.txtState.text = dictdata["issuerOrg_region_full"]?.string?.uppercased()
}
    
    //MARK: - ImagePicker delegate
    
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            self.getImage = image
            if  self.getImage.size.width != 0 {
                self.clearData()
                let imgData  = self.getImage.jpegData(compressionQuality:0.3)
                var param = [String:Any]()
                param["apikey"] = APP_DELEGATE.scanerKey
                param["authenticate"] = "true"
                param["type"] = "PD"
                param["vault_save"] = "false"
                var urlRequest = URLRequest(url: URL(string: "https://api.idanalyzer.com")!)
                urlRequest.method = .post
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                self.upload(image: imgData!, to: urlRequest, params: param)
            }

        }
    }

}
