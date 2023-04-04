//
//  ValidateCartModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 21/02/22.
//  Copyright © 2022 Verve_Sys. All rights reserved.
//

import Foundation
import SwiftyJSON


class ValidateCartModel:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let DeviceId = "DeviceId"
    let LocationId = "LocationId"
    let PickUpTime = "PickUpTime"
    let ReturnTime = "ReturnTime"
    let OrderID = "OrderID"
    let PickUpDate = "PickUpDate"
    let ReturnDate = "ReturnDate"

    
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var deviceId :Int = 0
    lazy var locationId :Int = 0
    lazy var pickUpTime = ""
    lazy var returnTime = ""
    lazy var pickUpDate = ""
    lazy var orderID :Int = 0
    lazy var returnDate = ""

    
    func initWithDictionary(dictionary:[String : JSON]) -> ValidateCartModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[LocationId]?.intValue {
            locationId = item3
        }

        if let item4 = dictionary[DeviceId]?.intValue {
            deviceId = item4
        }

        if let item5 = dictionary[PickUpDate]?.stringValue {
            pickUpDate = item5
        }

        if let item6 = dictionary[PickUpTime]?.stringValue {
            pickUpTime = item6
        }

        if let item7 = dictionary[ReturnDate]?.stringValue {
                returnDate  = item7
        }
        
        if let item8 = dictionary[OrderID]?.intValue {
                orderID = item8
        }
        if let item9 = dictionary[ReturnTime]?.stringValue {
                returnTime = item9
        }
        
        return self

        
    }

    

    
}
