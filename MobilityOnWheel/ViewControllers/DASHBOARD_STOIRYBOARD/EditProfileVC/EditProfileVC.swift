//
//  EditProfileVC.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 03/08/21.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData
import AVFoundation

class EditProfileVC: SuperViewController,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CommonPickerViewDelegate {

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


    @IBOutlet weak var txtViewNote: UITextView!
    @IBOutlet weak var tblOperatorList: UITableView!
    @IBOutlet weak var contblHeight: NSLayoutConstraint!
    @IBOutlet weak var imgDropDown: UIImageView!
    @IBOutlet weak var viewScan: UIView!
    @IBOutlet weak var btnScan: UIButton!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnCart: AddBadgeToButton!
    @IBOutlet weak var btnNotification: AddBadgeToButton!

    
    var arrList = [OperatorListSubRes]()
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var arrCountry = [String]()
    var picker = UIPickerView()
    var dictAddress = CustomerAdressModel()
    var getImage = UIImage()
    var dictgetScannerRes = [String:JSON]()
    var arrState = [StateSubListModel]()
    
    fileprivate let pickerState = CommonPicker()
    fileprivate let pickerContry = CommonPicker()

    var dataSource:GenericDataSource<OperatorListSubRes>!
    var index:Int = -1
    var getStateId = Int()
    var strBase64:String = ""
    var saveDictOperRes = OperatorListSubRes()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblOperatorList.rowHeight = UITableView.automaticDimension
        tblOperatorList.estimatedRowHeight = 70
        
    }
    
    func SetUI(){
        Common.shared.checkCartCount(btnCart)
        btnMenu.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: .touchUpInside)
        Common.shared.addSkyTextfieldwithAssertick(to: txtFirstName, placeHolder: "First Name")
        Common.shared.setFloatlblTextField(placeHolder:"Middle Name", textField: txtMiddleName)
        Common.shared.addSkyTextfieldwithAssertick(to: txtLastName, placeHolder: "Last Name")
        Common.shared.addSkyTextfieldwithAssertick(to: txtSelectCountry, placeHolder: "Select Country")
        Common.shared.addSkyTextfieldwithAssertick(to: txtStreetAddress, placeHolder: "Street Address")
        Common.shared.setFloatlblTextField(placeHolder: "Appartment,suit,unit,etc", textField: txtAppartment)
        Common.shared.addSkyTextfieldwithAssertick(to: txtTownCity, placeHolder: "Town/City")
        Common.shared.addSkyTextfieldwithAssertick(to: txtState, placeHolder: "State")
        Common.shared.addSkyTextfieldwithAssertick(to: txtZip, placeHolder: "Zip")
        Common.shared.addSkyTextfieldwithAssertick(to: txtCellNumber, placeHolder: "Cell Number")
        Common.shared.setFloatlblTextField(placeHolder: "Home Number", textField: txtHomeNumber)
        Common.shared.addSkyTextfieldwithAssertick(to: txtEmail, placeHolder: "Email")
        Common.shared.setFloatlblTextField(placeHolder: "License Number", textField: txtLicenseNumber)
        Common.shared.setFloatlblTextField(placeHolder: "Expiration Date", textField: txtExpirationDate)
        Common.shared.setFloatlblTextField(placeHolder: "Date of Birth", textField: txtDateofBirth)
        let text = "Scan Front of Payor's ID now *"
        let range = (text as NSString).range(of: "*")
        let attributedString = NSMutableAttributedString(string:text)
        attributedString.addAttributes([.foregroundColor : UIColor.red,.baselineOffset:3], range: range)
        btnScan.setAttributedTitle(attributedString, for: .normal)
        txtViewNote.isHidden  = true
        txtViewNote.text = "Note".uppercased()
        txtViewNote.textColor = UIColor.lightGray
        txtViewNote.layer.cornerRadius = 8
        txtViewNote.layer.borderColor = AppConstants.kBorder_Color.cgColor
        txtViewNote.layer.borderWidth = 0.8
        txtViewNote.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

        txtCellNumber.keyboardType = .numberPad
        txtZip.keyboardType = .numberPad
        txtHomeNumber.keyboardType = .numberPad
        txtEmail.keyboardType = .emailAddress
        txtLicenseNumber.keyboardType = .default
        
        tblOperatorList.register(UINib(nibName: "OperatorListCell", bundle: nil), forCellReuseIdentifier: "OperatorListCell")
        
        arrCountry = ["USA","Other"]
        arrState = APP_DELEGATE.arrGetState
        pickerState.delegate = self
        pickerState.dataSource = self
        self.pickerState.toolbarDelegate = self

        pickerContry.delegate = self
        pickerContry.dataSource = self
        self.pickerContry.toolbarDelegate = self

        txtState.inputView = pickerState
        txtState.inputAccessoryView = self.pickerState.toolbar
        self.pickerState.selectRow(0, inComponent: 0, animated: false)
        
        txtSelectCountry.inputView = pickerContry
        txtSelectCountry.inputAccessoryView = self.pickerContry.toolbar
        self.pickerContry.selectRow(0, inComponent: 0, animated: false)

        self.txtFirstName.textColor  = UIColor.lightGray
        self.txtLastName.textColor  = UIColor.lightGray
        self.txtMiddleName.textColor  = UIColor.lightGray

        self.txtFirstName.isUserInteractionEnabled  = false
        self.txtLastName.isUserInteractionEnabled  = false
        self.txtMiddleName.isUserInteractionEnabled  = false

        viewScan.roundedViewCorner(radius: 8)
      //  checkPayorDataExpired()
        checkValidateLicense()
        CommonApi.callgetScannerApiKey(completionHandler: {(getStrVal) in
            if getStrVal != "" { APP_DELEGATE.scanerKey  =  getStrVal
                self.callGetProfileData()

            } else {
                APP_DELEGATE.scanerKey  = ""
                self.callGetProfileData()
            }
        }, controll: self)
        
        CommonApi.callNotificationBadgeInfo(completionHandler: {success in
            if success == true {
                Common.shared.addBadgetoButton(self.btnNotification,"\(NotificationBadge)", "icon_notification")
        
                Utils.hideProgressHud()
            }
        })
    
    }
    func checkPayorDataExpired() {
        if APP_DELEGATE.saveDictLicenseRes["IsLicenseAvailableForPayor"]?.boolValue ==  false {
            createAlertView(strMsg: "Please scan a Valid Payor ID")
        } else if APP_DELEGATE.saveDictLicenseRes["IsValidLicenseForPayor"]?.boolValue ==  false {
            createAlertView(strMsg: "Payor license expired")
        } else {
            checkOperatorExpired()
            print("Nothing to check")
        }
    }
    
    func checkOperatorExpired() {
            for i in 0..<arrList.count {
                let dict = arrList[i]
                if arrNotUploadLicense.count > 0 {
                    if arrNotUploadLicense.contains(dict.operatorID) {
                        saveDictOperRes  = dict
                        createAlertView(strMsg: "Please scan an Operator  \(dict.firstName + " " + dict.lastName) Valid ID.")
                        return
                    } else {
                        print("Nothing to do")
                    }

                }
                    if arrExpiredicense.contains(dict.operatorID) {
                        saveDictOperRes  = dict
                        createAlertView(strMsg: "\(dict.firstName + " " + dict.lastName) license expired")
                        return
                    } else {
                        print("Nothing to do")
                    }

                }
    }
    
    func createAlertView(strMsg:String) {
        let refreshAlert = UIAlertController(title: "Alert", message: strMsg, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            if APP_DELEGATE.saveDictLicenseRes["IsValidLicenseForPayor"]?.boolValue ==  false {
            } else {
                let retrive = AddEditOperatorVC.instantiate(fromAppStoryboard: .DashBoard)
                retrive.isCome = "Edit"
                retrive.dictSamedata = self.saveDictOperRes
                retrive.dictNewData = dictGetProfileData
                self.navigationController?.pushViewController(retrive, animated: true)
            }
        }))
        if arrExpiredicense.count > 0 || arrNotUploadLicense.count > 0 {
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style:.default, handler: nil))
        }else {}

        present(refreshAlert, animated: true, completion: nil)

    }

    func callGetProfileData() {
        CommonApi.callGetCustomerProfile(completionHandler: {(success) in
            if success == true {
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
                    self.txtCellNumber.text = self.dictAddress.cellNo
                    self.txtHomeNumber.text = self.dictAddress.homeNo
                    self.txtEmail.text = self.dictAddress.email
                    self.txtLicenseNumber.text = self.dictAddress.licenseNo
                    self.getStateId = self.dictAddress.billStateId
                    if self.dictAddress.expDate != ""  {
                        let strArr = self.dictAddress.expDate.components(separatedBy: " ")
                        self.txtExpirationDate.text = Common.shared.changeDateFormat(strDate: strArr[0])
                    } else  {
                        self.txtExpirationDate.text = ""
                    }
                    if self.dictAddress.dob != ""  {
                        let strDobArr = self.dictAddress.dob.components(separatedBy: " ")
                        self.txtDateofBirth.text = Common.shared.changeDateFormat(strDate: strDobArr[0])

                    } else  {
                        self.txtDateofBirth.text = ""
                    }

                    self.txtViewNote.text = self.dictAddress.notes
                    if self.txtViewNote.text == ""  {
                        self.txtViewNote.text = "Note".uppercased()
                        self.txtViewNote.textColor = UIColor.lightGray
                    } else {
                        self.txtViewNote.textColor = UIColor.black
                    }
                    CommonApi.callOperatorListApi (completionHandler: { [self] success in
                        self.arrList.removeAll()
                        self.arrList = APP_DELEGATE.arrOperatorList
                        self.updateTableViewData()
                        DispatchQueue.main.async {
                            self.tblOperatorList.layoutIfNeeded()
                            self.tblOperatorList.updateConstraintsIfNeeded()
                        }
                    }, con: self)
                   
                    
                }
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
            }
        }, controll: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SetUI()
    }
    
    //MARK: -UIAction

    func checkValidateLicense(){
        APP_DELEGATE.validateLicenseApi(completionHandler: {success in
             if success ==  true {} else {
                 self.checkPayorDataExpired()
             }
         })
    }
    func didTapDone() {
        self.view.endEditing(true)
    }

    @IBAction func btnSaveChangesClick(_ sender: Any) {
        self.view.endEditing(true)
        checkValidation()
    }
    
    @IBAction func btnNotificationClick(_ sender: Any) {
        self.view.endEditing(true)
        let loginScene = NotificationVC.instantiate(fromAppStoryboard: .DashBoard)
        self.navigationController?.pushViewController(loginScene, animated: true)
    }

    @IBAction func btnScannerClick(_ sender: Any) {
        self.view.endEditing(true)
        checkCameraAccess()
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .camera;
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
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
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .overCurrentContext
            self.present(imagePicker, animated: true, completion: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    DispatchQueue.main.async {
                        let imagePicker = UIImagePickerController()
                        imagePicker.delegate = self
                        imagePicker.sourceType = .camera;
                        imagePicker.allowsEditing = true
                        imagePicker.modalPresentationStyle = .overCurrentContext
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
        
    }

    @IBAction func btnAddClick(_ sender: Any) {
        let retrive = AddEditOperatorVC.instantiate(fromAppStoryboard: .DashBoard)
        retrive.dictNewData = dictGetProfileData
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
        guard  let cellNo  = txtCellNumber.text, cellNo != "" , !cellNo.isEmpty else{
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
        callEditCustomerProfile()
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
        self.view.endEditing(true)

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
        }
        
        else if textField == txtExpirationDate {
            txtExpirationDate.addInputViewDatePicker(target: self, selector: #selector(onDoneTxtExpirationClick), isDob: false, isTime: false)
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
        
        else if  textField == txtZip{
            let maxLength = 12
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength

        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtDateofBirth.resignFirstResponder()
        txtState.endEditing(true)
        txtSelectCountry.endEditing(true)
    }

    //MARK: - UITextView Delegate
    
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
        }         else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
        else {
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
    
    //MARK: - UITableview Method


    func updateTableViewData() {
        dataSource = .init(models: self.arrList, reuseIdentifier: OperatorListID, cellConfigurator: { [self] (model, cell) in
            let cel:OperatorListCell = cell as! OperatorListCell
            cel.lblOperatorName.text! = String(format: "%@ %@", model.firstName,model.lastName )
            cel.lblOperatorEmail.text! = model.emailId
            cel.lblOpertatorContact.text! = "Cell:\(model.operatorCellNumber)"
            if model.isDefault == true {
                cel.contentView.backgroundColor = UIColor(red: 191/255, green: 252/255, blue: 91/255, alpha: 1)
            }else {
                cel.contentView.backgroundColor = UIColor.clear
            }
            cel.btnEdit.tag = cell.tag
            cel.btnOccupant.tag = cell.tag
            cel.btnEdit.addTarget(self, action: #selector(self.btnEditTapp(_:)), for: .touchUpInside)
            cel.btnOccupant.addTarget(self, action: #selector(self.btnOccuTapp(_:)), for: .touchUpInside)
        },itemClick: { (model, indexpath, cell) in
            //self.index = indexpath.row
        })
        tblOperatorList.dataSource = dataSource
        tblOperatorList.delegate = dataSource
        DispatchQueue.main.async {
            self.tblOperatorList.reloadData()
            self.contblHeight.constant =  CGFloat(self.arrList.count) * self.tblOperatorList.estimatedRowHeight + 50
        }
    }
     
    //MARK:- Cell Function
    
    @objc func btnEditTapp(_ sender:UIButton) {
        let retrive = AddEditOperatorVC.instantiate(fromAppStoryboard: .DashBoard)
        retrive.isCome = "Edit"
        retrive.index = sender.tag
        retrive.dictSamedata = arrList[sender.tag]
        retrive.dictSamedata.notes = txtViewNote.text!
        retrive.dictNewData = dictGetProfileData
        self.navigationController?.pushViewController(retrive, animated: true)

    }
    
    @objc func btnOccuTapp(_ sender:UIButton) {
        let retrive:ManageOccupantVC = ManageOccupantVC.instantiate(fromAppStoryboard: .DashBoard)
        retrive.strIsCome = "Occupant"
        retrive.customerId = arrList[sender.tag].operatorID
        retrive.dictPayor = arrList[sender.tag]
        retrive.dictPayor.notes = txtViewNote.text!
        retrive.OccuId = arrList[sender.tag].occupantID
        self.navigationController?.pushViewController(retrive, animated: true)
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
        
        var param1 = [
                      "ID":getUId,
                      "DOB":txtDateofBirth.text!,
                      "ExpiryDate":txtExpirationDate.text!,
                      "LicenseNo":txtLicenseNumber.text!,
                      "Notes":"", //txtViewNote.text!
                     "FirstName":txtFirstName.text!,
                     "MiddleName":txtMiddleName.text!,
                     "LastName":txtLastName.text!,
                      "Email":txtEmail.text!.uppercased(),
                     "CellNumber":txtCellNumber.text!,
                     "HomeNumber":txtHomeNumber.text!,
                    "BillCity":txtTownCity.text!,
                    "BillAddress1":txtStreetAddress.text!,
                    "BillAddress2":txtAppartment.text!,
                    "Country":txtSelectCountry.text!,
                    "BillZip":txtZip.text!,
                    "OtherBillStateName":txtSelectCountry.text == "USA" ? "" : txtState.text!,
                     "BillStateID":txtSelectCountry.text == "USA" ? getStateId : 0,
        ] as [String : Any]
        
            if getImage.size.width != 0 {
                param1["FileContent"] = strBase64
                param1["FileName"] =  "EditProfile.jpeg"
                param1["MimeType"]  =  "image/jpeg"
            }

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
                            if APP_DELEGATE.saveDictLicenseRes.isEmpty == false {
                                APP_DELEGATE.validateLicenseApi(completionHandler: {success in
                                    if success ==  true {} else {
                                        self.checkPayorDataExpired()
                                    }
                                })
                            }
                            Utils.showMessage(type: .success, message:"Update profile successfully")
                            
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
            multiPart.append(image,withName: "file", fileName: "EditProfile.jpeg", mimeType: "image/jpeg")
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
        self.txtSelectCountry.text = dictdata["nationality_full"]?.string
        self.txtStreetAddress.text = dictdata["address1"]?.string
        let arrSep =  dictdata["address2"]?.string?.uppercased().components(separatedBy: ",")
    
        self.txtTownCity.text = arrSep?.count == 0 ?   ""  :  arrSep?[0]
        let month = "\(dictdata["dob_month"]?.intValue ?? 0)"
        let day = "\(dictdata["dob_day"]?.intValue ?? 0)"
        let monthExp = "\(dictdata["expiry_month"]?.intValue ?? 0)"
        let dayExp = "\(dictdata["expiry_day"]?.intValue ?? 0)"
        self.txtDateofBirth.text = "\(month.PadLeft(totalWidth: 2, byString: "0"))/\(day.PadLeft(totalWidth: 2, byString: "0"))/\(dictdata["dob_year"]?.intValue ?? 0)"
        self.txtExpirationDate.text = "\(monthExp.PadLeft(totalWidth: 2, byString: "0"))/\(dayExp.PadLeft(totalWidth: 2, byString: "0"))/\(dictdata["expiry_year"]?.intValue ?? 0)"
        self.txtZip.text = dictdata["postcode"]?.string
        self.txtLicenseNumber.text = dictdata["documentNumber"]?.string
        self.txtState.text = dictdata["issuerOrg_region_full"]?.string
}

}

class invalideLicense : NSObject {

    var opertorId: Int? = 0
    var isUdpdtaeOperator: Bool? = true

}

