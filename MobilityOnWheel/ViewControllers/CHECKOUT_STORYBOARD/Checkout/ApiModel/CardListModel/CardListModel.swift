//
//  CardListModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 18/08/21.
//

import Foundation
import SwiftyJSON

class CardListModel:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let Arr_CardList = "listAuthorizePayment"
    
    lazy var arrCardList = [CardListSubModel]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    
    func initWithDictionary(dictionary:[String : JSON]) -> CardListModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }

        
        if let jsonArr = dictionary[Arr_CardList]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = CardListSubModel().initWithDictionary(dictionary: objDic!)
                arrCardList.append(user)
            }
        }
        return self

        
    }

    

    
}


class CardListSubModel:NSObject {
    
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
    let DDItem = "ddlItem"
    let IsSel = "isSel"

    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var cardExpDate  = ""
    lazy var cardType  = ""
    lazy var cardNumber = ""
    lazy var iD:Int        = 0
    lazy var firstName = ""
    lazy var address1 = ""
    lazy var address2 = ""
    lazy var lastName = ""
    lazy var middleName = ""
    lazy var phone = ""
    lazy var ddItem = ""
    lazy var isSel  = "0"

    func initWithDictionary(dictionary:[String : JSON]) -> CardListSubModel {
        
        
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
        
        if let item6 = dictionary[CardType]?.stringValue {
            cardType = item6
        }
        
        if let item7 = dictionary[CardNumber]?.stringValue {
            cardNumber = item7
        }
        if let item8 = dictionary[CardExpDate]?.stringValue {
            cardExpDate = item8
        }
        if let item9 = dictionary[ID]?.intValue {
            iD = item9
        }
        if let item10 = dictionary[phone]?.stringValue {
            phone = item10
        }
        if let item11 = dictionary[DDItem]?.stringValue {
            ddItem = item11
        }
        if let item12 = dictionary[Address1]?.stringValue {
            address1 = item12
        }
        if let item13 = dictionary[Address2]?.stringValue {
            address2 = item13
        }
        
        if let item14 = dictionary[IsSel]?.stringValue {
            isSel = item14
        }

        return self
    }

    
    
}


