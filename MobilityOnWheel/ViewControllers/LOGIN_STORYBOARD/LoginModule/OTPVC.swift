//
//  OTPVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 24/05/21.
//

import UIKit
import Alamofire

class OTPVC: SuperViewController,UITextFieldDelegate {

    //MARK:-Outelets
    
    @IBOutlet weak var txt1Digit:SkyFloatingLabelTextField!
    @IBOutlet weak var txt2Digit:SkyFloatingLabelTextField!
    @IBOutlet weak var txt3Digit:SkyFloatingLabelTextField!
    @IBOutlet weak var txt4Digit:SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnResendCode:UIButton!
    @IBOutlet weak var btnSubmit:UIButton!
    @IBOutlet weak var lbldisplayTimer:UILabel!
    @IBOutlet weak var viewResend:UIView!
    @IBOutlet weak var conViewRessendHeight:NSLayoutConstraint!

    var count = 300  // 60sec if you want
    var resendTimer = Timer()
    var txtTemp: UITextField!
    var isComeFrom:String = ""
    var getOtp:String = ""
    var getCellNo = String()
    lazy var dictVerifyOtpRes = VerifyOtpModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI() {
        txt1Digit.keyboardType = UIKeyboardType.numberPad
        txt2Digit.keyboardType = UIKeyboardType.numberPad
        txt3Digit.keyboardType = UIKeyboardType.numberPad
        txt4Digit.keyboardType = UIKeyboardType.numberPad
        
        
//        let fromarray = getOtp.map { String($0) }
//        txt1Digit.text! = fromarray[0]
//        txt2Digit.text! = fromarray[1]
//        txt3Digit.text! = fromarray[2]
//        txt4Digit.text! = fromarray[3]

        //txt1Digit.isUserInteractionEnabled = false
       // txt2Digit.isUserInteractionEnabled = false
        //txt3Digit.isUserInteractionEnabled = false
       // txt4Digit.isUserInteractionEnabled = false
        
        txt1Digit.isUserInteractionEnabled = true
        txt2Digit.isUserInteractionEnabled = true
        txt3Digit.isUserInteractionEnabled = true
        txt4Digit.isUserInteractionEnabled = true


        txt1Digit.becomeFirstResponder()

        if #available(iOS 12.0, *) {
            txt1Digit.textContentType = .oneTimeCode
            txt2Digit.textContentType = .oneTimeCode
            txt3Digit.textContentType = .oneTimeCode
            txt4Digit.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }

        
        Common.shared.onlySetBorder(to: txt1Digit)
         Common.shared.onlySetBorder(to: txt2Digit)
         Common.shared.onlySetBorder(to: txt3Digit)
         Common.shared.onlySetBorder(to: txt4Digit)

        
        conViewRessendHeight.constant = 0
        viewResend.updateConstraintsIfNeeded()
        viewResend.layoutIfNeeded()
        resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        txt1Digit.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txt2Digit.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txt3Digit.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        txt4Digit.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }

    @objc func update() {
        if(count > 0) {
            count = count - 1
            let minutes = String(count / 60)
            let seconds = String(format: "%0ld", count % 60).PadLeft(totalWidth: 2, byString: "0")
            let attrs1 = [NSAttributedString.Key.font : setFont.regular.of(size: UIDevice.current.userInterfaceIdiom == .pad ? 25 :15), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : setFont.regular.of(size: UIDevice.current.userInterfaceIdiom == .pad ? 25 :15), NSAttributedString.Key.foregroundColor : AppConstants.kColor_Primary]

            let attributedString1 = NSMutableAttributedString(string:"Enter your 4 digit code within ", attributes:attrs1 as [NSAttributedString.Key : Any])
            let attributedString2 = NSMutableAttributedString(string:" 0\(minutes):\(seconds)", attributes:attrs2 as [NSAttributedString.Key : Any])
            let attributedString3 = NSMutableAttributedString(string:" min", attributes:attrs1 as [NSAttributedString.Key : Any])
            attributedString1.append(attributedString2 )
            attributedString1.append(attributedString3 )

            lbldisplayTimer.attributedText = attributedString1
        } else {
            
            let attrs1 = [NSAttributedString.Key.font : setFont.regular.of(size: UIDevice.current.userInterfaceIdiom == .pad ? 25 :15), NSAttributedString.Key.foregroundColor : UIColor.black]
            let attrs2 = [NSAttributedString.Key.font : setFont.regular.of(size: UIDevice.current.userInterfaceIdiom == .pad ? 25 :15), NSAttributedString.Key.foregroundColor : AppConstants.kColor_Primary]
            let attributedString1 = NSMutableAttributedString(string:"Enter your 4 digit code within ", attributes:attrs1 as [NSAttributedString.Key : Any])
            let attributedString2 = NSMutableAttributedString(string:" 05:00 ", attributes:attrs2 as [NSAttributedString.Key : Any])
            let attributedString3 = NSMutableAttributedString(string:"Minutes", attributes:attrs1 as [NSAttributedString.Key : Any])
            attributedString1.append(attributedString2 )
            attributedString1.append(attributedString3 )

            lbldisplayTimer.attributedText =  attributedString1
            conViewRessendHeight.constant = 91
            viewResend.updateConstraintsIfNeeded()
            viewResend.layoutIfNeeded()
            resendTimer.invalidate()
        }
    }

    @IBAction func btnSubmitClick(_ sender: Any) {
        self.view.endEditing(true)
        guard let strCode1 = txt1Digit.text,  strCode1.count > 0 else {
            Utils.showMessage(type: .error,message: "Please enter verification code")
        return
    }
        guard let strCode2 = txt2Digit.text,  strCode2.count > 0 else {
            Utils.showMessage(type: .error,message: "Please enter verification code")
            return
        }
        guard let strCode3 = txt3Digit.text,  strCode3.count > 0 else {
            Utils.showMessage(type: .error,message: "Please enter verification code")
            return
        }
        guard let strCode4 = txt4Digit.text,  strCode4.count > 0 else {
            Utils.showMessage(type: .error,message: "Please enter verification code")
            return
        }
        callApi()
    }
    
    @IBAction func btnResendClick(_ sender: Any) {
        txt1Digit.text = ""
        txt2Digit.text = ""
        txt3Digit.text = ""
        txt4Digit.text = ""
        self.count = 300
        conViewRessendHeight.constant = 0
        viewResend.updateConstraintsIfNeeded()
        viewResend.layoutIfNeeded()
        self.resendTimer = Timer()
        self.resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self,selector: #selector(self.update), userInfo: nil, repeats: true)
    }

    @IBAction func btnLoginClick(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Delegate Methods
    // MARK: UITextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtTemp = textField
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtTemp.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        txtTemp.text = txtTemp.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        txtTemp.resignFirstResponder()
        txtTemp = nil
    }

    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        if  text?.count == 1 {
            switch textField{
            case txt1Digit:
                txt2Digit.becomeFirstResponder()
            case txt2Digit:
                txt3Digit.becomeFirstResponder()
            case txt3Digit:
                txt4Digit.becomeFirstResponder()
            case txt4Digit:
                txt4Digit.resignFirstResponder()
            default:
                break
            }
        }
        if  text?.count == 0 {
                    switch textField{
                    case txt1Digit:
                        txt1Digit.becomeFirstResponder()
                    case txt2Digit:
                        txt1Digit.becomeFirstResponder()
                    case txt3Digit:
                        txt2Digit.becomeFirstResponder()
                    case txt4Digit:
                        txt3Digit.becomeFirstResponder()
                    default:
                        break
                    }
                }
        else{}
    }
    
    //MARK:- Api Call
    func callApi() {
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Auth.verifyOTPEndpoint
        let setOtp = txt1Digit.text!+txt2Digit.text!+txt3Digit.text!+txt4Digit.text!
        let param = ["CellNumber":getCellNo,
                     "OTP":setOtp]
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:param, httpMethodForGetOrPost: .post, setheaders: header) {[weak self] (dicResponseWithSuccess ,_)  in
            if let weakSelf = self {
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        
                        weakSelf.dictVerifyOtpRes = VerifyOtpModel().initWithDictionary(dictionary: dicResponseData)

                        if weakSelf.dictVerifyOtpRes.statuscode == "OK" {
                            if weakSelf.isComeFrom == "login" {
                                USER_DEFAULTS.set(true, forKey: AppConstants.IS_LOGIN)
                                USER_DEFAULTS.setValue(weakSelf.dictVerifyOtpRes.token, forKey: AppConstants.TOKEN)
                                print("Token is:\(weakSelf.dictVerifyOtpRes.token)")
                                USER_DEFAULTS.set(weakSelf.dictVerifyOtpRes.firstname, forKey:AppConstants.FIRST_NAME)
                                USER_DEFAULTS.set(weakSelf.dictVerifyOtpRes.lastname, forKey:AppConstants.LAST_NAME)
                                USER_DEFAULTS.set(weakSelf.dictVerifyOtpRes.id, forKey:AppConstants.USER_ID)
                                        USER_DEFAULTS.synchronize()
                                //Set NewFlow MOW :-
                                weakSelf.storeFCMtokenNotification()
                            } else {
                                weakSelf.navigationController?.popToRootViewController(animated: true)
                            }
                            }
                        else{
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message:weakSelf.dictVerifyOtpRes.message)
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
        
       //MARK:- Check Active Order Api
    
    func callActiveOrderApi(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.getAllActiveOrder
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(getDesId)") { (dicResponseWithSuccess ,_)  in
            if  let jsonResponse = dicResponseWithSuccess {
                guard jsonResponse.dictionary != nil else {
                    return
                }
                if let dicResponseData = jsonResponse.dictionary {
                    APP_DELEGATE.dictActiveOrderRes = ActiveOrderResModel().initWithDictionary(dictionary: dicResponseData)
                    if APP_DELEGATE.dictActiveOrderRes.statusCode == "OK" {
                        Utils.hideProgressHud()
                        APP_DELEGATE.arrActiveOrder = APP_DELEGATE.dictActiveOrderRes.arrActiveOrder
                        completionHandler(true)
                        
                    } else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: APP_DELEGATE.dictActiveOrderRes.message)
                        completionHandler(false)
                    }
                }
            }
        }
    }
    
    func storeFCMtokenNotification(){
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Auth.storefcmToken
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        let param1 = [
                    "UserID":(getDesId),
                    "HardwareNo":UIDevice.current.identifierForVendor!.uuidString,
                    "DeviceToken":getFCMToken,"LoggedOn":"3"] as [String : Any]
        API_SHARED.uploadDictToServer(apiUrl: apiUrl , dataToUpload:param1) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {
                            Utils.hideProgressHud()
                        } else {
                            Utils.hideProgressHud()
                        }
                        Utils.showProgressHud()
                        APP_DELEGATE.validateLicenseApi(completionHandler: {success in
                            Utils.hideProgressHud()
                            if success == true {
                                if APP_DELEGATE.saveDictLicenseRes["IsActiveOrderAval"]?.boolValue == true   {
                                    APP_DELEGATE.setActiveorderRootVC()
                                } else {
                                    let loginScene = HomeVC.instantiate(fromAppStoryboard: .DashBoard)
                                        loginScene.isOpenFrom = "dest"
                                        let leftMenuViewController = LeftMenuViewController.instantiate(fromAppStoryboard: .DashBoard)
                                        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: loginScene), leftMenuViewController: leftMenuViewController)
                                        sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: false, scaleBackground: false))
                                            sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 1.0))
                                 sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.clear, opacity: 0.6, radius: 6.0))
                                                                                    APP_DELEGATE.navVC = UINavigationController(rootViewController: sideMenu)
                                                                                    APP_DELEGATE.navVC?.navigationBar.isHidden = true
                                                                                    APP_DELEGATE.window?.rootViewController =  APP_DELEGATE.navVC
                                                                                    APP_DELEGATE.window?.makeKeyAndVisible()
                            }
                            } else {
                                APP_DELEGATE.setProfileRootVC()
                        }
                        })
                    }
                }
            }
//                            self.callActiveOrderApi(completionHandler: {success in
//                                USER_DEFAULTS.set(APP_DELEGATE.arrActiveOrder.count, forKey:intArrActiveOrderCount)
//                                USER_DEFAULTS.synchronize()
//                                APP_DELEGATE.validateLicenseApi(completionHandler: {success in
//                                    if success == true {
//                                        if APP_DELEGATE.arrActiveOrder.count > 0 {
//                                            APP_DELEGATE.setActiveorderRootVC()
//                                        } else {
//                                                let loginScene = HomeVC.instantiate(fromAppStoryboard: .DashBoard)
//                                                loginScene.isOpenFrom = "dest"
//                                                let leftMenuViewController = LeftMenuViewController.instantiate(fromAppStoryboard: .DashBoard)
//                                                let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: loginScene), leftMenuViewController: leftMenuViewController)
//                                                sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: false, scaleBackground: false))
//                                                sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 1.0))
//                                                sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.clear, opacity: 0.6, radius: 6.0))
//                                                APP_DELEGATE.navVC = UINavigationController(rootViewController: sideMenu)
//                                                APP_DELEGATE.navVC?.navigationBar.isHidden = true
//                                                APP_DELEGATE.window?.rootViewController =  APP_DELEGATE.navVC
//                                                APP_DELEGATE.window?.makeKeyAndVisible()
//                                            }
//                                    } else {
//                                        APP_DELEGATE.setProfileRootVC()
//                                    }
//                                })
                        }
                

    }
