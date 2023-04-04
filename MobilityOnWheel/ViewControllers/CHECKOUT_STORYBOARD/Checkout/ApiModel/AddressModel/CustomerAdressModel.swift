//
//  CustomerAdressModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 23/08/21.
//

import Foundation
import SwiftyJSON

class CustomerAdressModel:NSObject {
    
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let BillAddress1 = "BillAddress1"
    let BillAddress2 = "BillAddress2"
    let BillCity = "BillCity"
    let BillStateID = "BillStateID"
    let BillZip = "BillZip"
    let FirstName = "FirstName"
    let CustomerID = "CustomerID"
    let LastName = "LastName"
    let AlternateName = "AlternateName"
    let MiddleName = "MiddleName"
    let DOB = "DOB"
    let CellNumber = "CellNumber"
    let Country = "Country"
    let Email = "Email"
    let ExpiryDate = "ExpiryDate"
    let FileName = "FileName"
    let FullName = "FullName"
    let HomeNumber = "HomeNumber"
    let IsBlacklisted = "IsBlacklisted"
    let LicenseNo = "LicenseNo"
    let Notes = "Notes"
    let OperatorList = "OperatorList"
    let OtherBillStateName = "OtherBillStateName"
    let RewardTurn = "RewardTurn"
    let RewardsPoint = "RewardsPoint"
    let StateName = "StateName"

    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var alternateName = ""
    lazy var billAddress1 = ""
    lazy var billAddress2   = ""
    lazy var billCity = ""
    lazy var billStateId:Int = 0
    lazy var billZip = ""
    lazy var cellNo = ""
    lazy var country = ""
    lazy var stateName = ""
    lazy var homeNo = ""
    lazy var customerId:Int = 0
    lazy var dob = ""
    lazy var email = ""
    lazy var expDate = ""
    lazy var fileName = ""
    lazy var fullName = ""
    lazy var firstName = ""
    lazy var lastName = ""
    lazy var middleName = ""
    lazy var isblackListed:Bool = false
    lazy var licenseNo = ""
    lazy var notes = ""
    lazy var arrOperatorList = [OperatorListSubRes]()
    lazy var otherBillStateName = ""
    lazy var rewardTurn:Bool = false
    lazy var rewardPoints:Int = 0

    func initWithDictionary(dictionary:[String : JSON]) -> CustomerAdressModel {
        
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[FirstName]?.stringValue {
            firstName = item3
        }
        if let item4 = dictionary[LastName]?.stringValue {
            lastName = item4
        }
        if let item5 = dictionary[MiddleName]?.stringValue {
            middleName = item5
        }
        
        if let item6 = dictionary[FullName]?.stringValue {
            fullName = item6
        }
        
        if let item7 = dictionary[StateName]?.stringValue {
            stateName = item7
        }
        if let item8 = dictionary[ExpiryDate]?.stringValue {
            expDate = item8
        }
        if let item9 = dictionary[CustomerID]?.intValue {
            customerId = item9
        }
        if let item10 = dictionary[CellNumber]?.stringValue {
            cellNo = item10
        }
        if let item11 = dictionary[HomeNumber]?.stringValue {
            homeNo = item11
        }
        if let item12 = dictionary[BillAddress1]?.stringValue {
            billAddress1 = item12
        }
        if let item13 = dictionary[BillAddress2]?.stringValue {
            billAddress2 = item13
        }
        if let item14 = dictionary[FileName]?.stringValue {
            fileName = item14
        }
        if let item15 = dictionary[LicenseNo]?.stringValue {
            licenseNo = item15
        }
        if let item16 = dictionary[Notes]?.stringValue {
            notes = item16
        }
        if let item17 = dictionary[IsBlacklisted]?.boolValue {
            isblackListed = item17
        }
        if let item18 = dictionary[OtherBillStateName]?.stringValue {
            otherBillStateName = item18
        }
        if let item19 = dictionary[RewardTurn]?.boolValue {
            rewardTurn = item19
        }
        if let item20 = dictionary[RewardsPoint]?.intValue {
            rewardPoints = item20
        }
        if let item21 = dictionary[DOB]?.stringValue {
            dob = item21
        }
        if let item22 = dictionary[Email]?.stringValue {
           email = item22
        }

        if let item23 = dictionary[BillZip]?.stringValue {
            billZip = item23
        }
        if let item24 = dictionary[BillStateID]?.intValue {
            billStateId = item24
        }
        if let item25 = dictionary[BillCity]?.stringValue {
            billCity = item25
        }
        if let item26 = dictionary[Country]?.stringValue {
            country = item26
        }
        if let item27 = dictionary[AlternateName]?.stringValue {
            alternateName = item27
        }

        if let jsonArr = dictionary[OperatorList]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = OperatorListSubRes().initWithDictionary(dictionary: objDic!)
                arrOperatorList.append(user)
            }
        }

        return self
    }

    
    
}

