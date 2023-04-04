//
//  RetriveVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 24/05/21.
//

import UIKit

class RetriveVC: SuperViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var txtEmail:SkyFloatingLabelTextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.keyboardType = .emailAddress
        Common.shared.setFloatlblTextField(placeHolder: "Enter Email Address", textField: txtEmail)

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        txtEmail.text = ""
    }
    @IBAction func btnRetriveClick(_ sender: Any) {
        self.view.endEditing(true)
        guard  let email  = txtEmail.text, email != "" , !email.isEmpty else {
           return  Utils.showMessage(type: .error,message: "Please enter email address")
        }
        if !Common.shared.isValidEmail(testStr: txtEmail.text!)  {
            return Utils.showMessage(type: .error,message: "Please enter valid email address")
        }
        callApi()
    }
    
    @IBAction func btnLoginClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnHelpClick(_ sender: Any) {
        self.view.endEditing(true)
        let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
        help.strIsComefrom = "help"
        self.navigationController?.pushViewController(help, animated: true)
    }
    
    @IBAction func btnRegisterClick(_ sender: Any) {
        self.view.endEditing(true)
        let retrive = RegisterVC.instantiate(fromAppStoryboard: .Login)
        self.navigationController?.pushViewController(retrive, animated: true)
    }
    
    func createAlertView(strMsg:String) {
        let refreshAlert = UIAlertController(title: "Alert", message: strMsg, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewController(animated: true)
        }))

        present(refreshAlert, animated: true, completion: nil)

    }
    
    
    //MARK:- Api Call
    func callApi() {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Auth.retriveUser
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: String(format: "\"%@\"", self.txtEmail.text!)) {(dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {
                            Utils.hideProgressHud()
//                            Utils.showMessage(type: .success, message: dicResponseData["Message"]?.stringValue ?? "")
                            self.createAlertView(strMsg: dicResponseData["Message"]?.stringValue ?? "")
                        } else {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message: dicResponseData["Message"]?.stringValue ?? "")
                        }
                    }
                }else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                }

        }

        

    }
    
}
