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
class AddOccupantVC: SuperViewController,UITextViewDelegate,UITextFieldDelegate,CommonPickerViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,OnCloseClick{

    @IBOutlet weak var viewScan: UIView!
    @IBOutlet weak var lblSelection: UILabel!
    @IBOutlet weak var btnCheck:UIButton!
    @IBOutlet weak var conViewHeaderHeight:NSLayoutConstraint!
    @IBOutlet weak var viewHeader:UIView!
    @IBOutlet weak var txtFirstName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMiddleName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtHeihtInFt: SkyFloatingLabelTextField!
    @IBOutlet weak var txtHeihtInInch: SkyFloatingLabelTextField!
    @IBOutlet weak var txtWeight: SkyFloatingLabelTextField!


    var arrCountry = [String]()
    var toolBar = UIToolbar()
    var datePicker  = UIDatePicker()
    var isCome = String()
    var dictSamedata = [String:Any]()
    var dictDup  = [String:Any]()
    var index = Int()
    fileprivate let  pickerHeightFeet = CommonPicker()
    fileprivate let  pickerHeightInch = CommonPicker()
    
    var arrFeet = [String]()
    var arrInch = [String]()
    var getImage = UIImage()
    var strBase64:String = ""
    var traingView: TrainingVideo!
    var cardView: CardAgrement!
    var occupantId : Int = 0
    var operatorId : Int = 0
    var dictGetData = OccupantListModel()
    var dictPayer = OperatorListSubRes()
    var dictOpeInfo = OccupantListModel()
    //MARK:- View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
    }
    
    func SetUI(){
        Common.shared.addSkyTextfieldwithAssertick(to: txtFirstName, placeHolder: "First Name")
        Common.shared.setFloatlblTextField(placeHolder: "Middle Name", textField: txtMiddleName)
        Common.shared.addSkyTextfieldwithAssertick(to: txtLastName, placeHolder: "Last Name")
        Common.shared.setFloatlblTextField(placeHolder: "Middle Name", textField: txtMiddleName)
        Common.shared.addSkyTextfieldwithAssertick(to: txtWeight, placeHolder: "Weight(in lbs)")
        Common.shared.addSkyTextfieldwithAssertick(to: txtHeihtInFt, placeHolder: "Height(ft.)")
        Common.shared.addSkyTextfieldwithAssertick(to: txtHeihtInInch, placeHolder: "Height(in.)")

        txtWeight.keyboardType = .numberPad
        txtHeihtInFt.keyboardType = .numberPad
        txtHeihtInInch.keyboardType = .numberPad

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isCome == "Edit" {
            disPlayEditData()
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
    
    func disPlayEditData() {
        self.txtFirstName.text = dictGetData.firstName
        self.txtLastName.text = dictGetData.lastName
        self.txtMiddleName.text = dictGetData.middleName
        self.txtWeight.text =  "\(dictGetData.weight)"
        self.txtHeihtInFt.text = "\(dictGetData.heightFeet)"
        self.txtHeihtInInch.text = "\(dictGetData.heightInch)"
        if dictGetData.isDefault == true {
            btnCheck.isSelected = true
        }else {
            btnCheck.isSelected = false

        }
    }
    func displayNewData() {
        
        self.callgetDefaultOperator(opeid: operatorId)
    }
    
   func displaySameData() {
    let getFullName  = dictPayer.fullName.components(separatedBy: " ")
    self.txtFirstName.text = getFullName[0]

    if getFullName.count > 2 {
        self.txtLastName.text = getFullName[2]
        self.txtMiddleName.text = getFullName[1]
    } else {
        self.txtMiddleName.text = ""
        self.txtLastName.text = getFullName[1]

    }
    self.txtWeight.text =  "\(dictPayer.weight)"
    self.txtHeihtInFt.text = "\(dictPayer.heightFeet)"
    self.txtHeihtInInch.text = "\(dictPayer.heightInch)"
    }
    
    func clearData() {
        self.txtLastName.text = ""
        self.txtMiddleName.text = ""
        self.txtWeight.text = ""
        self.txtHeihtInFt.text = ""
        self.txtHeihtInInch.text = ""
        self.txtFirstName.text = ""
    }

    //MARK:- UIAction

    @IBAction func btnContinueClick(_ sender: Any) {
        self.view.endEditing(true)
        checkValidation()
    }
    
    @IBAction func btnHomeClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnInfoClick(_ sender: Any) {
        
        APP_DELEGATE.isComeFrom = "occupant"
        APP_DELEGATE.strtxtDisplay = dictOccupantOperatorInfo.defineOccupant
        traingView = TrainingVideo(frame: SCREEN_RECT)
        traingView.delegate = self
        self.view.addSubview(traingView)
        self.view.bringSubviewToFront(traingView)
    }

    @IBAction func btnCheckUncheckClick(_ sender: Any) {
        self.view.endEditing(true)
        btnCheck.isSelected = !btnCheck.isSelected
        if btnCheck.isSelected == true {
            if isCome == "reservation" {
                displayNewData()
            } else {
                displaySameData()
            }
        } else  {
            
            btnCheck.isSelected = false
            clearData()
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
//
        guard  let weight  = txtWeight.text, weight != "" , !weight.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter weight")
        }
        guard  let heightInch  = txtHeihtInInch.text, heightInch != "" , !heightInch.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please select heightInch")
        }

        guard  let heightFeet  = txtHeihtInFt.text, heightFeet != "" , !heightFeet.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please select heightFeet")
        }
        callApiforAddOccupant()
    }
    
    
    //MARK:- UItextfield Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == txtHeihtInFt {
            pickerHeightFeet.reloadAllComponents()
        }
        if textField == txtHeihtInInch {
            pickerHeightInch.reloadAllComponents()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView == pickerHeightInch {
                txtHeihtInInch.text = self.arrInch[row].PadLeft(totalWidth: 2, byString: "0")

            } else {
                txtHeihtInFt.text = self.arrFeet[row].PadLeft(totalWidth: 2, byString: "0")

            }

        }

//MARK:- Api Call
    
    func callgetDefaultOperator(opeid:Int){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.getOperatorByID
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(opeid)") { (dicResponseWithSuccess ,_)  in
        if  let jsonResponse = dicResponseWithSuccess {
            guard jsonResponse.dictionary != nil else {
                return
            }
            if let dicResponseData = jsonResponse.dictionary {
                
                if dicResponseData["StatusCode"]?.stringValue == "OK" {
                    
                    self.dictOpeInfo  = OccupantListModel().initWithDictionary(dictionary: dicResponseData)
                    self.txtFirstName.text = self.dictOpeInfo.firstName.uppercased()
                    self.txtLastName.text = self.dictOpeInfo.lastName.uppercased()
                    self.txtMiddleName.text = self.dictOpeInfo.middleName.uppercased()
                    self.txtHeihtInFt.text =  "\(self.dictOpeInfo.heightFeet)"
                            self.txtHeihtInInch.text =  "\(self.dictOpeInfo.heightInch)"
                            self.txtWeight.text =  "\(self.dictOpeInfo.weight)"

                    Utils.hideProgressHud()
                    
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
    
    func callApiforAddOccupant() {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.addOccupant
    
        var  param1 = [
                       "Notes":dictGetData.notes,
                     "FirstName":txtFirstName.text!,
                     "MiddleName":txtMiddleName.text!,
                     "LastName":txtLastName.text!,
                     "HeightFeet":Int(txtHeihtInFt.text!)!,
                    "HeightInch":Int(txtHeihtInInch.text!)!,
                    "Weight":Int(txtWeight.text!)!,
                    "isDefault":btnCheck.isSelected ? true : false,
                    "OperatorID":operatorId] as [String : Any]

        if isCome == "reservation" {
            param1["ID"] = 0
        } else {
            param1["ID"] = dictGetData.iD
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
