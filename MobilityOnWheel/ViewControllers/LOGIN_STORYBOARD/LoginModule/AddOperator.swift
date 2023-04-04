//
//  REditProfileVC.swift
//  AamluckyRetailer
//
//  Created by Arvind Kanjariya on 24/01/20.
//  Copyright © 2020 Arvind Kanjariya. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AVKit
class AddOperator: SuperViewController,UITextViewDelegate,UITextFieldDelegate,CommonPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,OnCloseClick{

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
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var conViewAppIconHeight:NSLayoutConstraint!
    @IBOutlet weak var imgAppIcon:UIImageView!
    @IBOutlet weak var lblScan: UILabel!
    @IBOutlet weak var viewSave:UIView!
    @IBOutlet weak var viewBack:UIView!
    @IBOutlet weak var viewCancel_Delete:UIView!

    
    
    
    var arrCountry = [String]()
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var isCome = String()
    var dictSamedata = [String:Any]()
    var dictDup  = [String:Any]()
    var index = Int()
    var strPickerSelection:String = ""
    fileprivate let  pickerHeightFeet = CommonPicker()
    fileprivate let  pickerHeightInch = CommonPicker()
    
    var arrFeet = [String]()
    var arrInch = [String]()
    var getImage = UIImage()
    var strBase64:String = ""
    var dictgetScannerRes = [String:JSON]()
    var traingView: TrainingVideo!
    var cardView: CardAgrement!

    //MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let txtTitle = "Scan Front of Operator's ID now *"
//        btnScan.titleLabel?.text  = txtTitle
        let range = (txtTitle as NSString).range(of: "*")
        let attributedString = NSMutableAttributedString(string:txtTitle)
        attributedString.addAttributes([.foregroundColor : UIColor.red,.baselineOffset:3], range: range)
//            //Apply to the label
//            lblScan.attributedText = attributedString
        btnScan.setAttributedTitle(attributedString, for: .normal)
        CommonApi.callgetScannerApiKey(completionHandler: {(getStrVal) in
            if getStrVal != "" { APP_DELEGATE.scanerKey  =  getStrVal} else {
                APP_DELEGATE.scanerKey  = ""
            }
        }, controll: self)
        SetUI()
    }
    

    func SetUI(){
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
        txtLicenseNumber.keyboardType = .default
        txtWeight.keyboardType = .numberPad
        txtHeihtInFt.keyboardType = .numberPad
        txtHeihtInInch.keyboardType = .numberPad

        viewScan.layer.cornerRadius = 8
        viewScan.layer.borderColor = AppConstants.kBorder_Color.cgColor
        viewScan.layer.borderWidth = 0.8
        arrCountry = ["Other","USA"]
        
      //  conViewHeaderHeight.constant = 50
        
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

        self.txtHeihtInFt.inputView = self.pickerHeightFeet
        self.txtHeihtInFt.inputAccessoryView = self.pickerHeightFeet.toolbar

        self.viewHeader.updateConstraintsIfNeeded()
        self.viewHeader.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
//        if isCome == "Reg" {
//            btnCheck.isHidden = false
//            lblSelction.isHidden = false
//            conViewAppIconHeight.constant  = 100
//            dictDup = dictSamedata
//            disPlayData()
//            let arrFiltered = APP_DELEGATE.arrSaveOperatorList.filter{$0["isSameData"]as? String == "1"}
//            if arrFiltered.count > 0 {
//                    if   dictSamedata["isSameData"] as? String == "1" {
//                        self.btnCheck.isSelected = true
//                        self.btnCheck.isHidden = false
//                        self.lblSelction.isHidden = false
//                    } else {
//                        self.btnCheck.isHidden = true
//                        self.lblSelction.isHidden = true
//                    }
//                } else {
//                        self.btnCheck.isSelected = false
//                        self.btnCheck.isHidden = false
//                        self.lblSelction.isHidden = false
//                }
//
//            imgAppIcon.layoutIfNeeded()
//            imgAppIcon.updateConstraintsIfNeeded()
//
//        } else  {
//
//            let arrFiltered = APP_DELEGATE.arrSaveOperatorList.filter{$0["isSameData"]as? String == "1"}
//            if arrFiltered.count > 0 {
//                btnCheck.isHidden = true
//                    lblSelction.isHidden = true
//            } else {
//                btnCheck.isHidden = false
//                lblSelction.isHidden = false
//                btnCheck.isSelected = false
//            }
//        }
        
        if isCome == "New"  {
            btnCheck.isHidden = false
            lblSelction.isHidden = false
            btnCheck.isSelected = false
            viewCancel_Delete.isHidden = true
            viewBack.isHidden = false
        }else if isCome ==  "Edit" {
            let arrFiltered = APP_DELEGATE.arrSaveOperatorList.filter{$0["isSameData"]as? String == "1"}
            
            if arrFiltered.count > 0 {
                    if   dictSamedata["isSameData"] as? String == "1" {
                        self.btnCheck.isSelected = true
                        self.btnCheck.isHidden = false
                        self.lblSelction.isHidden = false
                    } else {
                        self.btnCheck.isHidden = true
                        self.lblSelction.isHidden = true
                    }
                } else {
                        self.btnCheck.isSelected = false
                        self.btnCheck.isHidden = false
                        self.lblSelction.isHidden = false
                }
            disPlayData()
            viewCancel_Delete.isHidden = false
            viewBack.isHidden = true
        }else {
            viewCancel_Delete.isHidden = true
            viewBack.isHidden = false
            let arrFiltered = APP_DELEGATE.arrSaveOperatorList.filter{$0["isSameData"]as? String == "1"}
            if arrFiltered.count > 0 {
                btnCheck.isHidden = true
                    lblSelction.isHidden = true
            } else {
                btnCheck.isHidden = false
                lblSelction.isHidden = false
                btnCheck.isSelected = false
            }
            
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
        if strPickerSelection == "height" {
            let selIndex = self.pickerHeightInch.selectedRow(inComponent: 0)
            txtHeihtInInch.text = self.arrInch[selIndex].PadLeft(totalWidth: 2, byString: "0")

        } else {
            let selectIndex = self.pickerHeightFeet.selectedRow(inComponent: 0)
            txtHeihtInFt.text = self.arrFeet[selectIndex].PadLeft(totalWidth: 2, byString: "0")
        }

    }

    //MARK:- Custom Functions
    func displayPayorSameData() {
        self.txtFirstName.text = APP_DELEGATE.dictPayorData["FirstName"] as? String
        self.txtMiddleName.text = APP_DELEGATE.dictPayorData["MiddleName"] as? String
        self.txtLastName.text = APP_DELEGATE.dictPayorData["LastName"] as? String
        self.txtExpirationDate.text = APP_DELEGATE.dictPayorData["ExpirationDate"] as? String
        self.txtEmail.text = APP_DELEGATE.dictPayorData["Email"] as? String
        self.txtDateofBirth.text = APP_DELEGATE.dictPayorData["DateOfBirth"] as? String
        self.txtLicenseNumber.text = APP_DELEGATE.dictPayorData["LicenseNo"] as? String
        self.txtCellNumber.text = APP_DELEGATE.dictPayorData["CellNumber"] as? String
        self.txtHomeNumber.text = APP_DELEGATE.dictPayorData["HomeNumber"] as? String
        self.txtWeight.text = ""
        self.txtHeihtInFt.text = ""
        self.txtHeihtInInch.text = ""

    }
    
    func disPlayData() {
        
        self.txtFirstName.text = dictSamedata["firstName"] as? String ?? ""
        self.txtLastName.text = dictSamedata["lastName"] as? String  ?? ""
        self.txtMiddleName.text = dictSamedata["middleName"] as? String ??  ""
        self.txtWeight.text =  dictSamedata["weight"] as? String ?? ""
        self.txtDateofBirth.text = dictSamedata["dob"] as? String ?? ""
        self.txtExpirationDate.text = dictSamedata["expiry"] as? String ?? ""
        self.txtLicenseNumber.text = dictSamedata["licenseNo"] as? String ?? ""
        self.txtCellNumber.text = dictSamedata["cellNo"]  as? String ?? ""
        self.txtHomeNumber.text = dictSamedata["homeNo"]  as? String ?? ""
        self.txtEmail.text  = dictSamedata["email"]  as? String ?? ""
        
        guard let  height = dictSamedata["height"], height as! String != "" else {
            txtHeihtInFt.text = ""
            txtHeihtInInch.text = ""
            return
        }
        let heightArr = (height as AnyObject).components(separatedBy: "-")
        self.txtHeihtInFt.text =  heightArr[1]
        self.txtHeihtInInch.text =  heightArr[0]
        self.strBase64 = dictSamedata["FileContent"] as? String ?? ""
    }
    
    func updateData() {
        dictSamedata["firstName"]  = self.txtFirstName.text
        dictSamedata["lastName"]  = self.txtLastName.text
        dictSamedata["middleName"] = self.txtMiddleName.text
        dictSamedata["weight"] = self.txtWeight.text
        dictSamedata["dob"]   = self.txtDateofBirth.text
        dictSamedata["expiry"] = self.txtExpirationDate.text
        dictSamedata["licenseNo"] = self.txtLicenseNumber.text
        dictSamedata["height"] = self.txtHeihtInInch.text! + "-" + self.txtHeihtInFt.text!
        dictSamedata["cellNo"]  = self.txtCellNumber.text
        dictSamedata["homeNo"] =  self.txtHomeNumber.text
         dictSamedata["email"] = self.txtEmail.text
    }
    
    func saveData() {
        var dictGetallData = [String:Any]()
        dictGetallData["firstName"]  = self.txtFirstName.text!
        dictGetallData["lastName"]  = self.txtLastName.text
        dictGetallData["middleName"] = self.txtMiddleName.text
        dictGetallData["weight"] = self.txtWeight.text
        dictGetallData["dob"]   = self.txtDateofBirth.text
        dictGetallData["expiry"] = self.txtExpirationDate.text
        dictGetallData["licenseNo"] = self.txtLicenseNumber.text
        dictGetallData["height"] = self.txtHeihtInFt.text! + "-" + self.txtHeihtInInch.text!
        dictGetallData["cellNo"]  = self.txtCellNumber.text
        dictGetallData["homeNo"] =  self.txtHomeNumber.text
        dictGetallData["email"] = self.txtEmail.text
        dictGetallData["isSameData"] = btnCheck.isSelected ? "1" : "0"
        
        //KHUSHBU CHANGES
        
        if isCome == "New" {
            if  self.getImage.size.width != 0 {
                    dictGetallData["FileContent"] = strBase64
                    dictGetallData["MimeType"] = "image/jpeg"
                    dictGetallData["FileName"] = "Operator.jpeg"
            }
            APP_DELEGATE.arrSaveOperatorList.append(dictGetallData)
            let arrFiltered = APP_DELEGATE.arrSaveOperatorList.filter{$0["isSameData"]as? String == "1"}
            if arrFiltered.count > 0 {
                              btnCheck.isHidden = true
                              lblSelction.isHidden = true
                          } else {
                              btnCheck.isHidden = false
                              lblSelction.isHidden = false
                          }
            let movetoOpeList = OperatorListVC.instantiate(fromAppStoryboard: .Login)
            self.navigationController?.pushViewController(movetoOpeList, animated: true)
        } else if isCome == "Edit"   {
                dictGetallData["FileContent"] = strBase64
                dictGetallData["MimeType"] = "image/jpeg"
                dictGetallData["FileName"] = "Operator.jpeg"
                APP_DELEGATE.arrSaveOperatorList.remove(at: index)
                APP_DELEGATE.arrSaveOperatorList.append(dictGetallData)
            self.navigationController?.popViewController(animated: true)
        }else {
            if  self.getImage.size.width != 0 {
                    dictGetallData["FileContent"] = strBase64
                    dictGetallData["MimeType"] = "image/jpeg"
                    dictGetallData["FileName"] = "Operator.jpeg"
            }
            APP_DELEGATE.arrSaveOperatorList.append(dictGetallData)
            self.navigationController?.popViewController(animated: true)
        }

        clearData()
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
        self.btnCheck.isSelected = false
    }

    //MARK:- UIAction
    @IBAction func btnContinueClick(_ sender: Any) {
        self.view.endEditing(true)
        checkValidation()
    }
    
    @IBAction func btnBackTapped(_ sender: Any) {
        clearData()
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDeleteTapped(_ sender: Any) {
        APP_DELEGATE.arrSaveOperatorList.remove(at: index)
        if APP_DELEGATE.arrSaveOperatorList.count > 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            for controller in self.navigationController!.viewControllers as Array {
                       if controller.isKind(of: RegisterVC.self) {
                           let getVC = controller as! RegisterVC
                           self.navigationController!.popToViewController(getVC, animated: true)
                           break
                       }
                   }
        }
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

    @IBAction func btnAddClick(_ sender: Any) {
        self.view.endEditing(true)
        btnAdd.isSelected = true
        checkValidation()
    }
        
    @IBAction func btnCheckUncheckClick(_ sender: Any) {
        self.view.endEditing(true)
        btnCheck.isSelected = !btnCheck.isSelected
        if btnCheck.isSelected == true {
            displayPayorSameData()
        } else  {
                clearData()
        }
        isSelectOccupantSame = btnCheck.isSelected ? "1" : "0"
    }

    //MARK:- SetFunctions For Validation
    func checkValidation (){
        
        if btnCheck.isSelected == true {
            print("Scan is not required")
            strBase64 = ""
        } else {
                if strBase64 == "" {
                        return Utils.showMessage(type: .error, message: "Scan valid ID required")
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
        guard  let weight  = txtWeight.text, weight != "" , !weight.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter weight")
        }
        guard  let heightInch  = txtHeihtInInch.text, heightInch != "" , !heightInch.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please select heightInch")
        }
        guard  let heightFeet  = txtHeihtInFt.text, heightFeet != "" , !heightFeet.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please select heightFeet")
        }
        saveData()
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
        } else if textField == txtExpirationDate {
            txtExpirationDate.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtExpirationClick), isDob: false, isTime: false)
        } else if textField == txtHeihtInFt {
            strPickerSelection = ""
            pickerHeightFeet.reloadAllComponents()
        } else if textField == txtHeihtInInch {
            strPickerSelection = "height"
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
            return self.arrFeet[row].PadLeft(totalWidth: 2, byString: "0")
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {}
    
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
            multiPart.append(image,withName: "file", fileName: "AddOperator.jpeg", mimeType: "image/jpeg")
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
        let month = "\(dictdata["dob_month"]?.intValue ?? 0)"
        let day = "\(dictdata["dob_day"]?.intValue ?? 0)"
        let monthExp = "\(dictdata["expiry_month"]?.intValue ?? 0)"
        let dayExp = "\(dictdata["expiry_day"]?.intValue ?? 0)"
        self.txtDateofBirth.text = "\(month.PadLeft(totalWidth: 2, byString: "0"))/\(day.PadLeft(totalWidth: 2, byString: "0"))/\(dictdata["dob_year"]?.intValue ?? 0)"

        self.txtExpirationDate.text = "\(monthExp.PadLeft(totalWidth: 2, byString: "0"))/\(dayExp.PadLeft(totalWidth: 2, byString: "0"))/\(dictdata["expiry_year"]?.intValue ?? 0)"
        self.txtLicenseNumber.text = dictdata["documentNumber"]?.string
}


    //MARK: - ImagePicker delegate
    
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true) { [weak self] in
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            self?.getImage = image
            if  self?.getImage.size.width != 0 {
                let imgData  = self?.getImage.jpegData(compressionQuality: 0.3)
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

    
}
