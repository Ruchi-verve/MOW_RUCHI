//
//  AddCardVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit
import Alamofire

class AddCardVC: SuperViewController,UITextViewDelegate,UITextFieldDelegate,CommonPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    

    @IBOutlet weak var txtCardNo: SkyFloatingLabelTextField!
    @IBOutlet weak var txtExpiration: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCVV: SkyFloatingLabelTextField!
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
    @IBOutlet weak var txtExpireyear: SkyFloatingLabelTextField!
    @IBOutlet weak var txtCreditCardType: SkyFloatingLabelTextField!

    @IBOutlet weak var lblUsername: UILabel!

    @IBOutlet weak var btnPaymentMethod: UIButton!
    @IBOutlet weak var btnReturnReservation: UIButton!
    @IBOutlet weak var btnCheckPayor: UIButton!

    
    fileprivate let pickerState = CommonPicker()
    fileprivate let pickerYear = CommonPicker()
    fileprivate let pickerMonth = CommonPicker()
    fileprivate let pickerCardType = CommonPicker()

    var arrState = [StateSubListModel]()
    var arrYear = [String]()
    var arrMonth = [String]()
    var getStateId = Int()
    var dictRes = AddCardModel()
    var arrCreditcardType = [String]()
    var getCardId :Int = 0
    var dictProfile = CustomerAdressModel()
    var strPickerTapp = String()
    var monthNo = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrCreditcardType  = CardType.allCases.map{ $0.rawValue }   

        Common.shared.addSkyTextfieldwithAssertick(to: txtCardNo, placeHolder: "Card Number")
        Common.shared.addSkyTextfieldwithAssertick(to: txtCVV, placeHolder: "CVV")
        Common.shared.addSkyTextfieldwithAssertick(to: txtExpiration, placeHolder: "Expiration Month")
        Common.shared.addSkyTextfieldwithAssertick(to: txtCreditCardType, placeHolder: "Credit Card Type")
        Common.shared.setFloatlblTextField(placeHolder: "First Name", textField: txtFirstName)
        Common.shared.setFloatlblTextField(placeHolder: "Middle Name", textField: txtMiddleName)
        Common.shared.setFloatlblTextField(placeHolder: "Last Name", textField: txtLastName)
        Common.shared.setFloatlblTextField(placeHolder: "Select Country", textField: txtSelectCountry)
        Common.shared.setFloatlblTextField(placeHolder: "Street Address", textField: txtStreetAddress)
        Common.shared.setFloatlblTextField(placeHolder:"Appartment,suit,unit,etc", textField: txtAppartment)
        Common.shared.setFloatlblTextField(placeHolder: "Town/City", textField: txtTownCity)
        Common.shared.setFloatlblTextField(placeHolder: "State", textField: txtState)
        Common.shared.setFloatlblTextField(placeHolder: "Zip", textField: txtZip)
        Common.shared.setFloatlblTextField(placeHolder: "Cell Number", textField: txtCellNumber)
        Common.shared.setFloatlblTextField(placeHolder: "Phone(XXX)-XXX-XXXX", textField: txtHomeNumber)
        Common.shared.addSkyTextfieldwithAssertick(to: txtExpireyear, placeHolder: "Expiration Year")
        Common.shared.setFloatlblTextField(placeHolder: "Home Number", textField:txtHomeNumber )
        Common.shared.setFloatlblTextField(placeHolder:"Email", textField: txtEmail)


        arrState = APP_DELEGATE.arrGetState
        
        pickerState.delegate = self
        pickerState.dataSource = self
        pickerState.tag = 1
        self.pickerState.toolbarDelegate = self
        
        pickerYear.delegate = self
        pickerYear.dataSource = self
        pickerYear.tag = 2
        self.pickerYear.toolbarDelegate = self

        pickerMonth.delegate = self
        pickerMonth.dataSource = self
        pickerMonth.tag = 3
        self.pickerMonth.toolbarDelegate = self
        
        pickerCardType.delegate = self
        pickerCardType.dataSource = self
        pickerCardType.tag = 4
        self.pickerCardType.toolbarDelegate = self

        self.txtState.inputView = self.pickerState
        self.txtState.inputAccessoryView = self.pickerState.toolbar

        self.txtCreditCardType.inputView = self.pickerCardType
        self.txtCreditCardType.inputAccessoryView = self.pickerCardType.toolbar

//        let getName = USER_DEFAULTS.value(forKey: AppConstants.FIRST_NAME) as? String ??  "Steve"
//        lblUsername.text = AppConstants.setHi + getName.capitalized

        self.txtExpireyear.inputView = self.pickerYear
        self.txtExpireyear.inputAccessoryView = self.pickerYear.toolbar

        self.txtExpiration.inputView = self.pickerMonth
        self.txtExpiration.inputAccessoryView = self.pickerMonth.toolbar

        self.txtCellNumber.keyboardType = .phonePad
        self.txtHomeNumber.keyboardType = .phonePad
        self.txtEmail.keyboardType = .emailAddress
        self.txtZip.keyboardType = .phonePad
        self.txtCVV.keyboardType = .numberPad
        
        self.txtFirstName.textColor = UIColor.lightGray
        self.txtMiddleName.textColor = UIColor.lightGray
        self.txtLastName.textColor = UIColor.lightGray

//        for i in 0..<12{
//            arrMonth.append("\(i)")
//        }
       arrMonth = Calendar.current.shortMonthSymbols
        //arrMonth.append(monthComponents)
        
        let GetCurrentYear:Int = Int(Date().string(format:"yyyy")) ?? 0
        for i in 0..<20 {
            arrYear.append("\(GetCurrentYear+i)")
        }
        callGetProfileData()
    }
    //MARK:- UITextField Delegate
    func didTapDone() {
        
        if strPickerTapp == "year" {
            let getSelectedYear = pickerYear.selectedRow(inComponent: 0)
            self.txtExpireyear.text = self.arrYear[getSelectedYear]
        }

        if strPickerTapp == "expiry" {
            let getSelectedMonth = pickerMonth.selectedRow(inComponent: 0)
            txtExpiration.text =  self.arrMonth[getSelectedMonth]
        }
        
        if strPickerTapp == "creditCard" {
            let getSelectedRow  = pickerCardType.selectedRow(inComponent: 0)
            if txtCreditCardType.text != self.arrCreditcardType[getSelectedRow] {
                self.txtCardNo.text = ""
                self.txtCVV.text = ""
            }
            self.txtCreditCardType.text = self.arrCreditcardType[getSelectedRow]
            getCardId = getSelectedRow
        }
        
        if strPickerTapp == "state" {
            let getSelectedState = pickerState.selectedRow(inComponent: 0)
                txtState.text = self.arrState[getSelectedState].stateName
               getStateId = self.arrState[getSelectedState].id
        }
        self.view.endEditing(true)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtExpireyear {
            strPickerTapp = "year"
            pickerYear.reloadAllComponents()
        }
        
        else if textField == txtExpiration {
            strPickerTapp = "expiry"
            pickerMonth.reloadAllComponents()
        }
        
        else if textField == txtState {
            strPickerTapp = "state"
            pickerState.reloadAllComponents()
        }
        
        else if textField == txtCreditCardType {
            strPickerTapp = "creditCard"
            pickerCardType.reloadAllComponents()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtCardNo {
            if txtCreditCardType.text! == CardType.Visa.rawValue || txtCreditCardType.text! == CardType.MasterCard.rawValue || txtCreditCardType.text! == CardType.Discover.rawValue{
                let maxLength = 16
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                //Common.shared.reformatAsCardNumber(textField: txtCardNo)
                return newString.length <= maxLength
            } else  {
                    let maxLength = 15
                    let currentString: NSString = (textField.text ?? "") as NSString
                    let newString: NSString =
                        currentString.replacingCharacters(in: range, with: string) as NSString
                    //Common.shared.reformatAsCardNumber(textField: txtCardNo)
                    return newString.length <= maxLength
            }
        } else  if  textField == txtCVV {
            if txtCreditCardType.text! == CardType.Visa.rawValue || txtCreditCardType.text! == CardType.MasterCard.rawValue || txtCreditCardType.text! == CardType.Discover.rawValue {
                let maxLength = 3
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            } else {
                let maxLength = 4
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            }
        } else if textField == txtCellNumber ||  textField == txtHomeNumber {
            let maxLength = 13
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            textField.text =  Common.shared.formatPhoneLogin(textField.text!)
            return newString.length <= maxLength
        }
        return true
    }
    //MARK:- Picker Controller
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == pickerYear {
                return self.arrYear.count
            } else if pickerView == pickerMonth {
                return self.arrMonth.count
            } else if pickerView == pickerCardType {
                return self.arrCreditcardType.count
            }
            return self.arrState.count
        }
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
                return 1
        }
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == pickerYear {
                return self.arrYear[row]
            } else if pickerView == pickerMonth {
                return self.arrMonth[row]
            } else if pickerView == pickerCardType {
                return self.arrCreditcardType[row]
            }
            return self.arrState[row].stateName
        }
        
    //MARK:- SetFunctions For Validation
    func checkValidation(){
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
             return Utils.showMessage(type: .error,message: "Please enter valid email")
        }
        
        guard  let cardno  = txtCardNo.text, cardno != "" , !cardno.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter card no")
        }
                
        guard  let expi  = txtExpireyear.text, expi != "" , !expi.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please select expiration year")
        }
        
        guard  let expimonth  = txtExpiration.text, expimonth != "" , !expimonth.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please select expiration month")
        }

        guard  let cvv  = txtCVV.text, cvv != "" , !cvv.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter cvv no")
        }
        callApi()
}
    
    //MARK:- UIACtion
    @IBAction func btnPaymentMethodClick(_ sender:UIButton) {
        checkValidation()
    }
    
    @IBAction func btnReturnReservation(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnCheckPayorClick(_ sender:UIButton) {
        btnCheckPayor.isSelected = !btnCheckPayor.isSelected
    }
    
    func checkCardNoValidation() -> Bool{
        
        if txtCreditCardType.text == CardType.Visa.rawValue {
            if !CreditCardValidator(txtCardNo.text!).isValid(for:.visa) {
                 Utils.showMessage(type: .error,  message: "Credit Card Number should be 4XXXXXXXXXXXX or 4XXXXXXXXXXXXXXX format!")
                return false
            }
        } else if  txtCreditCardType.text == CardType.MasterCard.rawValue {
            if !CreditCardValidator(txtCardNo.text!).isValid(for:.masterCard) {
                 Utils.showMessage(type: .error,  message: "Credit Card Number should be 51XXXXXXXXXXXXXX to 55XXXXXXXXXXXXXX format!")
                return false

            }
        } else if  txtCreditCardType.text == CardType.AmericanExpress.rawValue {
            if !CreditCardValidator(txtCardNo.text!).isValid(for:.americanExpress) {
                Utils.showMessage(type: .error,  message: "Card Number should be 34XXXXXXXXXXX or 37XXXXXXXXXXX format!")
                return false

            }
        } else if  txtCreditCardType.text == CardType.Discover.rawValue {
            if !CreditCardValidator(txtCardNo.text!).isValid(for:.discover) {
                 Utils.showMessage(type: .error,  message: "Credit Card Number should be 6011XXXXXXXXXXXX or 65XXXXXXXXXXXXXX format!")
                return false
            }
        }
        return true
    }
    
    
    //MARK:- Call Api
    func callApi() {

        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Card.addCard
        let getUId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        let getStrCard = txtCardNo.text?.components(separatedBy: " ").joined()
        let passParam = ["CardTypeID":(getCardId + 1),
                        "CustomerID":getUId,
                     "FirstName":txtFirstName.text!,
                     "MiddleName":txtMiddleName.text!,
                     "LastName":txtLastName.text!,
                     "Email":txtEmail.text!,
                     "Phone":txtCellNumber.text!,
                     "City":txtTownCity.text!,
                     "Zip":txtZip.text!,
                     "State":txtState.text!,
                     "StateID":getStateId,
                     "Country":"USA",
                     "CreditCardNumber":getStrCard!,
                     "CSV":txtCVV.text!,
                     "address1":txtStreetAddress.text!,
                     "address2":txtAppartment.text!,
                     "ExpYear":txtExpireyear.text!,
                     "ExpMonth":"\(pickerMonth.selectedRow(inComponent: 0) + 1) "] as [String : Any]
        
        let gettoken  = USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? ""
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":gettoken,"DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }

        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:passParam, httpMethodForGetOrPost: .post, setheaders: header) {[weak self] (dicResponseWithSuccess ,_)  in
            if let weakSelf = self {
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        weakSelf.dictRes = AddCardModel().initWithDictionary(dictionary: dicResponseData)
                        if weakSelf.dictRes.statusCode == "OK" {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .success, message:weakSelf.dictRes.message)
                            weakSelf.navigationController?.popViewController(animated: true)
                            } else {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message:weakSelf.dictRes.errorMessage)
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
    
    func callGetProfileData() {
        CommonApi.callGetCustomerProfile(completionHandler: {(success) in
            if success == true {
                Utils.hideProgressHud()
                self.dictProfile = dictGetProfileData
                if self.dictProfile.statusCode == "OK" {
                    self.txtFirstName.text =                         self.dictProfile.firstName
                    self.txtMiddleName.text = self.dictProfile.middleName
                    self.txtLastName.text = self.dictProfile.lastName
                    self.txtSelectCountry.text = self.dictProfile.country
                    self.txtStreetAddress.text = self.dictProfile.billAddress1
                    self.txtAppartment.text = self.dictProfile.billAddress2
                    self.txtTownCity.text = self.dictProfile.billCity
                    self.txtState.text = self.dictProfile.stateName
                    self.txtZip.text = self.dictProfile.billZip
                    self.txtCellNumber.text = self.dictProfile.cellNo
                    self.txtHomeNumber.text = self.dictProfile.homeNo
                    self.txtEmail.text = self.dictProfile.email
                    self.getStateId = self.dictProfile.billStateId
                    self.txtFirstName.isUserInteractionEnabled = false
                    self.txtMiddleName.isUserInteractionEnabled = false
                    self.txtLastName.isUserInteractionEnabled = false
                }
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
            }
        }, controll: self)
    }
    
}
