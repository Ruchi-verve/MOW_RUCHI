//
//  OperatorListModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 13/08/21.
//

import Foundation
import SwiftyJSON


class OperatorListModel:NSObject {
    let Arr_Operator = "listOperator"
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"

    
    lazy var arrOperatorList = [OperatorListSubRes]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    
    
    func initWithDictionary(dictionary:[String : JSON]) -> OperatorListModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let jsonArr = dictionary[Arr_Operator]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = OperatorListSubRes().initWithDictionary(dictionary: objDic!)
                arrOperatorList.append(user)
            }
        }
        return self

        
    }
    
}

class OperatorListSubRes:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let AccessoryTypeID = "AccessoryTypeID"
    let CustomerId = "CustomerId"
    let DOB = "DOB"
    let EmailId = "EmailId"
    let ExpiryDate = "ExpiryDate"
    let FirstName = "FirstName"
    let FileName = "FileName"
    let ID = "ID"
    let LastName = "LastName"
    let MiddleName = "MiddleName"
    let HeightFeet = "HeightFeet"
    let HeightInch = "HeightInch"
    let IsDefaultOccupant = "IsDefaultOccupant"
    let LicenceNo = "LicenceNo"
    let Notes = "Notes"
    let OccupantID = "OccupantID"
    let OperatorCellNumber = "OperatorCellNumber"
    let OperatorHomeNumber = "OperatorHomeNumber"
    let OperatorID = "OperatorID"
    let OperatorIDOccupantID = "OperatorIDOccupantID"
    let Weight = "Weight"
    let IsDefault = "isDefault"
    let IsSame = "IsSame"
    let FullName = "FullName"

    
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var accessoryTypeID:Int = 0
    lazy var customerId:Int = 0
    lazy var dOB = ""
    lazy var emailId = ""
    lazy var expiryDate = ""
    lazy var firstName = ""
    lazy var fileName = ""
    lazy var iD :Int = 0
    lazy var lastName = ""
    lazy var middleName = ""
    lazy var heightFeet:Int = 0
    lazy var heightInch:Int = 0
    lazy var isDefaultOccupant:Bool = false
    lazy var licenceNo:String = ""
    lazy var notes = ""
    lazy var occupantID:Int = 0
    lazy var operatorCellNumber = ""
    lazy var operatorHomeNumber = ""
    lazy var operatorID:Int = 0
    lazy var operatorIDOccupantID:Int = 0
    lazy var weight:Int = 0
    lazy var isDefault:Bool = false
    lazy var isSame:Int = 0
    lazy var fullName = ""

    
    func initWithDictionary(dictionary:[String : JSON]) -> OperatorListSubRes {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item1 = dictionary[FileName]?.stringValue {
            fileName = item1
        }
        if let item3 = dictionary[AccessoryTypeID]?.intValue {
            accessoryTypeID = item3
        }

        if let item4 = dictionary[CustomerId]?.intValue {
            customerId = item4
        }

        if let item5 = dictionary[DOB]?.stringValue {
            dOB = item5
        }

        if let item6 = dictionary[EmailId]?.stringValue {
            emailId = item6
        }

        if let item7 = dictionary[ExpiryDate]?.stringValue {
                expiryDate  = item7
        }
        
        if let item8 = dictionary[FirstName]?.stringValue {
                firstName = item8
        }
        if let item9 = dictionary[MiddleName]?.stringValue {
                middleName = item9
        }
        if let item10 = dictionary[LastName]?.stringValue {
                lastName = item10
        }
        if let item11 = dictionary[ID]?.intValue {
                iD = item11
        }
        if let item12 = dictionary[HeightFeet]?.intValue {
                heightFeet = item12
        }
        if let item13 = dictionary[HeightInch]?.intValue {
            heightInch = item13
        }
        if let item14 = dictionary[IsDefaultOccupant]?.boolValue {
            isDefaultOccupant = item14
        }
        if let item15 = dictionary[LicenceNo]?.stringValue {
            licenceNo = item15
        }
        if let item16 = dictionary[Notes]?.stringValue {
            notes = item16
        }
        if let item17 = dictionary[OccupantID]?.intValue {
            occupantID = item17
        }
        if let item18 = dictionary[OperatorCellNumber]?.stringValue {
            operatorCellNumber = item18
        }
        if let item19 = dictionary[OperatorHomeNumber]?.stringValue {
            operatorHomeNumber = item19
        }
        if let item20 = dictionary[OperatorID]?.intValue {
            operatorID = item20
        }
        if let item21 = dictionary[OperatorIDOccupantID]?.intValue {
            operatorIDOccupantID = item21
        }
        if let item22 = dictionary[Weight]?.intValue {
           weight = item22
        }

        if let item23 = dictionary[IsDefault]?.boolValue {
           isDefault = item23
        }
        if let item24 = dictionary[FullName]?.stringValue {
           fullName = item24
        }
        return self
    }
    
}





