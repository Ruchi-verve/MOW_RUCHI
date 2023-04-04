//
//  ApiManager.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 05/08/21.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class ApiManager:NSObject{
    var isConnected              = false
    var deviceId = String()
    static let sharedInstance: ApiManager = {
        let instance = ApiManager()
        instance.initialize()
        return instance
    }()
    
    func initialize() {
        
    }
    
    
    func callCommonParseApiwithDictParameter(strUrl : String?,passValue:[String:Any],withJsonResponseValue:((JSON?, Int?) -> Void)?) {
        var request = URLRequest(url: URL(string: strUrl!)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("3", forHTTPHeaderField: "LoggedOn")
        request.setValue("\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)", forHTTPHeaderField: "DeviceId")
        request.setValue("\(APP_DELEGATE.appXVersion!)", forHTTPHeaderField: "IosAppVersion")
        if USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != nil || USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != "" {
            print("Token is:\(USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? "")")
            request.setValue( USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String, forHTTPHeaderField: "token")
        }
        else {}
        let jsonData = try! JSONSerialization.data(withJSONObject: passValue, options: [])
        request.httpBody = jsonData
        AF.request(request)
            .responseJSON {  (response) in
                
                            var json = JSON()
                            switch response.result {
                                   case .success(let data):
                                    json = JSON(data)
                                    guard json.dictionary != nil else {
                                        return
                                    }
                                    withJsonResponseValue?(json,response.response?.statusCode)
                                    break
                            case .failure(let error):
                                switch error {
                                case .sessionTaskFailed(URLError.timedOut):
                                    print("Request timeout!")
                                    Utils.showMessage(type: .error, message: "Request timeout!")
                                default:
                                    print("Other error!")
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                                }
                                break
        }
        }
    }
    
    func callCommonParseApi(strUrl : String?,controller :UIViewController ,passValue:String,withJsonResponseValue:((JSON?, Int?) -> Void)?) {
        var request = URLRequest(url: URL(string: strUrl!)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)", forHTTPHeaderField: "DeviceId")
        request.setValue("\(APP_DELEGATE.appXVersion!)", forHTTPHeaderField: "IosAppVersion")
        request.setValue("3", forHTTPHeaderField: "LoggedOn")
        if USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != nil || USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != "" {
            print("Token is:\(USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? "")")
            request.setValue( USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String, forHTTPHeaderField: "token")
        }
        else {}
        request.httpBody = passValue.data(using: .utf8)
        AF.request(request)
            .responseJSON {  (response) in
                            var json = JSON()
                            switch response.result {
                                   case .success(let data):
                                    json = JSON(data)
                                    guard json.dictionary != nil else {
                                        if json.string != nil ||  json.string != "" {
                                            if json.string!.contains("update the app") {
//                                                Common.shared.createAlertView(controller)
                                                //controller.createAlertView(msg: json.string!)
                                                ErrorReporting.showMessage(title: "Alert", msg: json.string!, on: controller)
                                            }
                                            let appDomain = Bundle.main.bundleIdentifier
                                            let getDestId  = USER_DEFAULTS.value(forKey: AppConstants.selDestId) as? Int
                                            let getDestName  = USER_DEFAULTS.value(forKey: AppConstants.SelDest) as? String
                                            USER_DEFAULTS.removePersistentDomain(forName: appDomain ?? "com.mow.cash")
                                            USER_DEFAULTS.synchronize()
                                            Common.shared.deleteDatabase()
                                            Common.shared.deleteUserDatabase()
                                            APP_DELEGATE.dictEditedData = [:]
                                            strIsEditOrder = ""
                                            APP_DELEGATE.arrActiveOrder.removeAll()
                                            APP_DELEGATE.isComeFrom = ""
                                            APP_DELEGATE.isAgree = false
                                            APP_DELEGATE.getPaymentProfileId = 0
                                            APP_DELEGATE.strVideoUrl = nil
                                            APP_DELEGATE.deviceTypeId = 0
                                            APP_DELEGATE.otherStateId = 0
                                            APP_DELEGATE.rewardPoint = 0
                                            APP_DELEGATE.arrOperatorList.removeAll()
                                            APP_DELEGATE.arrSaveOperatorList.removeAll()
                                            Arr_OccupantList.removeAll()
                                            strTotal = ""
                                            strSubTotal = ""
                                            strDeliveryFee = ""
                                            TaxRate = 0
                                            getTotal = 0
                                            flotPricewithTax = 0.00
                                            USER_DEFAULTS.set(getDestId, forKey: AppConstants.selDestId)
                                            USER_DEFAULTS.set(getDestName, forKey: AppConstants.SelDest)
                                            USER_DEFAULTS.synchronize()
                                            APP_DELEGATE.setLoginRootVC()
                                        }
                                        return
                                    }
                                    withJsonResponseValue?(json,response.response?.statusCode)
                                    break
                            case .failure(let error):
                                switch error {
                                case .sessionTaskFailed(URLError.timedOut):
                                    print("Request timeout!")
                                    Utils.showMessage(type: .error, message: "Request timeout!")
                                default:
                                    print("Other error!")
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                                }
                                break
        }
        }
    }
    
    
    func callCommonParseApiForRewards(strUrl : String?, passValue:String,withJsonResponseValue:((JSON?, Int?) -> Void)?) {
        var request = URLRequest(url: URL(string: strUrl!)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)", forHTTPHeaderField: "DeviceId")
        request.setValue("\(APP_DELEGATE.appXVersion!)", forHTTPHeaderField: "IosAppVersion")
        request.setValue("3", forHTTPHeaderField: "LoggedOn")
        if USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != nil || USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != "" {
            print("Token is:\(USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? "")")
            request.setValue( USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String, forHTTPHeaderField: "token")
        }
        else {}
        request.httpBody = passValue.data(using: .utf8)
        AF.request(request)
            .responseJSON {  (response) in
                            var json = JSON()
                            switch response.result {
                                   case .success(let data):
                                    json = JSON(data)
                                   guard json.dictionary != nil else {return}
                                    withJsonResponseValue?(json,response.response?.statusCode)
                                    break
                            case .failure(let error):
                                switch error {
                                case .sessionTaskFailed(URLError.timedOut):
                                    print("Request timeout!")
                                    Utils.showMessage(type: .error, message: "Request timeout!")
                                default:
                                    print("Other error!")
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                                }
                                break
        }
        }
    }
    
    func callCommonParseApiwithboolRes(strUrl : String?,passValue:String,withJsonResponseValue:((Bool,Int) -> Void)?) {
        var request = URLRequest(url: URL(string: strUrl!)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("3", forHTTPHeaderField: "LoggedOn")
        request.setValue("\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)", forHTTPHeaderField: "DeviceId")
        request.setValue("\(APP_DELEGATE.appXVersion!)", forHTTPHeaderField: "IosAppVersion")

        if USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != nil || USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != "" {
            print("Token is:\(USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? "")")
            request.setValue( USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String, forHTTPHeaderField: "token")
        }
        else {}
        request.httpBody = passValue.data(using: .utf8)
        AF.request(request)
            .responseJSON {  (response) in
                            var json = JSON()
                            switch response.result {
                                   case .success(let data):
                                    json = JSON(data)
                                    withJsonResponseValue?(json.boolValue,response.response!.statusCode)
                                    break
                            case .failure(let error):
                                    print(error)
                                Utils.hideProgressHud()
                                       break
        }
        }
    }
    func callCommonParseApiwithstrRes(strUrl : String?,passValue:String,withJsonResponseValue:((String,Int) -> Void)?) {
        var request = URLRequest(url: URL(string: strUrl!)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("3", forHTTPHeaderField: "LoggedOn")
        request.setValue("\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)", forHTTPHeaderField: "DeviceId")
        request.setValue("\(APP_DELEGATE.appXVersion!)", forHTTPHeaderField: "IosAppVersion")
        if USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != nil || USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != "" {
            print("Token is:\(USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? "")")
            request.setValue( USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String, forHTTPHeaderField: "token")
        }
        else {}
        request.httpBody = passValue.data(using: .utf8)
        AF.request(request)
            .responseJSON {  (response) in
                            var json = JSON()
                            switch response.result {
                                   case .success(let data):
                                    json = JSON(data)
                                    guard json.stringValue != ""  else {
                                        return
                                    }
                                    withJsonResponseValue?(json.stringValue,response.response!.statusCode)
                                    break
                                    case .failure(let error):
                                    print(error)
                                    Utils.hideProgressHud()
                                    break
        }
        }
    }
    func callAPIForGETorPOST(strUrl : String?, parameters: [String : Any]?, httpMethodForGetOrPost : Alamofire.HTTPMethod?, setheaders:HTTPHeaders,withJsonResponseValue: ((JSON?, Int?) -> Void)?) {
            print("Parameters", parameters as Any)
        AF.request(strUrl!, method: .post, parameters: parameters, encoding: JSONEncoding.default,
                       headers: setheaders).responseJSON {  (response) in
                            var json = JSON()
                            switch response.result {
                            case .success(let data):
                                    json = JSON(data)
                                    guard json.dictionary != nil else { return }
                                    withJsonResponseValue?(json,response.response?.statusCode)
                                    break
                                
                            case .failure(let error):
                                Utils.hideProgressHud()
                                Utils.showMessage(type: .error, message: "Something went wrong!")
                                print(error)
                                break
                        }
        }
    }
    
    //MARK:- Response in Dictionary Format

    func uploadDictToServer(apiUrl: String, dataToUpload: [String: Any], withJsonResponseValue: ((JSON?, Int?) -> Void)?){
        var request = URLRequest(url: URL.init(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("3", forHTTPHeaderField: "LoggedOn")
        request.setValue("\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)", forHTTPHeaderField: "DeviceId")
        request.setValue("\(APP_DELEGATE.appXVersion!)", forHTTPHeaderField: "IosAppVersion")
        let dataToSync = dataToUpload
        request.httpBody = try! JSONSerialization.data(withJSONObject: dataToSync,options: .prettyPrinted)
        if USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != nil || USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != "" {
            print("Token is:\(USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? "")")
            request.setValue( USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String, forHTTPHeaderField: "token")
        }

        AF.request(request)
            .responseJSON { (response) in
                            var json = JSON()
                            switch response.result {
                                   case .success(let data):
                                    json = JSON(data)
                                    if json.dictionary != nil{
                                        withJsonResponseValue?(json,response.response?.statusCode)
                                    }
                                    else if  json.array != nil  {
                                        withJsonResponseValue?(json,response.response?.statusCode)
                                    }
                                    
                                    break
                                   case .failure(let error):
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: "Something went wrong!")
                                    print(error)
                                       break
                                   }
                        }
    }
    
    
    func uploadDictToServerwithstrRes(apiUrl: String, dataToUpload: [String: Any], withJsonResponseValue: ((String,Int) -> Void)?){
        var request = URLRequest(url: URL.init(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("3", forHTTPHeaderField: "LoggedOn")
        request.setValue("\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)", forHTTPHeaderField: "DeviceId")
        request.setValue("\(APP_DELEGATE.appXVersion!)", forHTTPHeaderField: "IosAppVersion")
        let dataToSync = dataToUpload
        request.httpBody = try! JSONSerialization.data(withJSONObject: dataToSync,options: .prettyPrinted)
        if USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != nil || USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != "" {
            print("Token is:\(USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? "")")
            request.setValue( USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String, forHTTPHeaderField: "token")
        }

        AF.request(request)
            .responseJSON { (response) in
                            var json = JSON()
                            switch response.result {
                                   case .success(let data):
                                    json = JSON(data)
                                    if json.string != nil{
                                        withJsonResponseValue?(json.string!,response.response!.statusCode)
                                    }
                                    break
                                   case .failure(let error):
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: "Something went wrong!")
                                    print(error)
                                       break
                                   }
                        }
    }

    
    //MARK:- Response in Array Format

    func uploadDataToServer(apiUrl: String, dataToUpload: [[String: Any]], withJsonResponseValue: ((JSON?, Int?) -> Void)?){
        var request = URLRequest(url: URL.init(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("3", forHTTPHeaderField: "LoggedOn")
        request.setValue("\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)", forHTTPHeaderField: "DeviceId")
        request.setValue("\(APP_DELEGATE.appXVersion!)", forHTTPHeaderField: "IosAppVersion")

        let dataToSync = dataToUpload
        request.httpBody = try! JSONSerialization.data(withJSONObject: dataToSync)
        if USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != nil || USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != "" {
            print("Token is:\(USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? "")")
            request.setValue( USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String, forHTTPHeaderField: "token")
        }

        AF.request(request)
            .responseJSON { (response) in
                            var json = JSON()
                            switch response.result {
                                   case .success(let data):
                                    json = JSON(data)
                                    if json.dictionary != nil{
                                        withJsonResponseValue?(json,response.response?.statusCode)
                                    }
                                    else if  json.array != nil  {
                                        withJsonResponseValue?(json,response.response?.statusCode)
                                    }
                                    break
                                   case .failure(let error):
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: "Something went wrong!")
                                    print(error)
                                       break
                                   }
                        }
    }
    
    func uploadDataToServerWithStringParam(apiUrl: String, dataToUpload:String, withJsonResponseValue: ((JSON?, Int?) -> Void)?){
        var request = URLRequest(url: URL.init(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("3", forHTTPHeaderField: "LoggedOn")
        request.setValue("\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)", forHTTPHeaderField: "DeviceId")
        request.setValue("\(APP_DELEGATE.appXVersion!)", forHTTPHeaderField: "IosAppVersion")

        request.httpBody = dataToUpload.data(using: .utf8)
           if USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != nil || USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String != "" {
            print("Token is:\(USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? "")")
            request.setValue( USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String, forHTTPHeaderField: "token")
        }

        AF.request(request)
            .responseJSON { (response) in
                            var json = JSON()
                            switch response.result {
                                   case .success(let data):
                                    json = JSON(data)
                                    if json.dictionary != nil{
                                        withJsonResponseValue?(json,response.response?.statusCode)
                                    }
                                    else if  json.array != nil  {
                                        withJsonResponseValue?(json,response.response?.statusCode)
                                    }
                                    break
                                   case .failure(let error):
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: "Something went wrong!")
                                    print(error)
                                       break
                                   }
                        }
        
    }

    
    
    }


