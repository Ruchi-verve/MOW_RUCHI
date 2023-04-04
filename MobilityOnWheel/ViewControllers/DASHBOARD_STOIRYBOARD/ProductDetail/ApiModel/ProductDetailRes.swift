//
//  ProductDetailRes.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 10/08/21.
//

import Foundation
import SwiftyJSON


class ProductDetailRes:NSObject {

    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let ChairPadPrice = "ChairPadPrice"
    let Description = "Description"
    let DevicePropertyIDs = "DevicePropertyIDs"
    let DeviceTypeName = "DeviceTypeName"
    let DeviceTypeShortName = "DeviceTypeShortName"
    let ID = "ID"
    let ItemFullDescription = "ItemFullDescription"
    let ItemImagePath = "ItemImagePath"
    let ItemShortDescription = "ItemShortDescription"
    let OperatorOccupantSame = "OperatorOccupantSame"

    
    
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var chairPadPrice :Int = 0
    lazy var desc = ""
    lazy var devicePropertyIDs = ""
    lazy var deviceTypeName = ""
    lazy var deviceTypeShortName = ""
    lazy var iD :Int = 0
    lazy var itemFullDescription = ""
    lazy var itemImagePath = ""
    lazy var itemShortDescription = ""
    lazy var operatorOccupantSame :Bool = false

    
    func initWithDictionary(dictionary:[String : JSON]) -> ProductDetailRes {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        if let item3 = dictionary[ChairPadPrice]?.intValue {
            chairPadPrice = item3
        }
        if let item4 = dictionary[Description]?.stringValue {
            desc = item4
        }
        if let item5 = dictionary[DevicePropertyIDs]?.stringValue {
            devicePropertyIDs = item5
        }
        if let item6 = dictionary[DeviceTypeName]?.stringValue {
            deviceTypeName = item6
        }
        if let item7 = dictionary[DeviceTypeShortName]?.stringValue {
            deviceTypeShortName = item7
        }
        if let item8 = dictionary[ID]?.intValue {
            iD = item8
        }
        if let item9 = dictionary[ItemFullDescription]?.stringValue {
            itemFullDescription = item9
        }
        if let item10 = dictionary[ItemImagePath]?.stringValue {
            itemImagePath = item10
        }
        if let item11 = dictionary[ItemShortDescription]?.stringValue {
            itemShortDescription = item11
        }
        if let item12 = dictionary[OperatorOccupantSame]?.boolValue {
            operatorOccupantSame = item12
        }

        
        
        
        
        
        
        
        
        return self

        
    }

    

    
}
