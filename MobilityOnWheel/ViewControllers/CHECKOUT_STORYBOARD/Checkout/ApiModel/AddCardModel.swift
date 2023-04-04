//
//  AddCardModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 10/08/21.
//

import Foundation
import SwiftyJSON


class AddCardModel:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let Address1 = "Address1"
    let Address2 = "Address2"
    let CardExpDate = "CardExpDate"
    let CardNumber = "CardNumber"
    let CardType = "CardType"
    let FirstName = "FirstName"
    let ID = "ID"
    let LastName = "LastName"
    let MiddleName = "MiddleName"
    let Phone = "Phone"
    let DDlItem = "ddlItem"
    
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var address1 = ""
    lazy var address2 = ""
    lazy var cardExpDate = ""
    lazy var cardNumber = ""
    lazy var cardType = ""
    lazy var firstName = ""
    lazy var iD :Int = 0
    lazy var lastName = ""
    lazy var middleName = ""
    lazy var phone = ""
    lazy var ddlItem = ""

    
    func initWithDictionary(dictionary:[String : JSON]) -> AddCardModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[Address1]?.stringValue {
            address1 = item3
        }

        if let item4 = dictionary[Address2]?.stringValue {
            address2 = item4
        }

        if let item5 = dictionary[CardExpDate]?.stringValue {
            cardExpDate = item5
        }

        if let item6 = dictionary[CardNumber]?.stringValue {
            cardNumber = item6
        }

        if let item7 = dictionary[CardType]?.stringValue {
                cardType  = item7
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
        if let item12 = dictionary[Phone]?.stringValue {
                phone = item12
        }
        if let item13 = dictionary[DDlItem]?.stringValue {
            ddlItem = item13
        }

        
        return self

        
    }

    

    
}





