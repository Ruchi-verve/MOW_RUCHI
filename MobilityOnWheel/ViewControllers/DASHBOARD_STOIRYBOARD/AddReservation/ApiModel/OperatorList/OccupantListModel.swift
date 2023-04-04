//
//  OccupantListModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 17/08/21.
//

import Foundation
import SwiftyJSON


class OccupantListModel:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let AccessoryTypeID = "AccessoryTypeID"
    let DeviceStyle = "DeviceStyle"
    let  FirstName = "FirstName"
    let DeviceTypeID = "DeviceTypeID"
    let FullName = "FullName"
    let HeightFeet = "HeightFeet"
    let HeightInch = "HeightInch"
    let ID = "ID"
    let LastName = "LastName"
    let MiddleName = "MiddleName"
    let Notes = "Notes"
    let OperatorID = "OperatorID"
    let OperatorName = "OperatorName"
    let Weight = "Weight"
    let IsDefault = "isDefault"

    
    lazy var errorMessage = ""
    lazy var message = ""
    lazy var statusCode = ""
    lazy var accessoryTypeID:Int = 0
    lazy var deviceStyle = ""
    lazy var firstName = ""
    lazy var deviceTypeID:Int = 0
    lazy var fullName = ""
    lazy var heightFeet:Int = 0
    lazy var heightInch:Int = 0
    lazy var iD :Int = 0
    lazy var lastName = ""
    lazy var middleName = ""
    lazy var notes = ""
    lazy var operatorID:Int = 0
    lazy var operatorName = ""
    lazy var weight:Int = 0
    lazy var isDefault:Bool = false

    
    func initWithDictionary(dictionary:[String : JSON]) -> OccupantListModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[AccessoryTypeID]?.intValue {
            accessoryTypeID = item3
        }

        if let item4 = dictionary[DeviceStyle]?.stringValue {
            deviceStyle = item4
        }

        if let item5 = dictionary[FirstName]?.stringValue {
            firstName = item5
        }

        if let item6 = dictionary[DeviceTypeID]?.intValue {
            deviceTypeID = item6
        }

        if let item7 = dictionary[IsDefault]?.boolValue {
            isDefault  = item7
        }
        
        if let item8 = dictionary[HeightFeet]?.intValue {
            heightFeet = item8
        }
        if let item9 = dictionary[FullName]?.stringValue {
            fullName = item9
        }
        if let item10 = dictionary[OperatorName]?.stringValue {
                operatorName = item10
        }
        if let item11 = dictionary[HeightInch]?.intValue {
                heightInch = item11
        }
        if let item12 = dictionary[ID]?.intValue {
            iD = item12
        }
        if let item13 = dictionary[LastName]?.stringValue {
            lastName = item13
        }
        if let item14 = dictionary[MiddleName]?.stringValue {
            middleName = item14
        }
        if let item15 = dictionary[Notes]?.stringValue {
            notes = item15
        }
        if let item16 = dictionary[OperatorID]?.intValue {
            operatorID = item16
        }
        if let item17 = dictionary[OperatorName]?.stringValue {
            operatorName = item17
        }

        if let item18 = dictionary[Weight]?.intValue {
            weight = item18
        }
        return self

        
    }


    
    
    

    
    
    
}




