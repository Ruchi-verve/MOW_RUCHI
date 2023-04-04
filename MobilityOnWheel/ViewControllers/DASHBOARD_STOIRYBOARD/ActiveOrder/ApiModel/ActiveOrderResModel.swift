//
//  ActiveOrderResModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 06/08/21.
//

import Foundation
import SwiftyJSON


class ActiveOrderResModel:NSObject {
    let Arr_ActiveOrder = "getAllActiveOrderMappers"
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"

    
    lazy var arrActiveOrder = [ActiveOrderSubRes]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    
    
    func initWithDictionary(dictionary:[String : JSON]) -> ActiveOrderResModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        
        if let jsonArr = dictionary[Arr_ActiveOrder]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = ActiveOrderSubRes().initWithDictionary(dictionary: objDic!)
                arrActiveOrder.append(user)
            }
        }
        return self

        
    }

    

    
}







/*
 "ErrorMessage": null,
 "Message": null,
 "StatusCode": "OK",
 "getAllActiveOrderMappers": [
     {
         "ArrivalDate": "8/4/2021 4:00:00 PM",
         "DepartureDate": "8/31/2021 5:00:00 AM",
         "DeviceTypeName": "STANDARD SCOOTER",
         "EMVID": null,
         "FormatedOrderID": "W 120667",
         "IsGPSEnabled": false,
         "LocationName": "Bally's AC",
         "OrderID": 120667,
         "ProfilePrice": 40.00,
         "RateSelected": "*1 DAY",
         "RemainingTime": "24 Days",
         "ShadowPinDeviceUniqueID": null
     },
*/
