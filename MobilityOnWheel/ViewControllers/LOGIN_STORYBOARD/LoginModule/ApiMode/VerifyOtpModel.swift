//
//  VerifyOtpModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 06/08/21.
//

import Foundation
import SwiftyJSON


class VerifyOtpModel:NSObject {
    let ErrorMessage =  "ErrorMessage"
    let Message =  "Message"
    let StatusCode =  "StatusCode"
    let AccountName = "AccountName"
    let AdminID = "AdminID"
    let FirstName = "FirstName"
    let CompanyEmail = "CompanyEmail"
    let CompanyID = "CompanyID"
    let RewardTurn = "RewardTurn"
    let ID = "ID"
    let InActive = "InActive"
    let LastName = "LastName"
    let MiddleName = "MiddleName"
    let OTP = "OTP"
    let Token = "Token"

    lazy var errormessage      =  ""
    lazy var message      =  ""
    lazy var statuscode      =  ""
    lazy var accountname      =  ""
    lazy var adminid:Int     =  0
    lazy var companyemail      =  ""
    lazy var companyid:Int      =  0
    lazy var firstname  = ""
    lazy var id:Int        =  0
    lazy var inactive:Bool = false
    lazy var lastname = ""
    lazy var middlename = ""
    lazy var token      =  ""
    lazy var otp        =  ""
    lazy var rewardturn:Bool  = false

    
    func initWithDictionary(dictionary:[String : JSON]) -> VerifyOtpModel {
        if let item = dictionary[ErrorMessage]?.stringValue {
            errormessage = item
        }
        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        if let item3 = dictionary[StatusCode]?.stringValue {
            statuscode = item3
        }
        if let item4 = dictionary[AccountName]?.stringValue {
            accountname = item4
        }
        if let item5 = dictionary[AdminID]?.intValue {
            adminid = item5
        }
        if let item6 = dictionary[CompanyEmail]?.stringValue {
            companyemail = item6
        }
        if let item7 = dictionary[CompanyID]?.intValue {
            companyid = item7
        }

        if let item8 = dictionary[FirstName]?.stringValue {
            firstname = item8
        }

        if let item9 = dictionary[ID]?.intValue {
            id = item9
        }

        if let item10 = dictionary[LastName]?.stringValue {
            lastname = item10
        }

        if let item11 = dictionary[InActive]?.boolValue {
            inactive = item11
        }

        if let item12 = dictionary[MiddleName]?.stringValue {
            middlename = item12
        }

        if let item13 = dictionary[OTP]?.stringValue {
            otp = item13
        }

        if let item14 = dictionary[RewardTurn]?.boolValue {
            rewardturn = item14
        }

        if let item15 = dictionary[Token]?.stringValue {
            token = item15
        }


        return self
    }


    
    
    
    
}

