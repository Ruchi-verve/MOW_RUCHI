//
//  WelcomeVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 20/05/21.
//

import UIKit
import Alamofire


class WelcomeVC: SuperViewController,UITextFieldDelegate {

    //MARK:- outlets
    @IBOutlet weak var txtPhone:SkyFloatingLabelTextField!
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnCheck:UIButton!

    lazy var dicGenOtp = GenerateOTPModel()
    var passOTP = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Common.shared.setFloatlblTextField(placeHolder: "Cell Phone", textField: txtPhone)
        txtPhone.keyboardType = .numberPad
        txtPhone.isUserInteractionEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        txtPhone.text = ""
    }
    @IBAction func btnRetriveClick(_ sender: Any) {
        self.view.endEditing(true)
        let retrive = RetriveVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(retrive, animated: true)
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        self.view.endEditing(true)
        guard  let name  = txtPhone.text, name != "" , !name.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter Phone Number")
        }
        if !txtPhone.text!.isPhoneNumber  {
            return Utils.showMessage(type: .error,message: "Please enter valid Phone Number")
        }
        
        callApi(getValue: txtPhone.text!)
    }
    
    @IBAction func btnCheckUncheckClick(_ sender: Any) {
    btnCheck.isSelected = !btnCheck.isSelected
}

    @IBAction func btnRegisterClick(_ sender: Any) {
    self.view.endEditing(true)
    let retrive = RegisterVC.instantiate(fromAppStoryboard: .Login)
    self.navigationController?.pushViewController(retrive, animated: true)
    }
    
    @IBAction func btnHelpClick(_ sender: Any) {
        self.view.endEditing(true)
//        let retrive = HelpVC.instantiate(fromAppStoryboard: .Login)
//        self.navigationController?.pushViewController(retrive, animated: true)
        let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
        help.strIsComefrom = "help"
        self.navigationController?.pushViewController(help, animated: true)

    }
    
    //MARK:- Api Call
    func callApi(getValue:String) {
        let setFormat = String(format: "\"%@\"", getValue)
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Auth.loginEndpoint
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: setFormat) {[weak self] (dicResponseWithSuccess ,_)  in
                        if let weakSelf = self {
                            if  let jsonResponse = dicResponseWithSuccess {
                                guard jsonResponse.dictionary != nil else {
                                    return
                                }
                                print(jsonResponse.dictionary)
                                if let dicResponseData = jsonResponse.dictionary {
                                    weakSelf.dicGenOtp = GenerateOTPModel().initWithDictionary(dictionary: dicResponseData)
            
                                    if weakSelf.dicGenOtp.statuscode == "OK" {
                                        Utils.hideProgressHud()
                                        weakSelf.passOTP = weakSelf.dicGenOtp.otp
                                        
                                        let retrive = OTPVC.instantiate(fromAppStoryboard: .Login)
                                        retrive.isComeFrom = "login"
                                        retrive.getCellNo = getValue
                                        retrive.getOtp =  weakSelf.passOTP
                                        weakSelf.navigationController?.pushViewController(retrive, animated: true)
                                    } else {
                                            Utils.hideProgressHud()
                                            Utils.showMessage(type: .error, message: weakSelf.dicGenOtp.message)
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
    
    //MARK:- UITextfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let maxLength = 13
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
        textField.text =  Common.shared.formatPhoneLogin(txtPhone.text!)
            return newString.length <= maxLength

}
    
}
