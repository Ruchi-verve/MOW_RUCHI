//
//  CommonApi.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 13/08/21.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit


var arrAcceTypeList = [AccessoryTypeSubRes]()
 var dictAccType = AccessoryTypeListModel()
 var dictCardData = CardListModel()
 var arr_Card_Data   = [CardListSubModel]()
 var Arr_OccupantList = [OccupantListModel]()
 var dictOccupantOperatorInfo = OperatorOccupantInfoModel()
 var dictLocRes = DestinationResModel()
 var arrLocation = [String:[DestResSubModel]]()
 var arrPropertyIds = [DevicePropertySubResModel]()
 var dictPropertyIds = DevicePropertyOptionsModel()
 var dictGetProfileData = CustomerAdressModel()
 var dictHistoryRes = OrderHistoryModel()

class CommonApi {
    
    class func callOperatorListApi(completionHandler: @escaping  (Bool) -> (), con: UIViewController){

        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.getOperatorList
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: con, passValue: "\(getDesId)") {(dicResponseWithSuccess ,_)  in
                            if  let jsonResponse = dicResponseWithSuccess {
                                guard jsonResponse.dictionary != nil else {
                                    return
                                }
                                if let dicResponseData = jsonResponse.dictionary {
                                    APP_DELEGATE.dictApiRes = OperatorListModel().initWithDictionary(dictionary: dicResponseData)
            
                                    if APP_DELEGATE.dictApiRes.statusCode == "OK" {
                                        APP_DELEGATE.arrOperatorList = APP_DELEGATE.dictApiRes.arrOperatorList
                                        Utils.hideProgressHud()
                                        completionHandler(true)

                                    } else {
                                            Utils.hideProgressHud()
                                        Utils.showMessage(type: .error, message:"No Operators Found")
                                        completionHandler(false)

                                        }
                                    }
                                } else {
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                                    completionHandler(false)

                                }
                            }
                        }
    
    
    //MARK:- Call get all destination
    
    class func callGetDestinationApi(completionHandler: @escaping  (Bool) -> ()){
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getAllDestinationEndPoint
        
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:nil, httpMethodForGetOrPost: .get, setheaders: [:]) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        
                        dictLocRes = DestinationResModel().initWithDictionary(dictionary: dicResponseData)
                        if dictLocRes.statusCode == "OK" {
                            
                            Utils.hideProgressHud()
                           arrLocation = dictLocRes.arrCatWithObj
                            completionHandler(true)
                        }
                        else {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message:dictLocRes.message)
                            completionHandler(false)

                        }
                        
                    }
                    
                } else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                    completionHandler(false)

                }
        }
    }
    
    //MARK:- Call get Property Options

    
    
    class func callDevicePropertyOptionsApi(id:Int,controll:UIViewController,completionHandler: @escaping  (Bool) -> ()){

        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()

        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getDevicePropertOptions
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: controll, passValue: "\(id)") {(dicResponseWithSuccess ,_)  in
                            if  let jsonResponse = dicResponseWithSuccess {
                                guard jsonResponse.dictionary != nil else {
                                    return
                                }
                                if let dicResponseData = jsonResponse.dictionary {
                                    arrPropertyIds.removeAll()
                                    dictPropertyIds = DevicePropertyOptionsModel().initWithDictionary(dictionary: dicResponseData)
            
                                    if dictPropertyIds.statusCode == "OK" {
                                       arrPropertyIds = dictPropertyIds.arrListDevicePropertyOption
                                        Utils.hideProgressHud()
                                        completionHandler(true)

                                    } else {
                                            Utils.hideProgressHud()
                                        Utils.showMessage(type: .error, message:"No Operators Found")
                                        completionHandler(false)

                                        }
                                    }
                                } else {
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                                    completionHandler(false)

                                }
                            }
                        }
    
    

    
    
    class func callPickUpLocation(destinationId:Int,devicetypeId:Int,completionHandler: @escaping  (Bool) -> ()){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let getToken = USER_DEFAULTS.value(forKey: AppConstants.TOKEN)
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getPickupLocation
        let param = ["destinationID":destinationId  ,"deviceTypeID":devicetypeId] as [String:Any]
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":"\(getToken!)","DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:param, httpMethodForGetOrPost: .post, setheaders: header) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        
                        APP_DELEGATE.dictgetPickupLoc = PickupLocationModel().initWithDictionary(dictionary: dicResponseData)

                        if APP_DELEGATE.dictgetPickupLoc.statusCode == "OK" {
                            APP_DELEGATE.arrgetPickupLoc = APP_DELEGATE.dictgetPickupLoc.arrPickupLocation
                            
                            completionHandler(true)
                    }
                        else{
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message: APP_DELEGATE.dictgetPickupLoc.message)
                            completionHandler(false)
                        }
                }
                    } else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                        completionHandler(false)

                    }
                    
                
                
            }
        }
    
    //Mark:- getProfileData
    class func callGetCustomerProfile(completionHandler: @escaping  (Bool) -> (), controll:UIViewController) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Address.getAddress
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: controll, passValue: "\(getDesId)") { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        dictGetProfileData  = CustomerAdressModel().initWithDictionary(dictionary: dicResponseData)
                        completionHandler(true)
                    }
                } else {
                    completionHandler(false)
                }
            
        }
    }
    
    //Mark:- getOccupantList
    
    class func callOccupantList(CustId:Int,completionHandler: @escaping  (Bool) -> ()){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.getOccupantList
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        API_SHARED.uploadDataToServerWithStringParam(apiUrl: apiUrl , dataToUpload:"\(CustId)") { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.array != nil else {
                        return
                    }
                        if let jsonArr = jsonResponse.array {
                            Utils.hideProgressHud()
                            Arr_OccupantList =  [OccupantListModel]()
                            if jsonArr.count > 0 {
                            for i in 0 ..< jsonArr.count {
                                    let objDic = jsonArr[i].dictionary
                                    let user = OccupantListModel().initWithDictionary(dictionary: objDic!)
                                   Arr_OccupantList.append(user)
                                }
                                completionHandler(true)
                            }
                            else {
                                Arr_OccupantList =  [OccupantListModel]()
                                Utils.hideProgressHud()
                                completionHandler(true)
                            }

                            }

                    } else{
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                        completionHandler(false)

                        }
                       
}
    }
     
    
    //MARK: -Scanner KEY
    class func callgetScannerApiKey(completionHandler: @escaping  (String) -> (), controll:UIViewController) {
            if !InternetConnectionManager.isConnectedToNetwork() {
                    Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
                    return
                }
                Utils.showProgressHud()
                let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Auth.AppConfig
                API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: controll, passValue: "") { (dicResponseWithSuccess ,_)  in
                        if  let jsonResponse = dicResponseWithSuccess {
                            guard jsonResponse.dictionary != nil else {
                                return
                            }
                            if let dicResponseData = jsonResponse.dictionary {
                                
                                if dicResponseData["StatusCode"]?.stringValue == "OK" {
                                    Utils.hideProgressHud()
                                    completionHandler(dicResponseData["idanalyzerApiKey"]!.stringValue)
                                }
                                else {
                                    Utils.hideProgressHud()
                                    completionHandler("")

                                }
                            }
                        } else {
                            Utils.hideProgressHud()
                            completionHandler("")

                        }
                }

            
        }
        

    class func callCardDataApi(completionHandler: @escaping  (Bool) -> (), controler:UIViewController) {
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Card.getCradData
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: controler, passValue: "\(getDesId)") { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                       dictCardData = CardListModel().initWithDictionary(dictionary: dicResponseData)
                        
                        if dictCardData.statusCode == "OK" {
                            Utils.hideProgressHud()
                            arr_Card_Data = dictCardData.arrCardList
//                            if arr_Card_Data.count > 1 {
//                                arr_Card_Data[0].isSel = "1"
//                            }
                            completionHandler(true)
                        }
                        else {
                            Utils.hideProgressHud()
                            completionHandler(false)

                        }
                    }
                } else {
                    Utils.hideProgressHud()
                    completionHandler(false)

                }
        }
        
    }
        //MARK: -RiderReward get Api
    class  func callRewardPointsApi(completionHandler: @escaping  (Bool) -> ()) {
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.orderHistory
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.USER_ID) ?? 0
       API_SHARED.callCommonParseApiForRewards(strUrl: apiUrl, passValue: "\(getDesId)") { (dicResponseWithSuccess ,_)  in
                            if  let jsonResponse = dicResponseWithSuccess {
                                guard jsonResponse.dictionary != nil else {
                                    return
                                }
                                if let dicResponseData = jsonResponse.dictionary {
                                    dictHistoryRes = OrderHistoryModel().initWithDictionary(dictionary: dicResponseData)
            
                                    if dictHistoryRes.statusCode == "OK" {
                                        Utils.hideProgressHud()
                                        APP_DELEGATE.fltRewarardPoints = Float(dictHistoryRes.rewardPoints)
                                        completionHandler(true)
                                    }
                                    }
                                } else {
                                    Utils.hideProgressHud()
                                    completionHandler(false)
                                }
                            
                    
            }
    }
    
    //Mark:- AccessoryTypeList

    class func callAccessoryTypeList(destinationId:Int,deviceTypeId:Int,completionHandler: @escaping  (Bool) -> ()){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let getToken = USER_DEFAULTS.value(forKey: AppConstants.TOKEN)
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getAccessoryType
        let param = ["Locationid":destinationId ,"DeviceTypeId":deviceTypeId] as [String:Any]
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":"\(getToken!)","DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:param, httpMethodForGetOrPost: .post, setheaders: header) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        
                        dictAccType = AccessoryTypeListModel().initWithDictionary(dictionary: dicResponseData)
                        let dict = AccessoryTypeSubRes()
                        dict.accessoryTypeName = "SELECT ACCESSORY TYPE".capitalized
                        dictAccType.arrAccesoryList.insert(dict, at: 0)
                        if dictAccType.statusCode == "OK" {
                            Utils.hideProgressHud()
                            arrAcceTypeList.removeAll()
                            arrAcceTypeList.append(contentsOf:  dictAccType.arrAccesoryList)
                            completionHandler(true)
                    }
                        else{
                            Utils.hideProgressHud()
                            completionHandler(false)
                        }

                    }
                       
                    } else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                        completionHandler(false)

                    }
            }
}


    
    //Mark:- OccupantOperatorInfo

    class func callOccupantOperatorInfo(completionHandler: @escaping  (Bool) -> ()){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.getOccupantOperatorInfo
        let header:HTTPHeaders = ["LoggedOn":"3","DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:nil, httpMethodForGetOrPost: .post, setheaders: header) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        Utils.hideProgressHud()
                        dictOccupantOperatorInfo = OperatorOccupantInfoModel().initWithDictionary(dictionary: dicResponseData)
                        completionHandler(true)
                        }
                    } else {
                        Utils.hideProgressHud()
                        completionHandler(false)

                    }
            }
}
    
    class func callgetVersionInfoKey(completionHandler: @escaping  (String) -> (),controler:UIViewController) {
    if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Auth.AppConfig
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: controler, passValue: "") { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {
                            Utils.hideProgressHud()
                            completionHandler(dicResponseData["minimumIOSVersion"]!.stringValue)
                        }
                        else {
                            Utils.hideProgressHud()
                            completionHandler("")

                        }
                    }
                } else {
                    Utils.hideProgressHud()
                    completionHandler("")

                }
        }

    
}



    //Mark:- NotificationBadgeInfo

    class func callNotificationBadgeInfo(completionHandler: @escaping  (Bool) -> ()){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let getToken = USER_DEFAULTS.value(forKey: AppConstants.TOKEN)
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Notification.getNotificationBadge
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":"\(getToken!)","DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:nil, httpMethodForGetOrPost: .post, setheaders: header) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        Utils.hideProgressHud()
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {
                            NotificationBadge = dicResponseData["BadgeCount"]?.intValue ?? 0
                            completionHandler(true)
                        }

                        }
                       
                    } else {
                        Utils.hideProgressHud()
                        completionHandler(false)

                    }
        }
}
}
