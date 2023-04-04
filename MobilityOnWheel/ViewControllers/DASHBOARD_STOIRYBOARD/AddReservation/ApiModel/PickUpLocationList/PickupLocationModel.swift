//
//  PickupLocationModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 13/08/21.
//

import Foundation
import SwiftyJSON

class PickupLocationModel:NSObject {
    
    let Arr_PickupLocation = "listCustomerPickupLocation"
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"

    
    lazy var arrPickupLocation = [PickupLocationModelSubRes]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    
    
    func initWithDictionary(dictionary:[String : JSON]) -> PickupLocationModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        
        if let jsonArr = dictionary[Arr_PickupLocation]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = PickupLocationModelSubRes().initWithDictionary(dictionary: objDic!)
                arrPickupLocation.append(user)
            }
        }
        return self
        
    }
}

class PickupLocationModelSubRes:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let CustomerPickupLocationID = "CustomerPickupLocationID"
    let CustomerPickuplocationName = "CustomerPickuplocationName"
    let IsAvailableOrNot = "IsAvailableOrNot"
    let IsShippingAddress = "IsShippingAddress"
    let IsSelected = "isPicked"
    
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var customerPickupLocationID:Int = 0
    lazy var customerPickuplocationName = ""
    lazy var isAvailableOrNot:Bool = false
    lazy var isShippingAddress:Bool = false
    lazy var isSelected:Int = 0

    
    func initWithDictionary(dictionary:[String : JSON]) -> PickupLocationModelSubRes {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[CustomerPickupLocationID]?.intValue {
            customerPickupLocationID = item3
        }

        if let item5 = dictionary[CustomerPickuplocationName]?.stringValue {
            customerPickuplocationName = item5
        }

        if let item6 = dictionary[IsAvailableOrNot]?.boolValue {
            isAvailableOrNot = item6
        }

        if let item7 = dictionary[IsShippingAddress]?.boolValue {
            isShippingAddress  = item7
        }
        

        return self

        
    }

    

    
}





