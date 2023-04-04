//
//  DeviceTypeModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 09/08/21.
//

import Foundation
import SwiftyJSON

class DeviceTypeModel:NSObject {
    let Arr_Product = "listRestricatedDevice"
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"

    
    lazy var arrProductList = [DeviceTypeSubResModel]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    
    
    func initWithDictionary(dictionary:[String : JSON]) -> DeviceTypeModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        
        if let jsonArr = dictionary[Arr_Product]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = DeviceTypeSubResModel().initWithDictionary(dictionary: objDic!)
                arrProductList.append(user)
            }
        }
        return self

        
    }

    

    
}

/*
 "ErrorMessage": null,
 "Message": null,
 "StatusCode": "OK",
 "listRestricatedDevice": [
     {
         "CompPriceDescription": "$75.00 for 1st day, discount on additional days (Inventory is limited, please call Customer Service at (855) 484-4454 during business hours to make a reservation)",
         "DeviceTypeID": 7,
         "InventoryID": 0,
         "ItemImagePath": "ItemImage/20171106134627.jpg",
         "ItemName": "BEACH WHEELCHAIR",
         "RegularPriceDescription": "$75.00 for 1st day, discount on additional days (Inventory is limited, please call Customer Service at (855) 484-4454 during business hours to make a reservation)"
     },
*/
