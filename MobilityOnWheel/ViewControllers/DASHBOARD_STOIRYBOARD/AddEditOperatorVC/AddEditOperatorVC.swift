//
//  REditProfileVC.swift
//  AamluckyRetailer
//
//  Created by Arvind Kanjariya on 24/01/20.
//  Copyright © 2020 Arvind Kanjariya. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit
import AVFoundation
import Alamofire
class AddEditOperatorVC: SuperViewController,UITextViewDelegate,UITextFieldDelegate,CommonPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,OnCloseClick{

    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMiddleName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCellNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtHomeNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLicenseNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var txtExpirationDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtDateofBirth: SkyFloatingLabelTextField!
    @IBOutlet weak var txtHeihtInFt: SkyFloatingLabelTextField!
    @IBOutlet weak var txtHeihtInInch: SkyFloatingLabelTextField!
    @IBOutlet weak var txtWeight: SkyFloatingLabelTextField!

    @IBOutlet weak var viewScan: UIView!
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var btnCheck:UIButton!
    @IBOutlet weak var conViewHeaderHeight:NSLayoutConstraint!
    @IBOutlet weak var viewHeader:UIView!
    @IBOutlet weak var lblSelction: UILabel!

    
    
    var arrCountry = [String]()
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var isCome = String()
    var dictSamedata = OperatorListSubRes()
    var dictDup  = [String:Any]()
    var index = Int()
    fileprivate let  pickerHeightFeet = CommonPicker()
    fileprivate let  pickerHeightInch = CommonPicker()
    
    var arrFeet = [String]()
    var arrInch = [String]()
    var getImage = UIImage()
    var strBase64:String = ""
    var dictgetScannerRes = [String:JSON]()
    var traingView: TrainingVideo!
    var cardView: CardAgrement!
    var isNewOpe = String()
    var dictNewData = CustomerAdressModel()

    //MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
    }
    
    func SetUI(){
        
        let txtTitle = "Scan Front of Operator's ID now *"
//        btnScan.titleLabel?.text  = txtTitle
        let range = (txtTitle as NSString).range(of: "*")
        let attributedString = NSMutableAttributedString(string:txtTitle)
        attributedString.addAttributes([.foregroundColor : UIColor.red,.baselineOffset:3], range: range)
//            //Apply to the label
//            lblScan.attributedText = attributedString
        btnScan.setAttributedTitle(attributedString, for: .normal)

        Common.shared.addSkyTextfieldwithAssertick(to: txtFirstName, placeHolder: "First Name")
        Common.shared.setFloatlblTextField(placeHolder: "Middle Name", textField: txtMiddleName)
        Common.shared.addSkyTextfieldwithAssertick(to: txtLastName, placeHolder: "Last Name")
        Common.shared.addSkyTextfieldwithAssertick(to: txtCellNumber, placeHolder: "Cell Number")
        Common.shared.setFloatlblTextField(placeHolder: "Home Number", textField: txtHomeNumber)
        Common.shared.addSkyTextfieldwithAssertick(to: txtEmail, placeHolder: "Email")
        Common.shared.addSkyTextfieldwithAssertick(to: txtLicenseNumber, placeHolder: "License Number")
        Common.shared.addSkyTextfieldwithAssertick(to: txtExpirationDate, placeHolder: "Expiration Date")
        Common.shared.addSkyTextfieldwithAssertick(to: txtDateofBirth, placeHolder: "Date of Birth")
        Common.shared.addSkyTextfieldwithAssertick(to: txtWeight, placeHolder: "Weight(in lbs)")
        Common.shared.addSkyTextfieldwithAssertick(to: txtHeihtInFt, placeHolder: "Height(ft.)")
        Common.shared.addSkyTextfieldwithAssertick(to: txtHeihtInInch, placeHolder: "Height(in.)")

        txtCellNumber.keyboardType = .numberPad
        txtHomeNumber.keyboardType = .numberPad
        txtEmail.keyboardType = .emailAddress
        txtLicenseNumber.keyboardType = .default
        txtWeight.keyboardType = .numberPad
        txtHeihtInFt.keyboardType = .numberPad
        txtHeihtInInch.keyboardType = .numberPad

        viewScan.layer.cornerRadius = 8
        viewScan.layer.borderColor = AppConstants.kBorder_Color.cgColor
        viewScan.layer.borderWidth = 0.8
        arrCountry = ["Other","USA"]
        
        conViewHeaderHeight.constant = 60
        
        arrFeet = (4...9).map{"\($0)"}
        arrInch = (1...13).map{"\($0)"}
        
        pickerHeightFeet.delegate = self
        pickerHeightFeet.dataSource = self
        self.pickerHeightFeet.toolbarDelegate = self

        pickerHeightInch.delegate = self
        pickerHeightInch.dataSource = self
        self.pickerHeightInch.toolbarDelegate = self

        self.txtHeihtInInch.inputView = self.pickerHeightInch
        self.txtHeihtInInch.inputAccessoryView = self.pickerHeightInch.toolbar
        self.pickerHeightInch.selectRow(0, inComponent: 0, animated: false)

        self.txtHeihtInFt.inputView = self.pickerHeightFeet
        self.txtHeihtInFt.inputAccessoryView = self.pickerHeightFeet.toolbar
        self.pickerHeightFeet.selectRow(0, inComponent: 0, animated: false)

        self.viewHeader.updateConstraintsIfNeeded()
        self.viewHeader.layoutIfNeeded()
        
        CommonApi.callgetScannerApiKey(completionHandler: {(getStrVal) in
            if getStrVal != "" { APP_DELEGATE.scanerKey  =  getStrVal} else {
                APP_DELEGATE.scanerKey  = ""
            }
        }, controll: self)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        if isCome == "Edit" {
            btnCheck.isHidden = false
            lblSelction.isHidden = false
            disPlayData()
        }
        super.viewWillAppear(animated)
    }
    //MARK:- Delegate Function
    func onClose() {
    
        if self.cardView != nil {
            self.cardView.removeFromSuperview()
        }
        
        if self.traingView != nil {
            self.traingView.removeFromSuperview()
        }

    }

    //MARK:- PickerView Delegate

    func didTapDone() {
        self.view.endEditing(true)
    }

    //MARK:- Custom Functions
    
    func disPlayData() {
        let getFullName =  dictSamedata.fullName.components(separatedBy: " ")
        if getFullName.count != 3 {
            self.txtLastName.text = getFullName[1]
            self.txtMiddleName.text = ""
        } else {
            self.txtLastName.text = getFullName[2]
            self.txtMiddleName.text = getFullName[1]
        }
        
        self.txtFirstName.text = getFullName[0]
        if isCome == "Edit"{
            if dictSamedata.isDefault == true {
                btnCheck.isSelected = true
            } 
            if dictSamedata.dOB != "" {
                let dobArr = dictSamedata.dOB.components(separatedBy: " ")
                self.txtDateofBirth.text = Common.shared.changeDateFormat(strDate: dobArr[0])
            }
            if dictSamedata.expiryDate != "" {
                let expiryArr = dictSamedata.expiryDate.components(separatedBy: " ")
                self.txtExpirationDate.text = Common.shared.changeDateFormat(strDate: expiryArr[0])
            }
        } else {
            self.txtDateofBirth.text = dictSamedata.dOB
            self.txtExpirationDate.text = dictSamedata.expiryDate
        }
        self.txtLicenseNumber.text = "\(dictSamedata.licenceNo)".uppercased()
        self.txtCellNumber.text = dictSamedata.operatorCellNumber
        self.txtHomeNumber.text = dictSamedata.operatorHomeNumber
        self.txtEmail.text  = dictSamedata.emailId.uppercased()
        if dictSamedata.weight != 0 {
            self.txtWeight.text =  "\(dictSamedata.weight)"
        }
        if dictSamedata.heightFeet != 0 {
            self.txtHeihtInFt.text =  "\(dictSamedata.heightFeet)"
        }
        if dictSamedata.heightInch != 0 {
            self.txtHeihtInInch.text =  "\(dictSamedata.heightInch)"
        }

    }
    func displayNewData() {
        

        self.txtFirstName.text = dictNewData.firstName.uppercased()
        self.txtLastName.text = dictNewData.lastName.uppercased()
        self.txtMiddleName.text = dictNewData.middleName.uppercased()
        let dobArr = dictNewData.dob.components(separatedBy: " ")
        let expArr = dictNewData.expDate.components(separatedBy: " ")
        if dictNewData.dob != "" {
            self.txtDateofBirth.text =  Common.shared.changeDateFormat(strDate: dobArr[0])
        }
        if dictNewData.expDate != "" {
            self.txtExpirationDate.text = Common.shared.changeDateFormat(strDate: expArr[0])
        }
        self.txtLicenseNumber.text = "\(dictNewData.licenseNo)".uppercased()
        self.txtCellNumber.text = dictNewData.cellNo
        self.txtHomeNumber.text = dictNewData.homeNo
        self.txtEmail.text  = dictNewData.email.uppercased()
        self.txtHeihtInFt.text =  ""
        self.txtHeihtInInch.text =  ""
        self.txtWeight.text =  ""
    }

    func clearData() {
        self.txtEmail.text = ""
        self.txtHomeNumber.text = ""
        self.txtLicenseNumber.text = ""
        self.txtDateofBirth.text = ""
        self.txtFirstName.text = ""
        self.txtLicenseNumber.text = ""
        self.txtLastName.text = ""
        self.txtMiddleName.text = ""
        self.txtCellNumber.text = ""
        self.txtWeight.text = ""
        self.txtHeihtInFt.text = ""
        self.txtHeihtInInch.text = ""
        self.txtExpirationDate.text = ""

    }

    //MARK: -UIAction

    @IBAction func btnContinueClick(_ sender: Any) {
        self.view.endEditing(true)
        checkValidation()
    }
    @IBAction func btnHomeClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnInfoClick(_ sender: Any) {
        APP_DELEGATE.isComeFrom = "AddOperator"
        APP_DELEGATE.strtxtDisplay = dictOccupantOperatorInfo.defineOperator
        traingView = TrainingVideo(frame: SCREEN_RECT)
        traingView.delegate = self
        self.view.addSubview(traingView)
        self.view.bringSubviewToFront(traingView)

        
    }

    @IBAction func btnScannerClick(_ sender: Any) {
        self.view.endEditing(true)
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .camera;
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
        checkCameraAccess()
    }

        
    @IBAction func btnCheckUncheckClick(_ sender: Any) {
        self.view.endEditing(true)
        btnCheck.isSelected = !btnCheck.isSelected
        if btnCheck.isSelected  {
            if isNewOpe  == "New" {
                displayNewData()
            } else {
                displayNewData()
            }
        } else {
                clearData()
        }
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

    
    //MARK:- SetFunctions For Validation
    func checkValidation (){
        if btnCheck.isSelected == true {
            print("Scan is not required")
            strBase64 = ""
        } else {
            if isCome == "Edit" {
                if dictSamedata.fileName  == ""  {
                    if strBase64 == "" {
                        return Utils.showMessage(type: .error, message: "Scan valid ID required")
                    }else {}
                } else {  print("Scan is not required")}
            } else {
                if strBase64 == "" {
                            return Utils.showMessage(type: .error, message: "Scan valid ID required")
                }
            }
        }
        guard  let name  = txtFirstName.text, name != "" , !name.isEmpty else {
            return  Utils.showMessage(type: .error, message: "Please enter first name")
        }
        
        guard  let lastname  = txtLastName.text, lastname != "" , !lastname.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter last name")
        }

        guard  let cellNo  = txtCellNumber.text, cellNo != "" , !cellNo.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter cell number")
        }

        if !txtCellNumber.text!.isPhoneNumber {
            return  Utils.showMessage(type: .error,message: "Please enter valid cell number")
        }
        
        guard  let email  = txtEmail.text, email != "" , !email.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter email")
        }

        if !Common.shared.isValidEmail(testStr: txtEmail.text!) {
            Utils.showMessage(type: .error,message: "Please enter valid email")
        }
        guard  let licNo  = txtLicenseNumber.text, licNo != "" , !licNo.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter license number")
        }

//        if  txtLicenseNumber.text!.count < 6 || txtLicenseNumber.text!.count  > 12   {
//            return  Utils.showMessage(type: .error,message: "Please enter valid license number")
//        }
        
        guard  let weight  = txtWeight.text, weight != "" , !weight.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter weight")
        }
        
        guard  let heightInch  = txtHeihtInInch.text, heightInch != "" , !heightInch.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please select heightInch")
        }

        guard  let heightFeet  = txtHeihtInFt.text, heightFeet != "" , !heightFeet.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please select heightFeet")
        }

        callAddEditOperator()
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
    
    @objc func onDoneTxtExpirationClick() {
        if let  datePicker = self.txtExpirationDate.inputView as? UIDatePicker {
            datePicker.minimumDate = Date()
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

    //MARK:- UItextfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDateofBirth {
            txtDateofBirth.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtDobClick), isDob: true, isTime: false)
        }
        else if textField == txtExpirationDate {
            txtExpirationDate.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtExpirationClick), isDob: false, isTime: false)
        }
        
        if textField == txtHeihtInFt {
            pickerHeightFeet.reloadAllComponents()
        }
       
        if textField == txtHeihtInInch {
            pickerHeightInch.reloadAllComponents()
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCellNumber || textField == txtHomeNumber {
            let maxLength = 13
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            textField.text =  Common.shared.formatPhoneLogin(textField.text!)
            return newString.length <= maxLength
        }
        if textField == txtWeight {
            let maxLength = 3
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == txtHeihtInInch {
            let maxLength = 2
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == txtHeihtInFt {
            let maxLength = 1
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtDateofBirth.resignFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isNewOpe = ""
    }
    
    //MARK:- Picker Controller
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == pickerHeightFeet {
                return self.arrFeet.count
            }
           return self.arrInch.count
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
                return 1
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == pickerHeightInch {
                return self.arrInch[row].PadLeft(totalWidth: 2, byString: "0")

            }
            return self.arrFeet[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == pickerHeightInch {
                txtHeihtInInch.text = self.arrInch[row].PadLeft(totalWidth: 2, byString: "0")

            } else {
                txtHeihtInFt.text = self.arrFeet[row].PadLeft(totalWidth: 2, byString: "0")

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
            multiPart.append(image,withName: "file", fileName: "EditAddOperator.jpeg", mimeType: "image/jpeg")
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
        self.txtFirstName.text = dictdata["firstName"]?.string
        self.txtLastName.text = dictdata["lastName"]?.string
        self.txtMiddleName.text = dictdata["middleName"]?.string
        self.txtDateofBirth.text = "\(dictdata["dob_month"]?.intValue ?? 0)/\(dictdata["dob_day"]?.intValue ?? 0)/\(dictdata["dob_year"]?.intValue ?? 0)"
        self.txtExpirationDate.text = "\(dictdata["expiry_month"]?.intValue ?? 0)/\(dictdata["expiry_day"]?.intValue ?? 0)/\(dictdata["expiry_year"]?.intValue ?? 0)"
        self.txtLicenseNumber.text = dictdata["documentNumber"]?.string
}

    //MARK: - ImagePicker delegate
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            self?.getImage = image
            if  self?.getImage.size.width != 0 {
                let imgData  = self?.getImage.jpegData(compressionQuality:0.3)
                var param = [String:Any]()
                param["apikey"] = APP_DELEGATE.scanerKey
                param["authenticate"] = "true"
                param["type"] = "PD"
                param["vault_save"] = "false"
                var urlRequest = URLRequest(url: URL(string: "https://api.idanalyzer.com")!)
                urlRequest.method = .post
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                self?.upload(image: imgData!, to: urlRequest, params: param)
            }
        }
    }

    //MARK:- Call Api of AddEdit Operator
    
    func callAddEditOperator() {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.addEditOperator
        let getUId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        var param1 = [
            
                    "CustomerID":getUId,
                      "DateOfBirth":txtDateofBirth.text!,
                      "ExpirationDate":txtExpirationDate.text!,
                      "LicenceNo":txtLicenseNumber.text!,
                     "FirstName":txtFirstName.text!,
                     "MiddleName":txtMiddleName.text!,
                     "LastName":txtLastName.text!,
                     "OperatorCellNumber":txtCellNumber.text!,
                     "OperatorHomeNumber":txtHomeNumber.text!,
            "EmailId":txtEmail.text!,
            "Weight":Int(txtWeight.text!)!,
            "HeightFeet":Int(txtHeihtInFt.text!)!,
            "HeightInch":Int(txtHeihtInInch.text!)!,
            "isdefault":btnCheck.isSelected ? true : false,
            "Notes":dictSamedata.notes,
            "DeviceTypeID":APP_DELEGATE.deviceTypeId,
//            "MimeType":"image/jpeg",
//            "FileName":"EditAddOperator.jpeg",
//            "AccessoryTypeID":0,
//            "DeviceTypeID":APP_DELEGATE.deviceTypeId,
//            "DeviceStyle":"",
//            "FileContent":"strBase64"
        ] as [String : Any]
        if getImage.size.width != 0 {
                param1["FileContent"] = strBase64
                param1["FileName"] =  "EditAddOperator.jpeg"
                param1["MimeType"]  =  "image/jpeg"
            }

        if isNewOpe  == "New" {
            param1["OperatorID"] = 0
        } else {
            param1["OperatorID"] = dictSamedata.operatorID
        }
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
                               APP_DELEGATE.arrSaveOperatorList.removeAll()
                            Utils.showMessage(type: .success, message:dicResponseData["Message"]?.stringValue ?? "")
                                APP_DELEGATE.validateLicenseApi(completionHandler: {success in
                                       if success ==  false {
                                       }else {}
                                   })
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
