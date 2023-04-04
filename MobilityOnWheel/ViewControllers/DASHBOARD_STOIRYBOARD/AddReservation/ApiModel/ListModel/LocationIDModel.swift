//
//  LocationIDModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 25/08/21.
//

import Foundation
import SwiftyJSON

class LocationIDModel:NSObject {
    let Message  = "Message"
    let StatusCode  = "StatusCode"
    let ErrorMessage  = "ErrorMessage"
    let ID = "ID"
    let DeliveryFee = "DeliveryFee"
    let IsDistinctLocationCategory = "IsDistinctLocationCategory"
    let IsGenerateAcceptBonusDay = "IsGenerateAcceptBonusDay"
    let IsTwentyFourBySevenAvailability = "IsTwentyFourBySevenAvailability"
    let LocationCategoryName     = "LocationCategoryName"
    let LocationName             = "LocationName"
    let TaxRate                  = "TaxRate"

    

    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var deliveryfee:Float   = 0
    lazy var isGenerateAcceptBonusDay:Bool      = false
    lazy var isTwentyFourBySevenAvailability:Bool = false
    lazy var isDistinctLocationCategory:Bool = false
    lazy var locationCategoryName  =  ""
    lazy var locationName            = ""
    lazy var taxRate:Float        = 0
    lazy var iD:Int = 0

        

    
    func initWithDictionary(dictionary:[String : JSON]) -> LocationIDModel {
        
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[IsDistinctLocationCategory]?.boolValue {
            isDistinctLocationCategory = item3
        }

        if let item4 = dictionary[DeliveryFee]?.floatValue {
            deliveryfee = item4
        }

        if let item5 = dictionary[IsGenerateAcceptBonusDay]?.boolValue {
            isGenerateAcceptBonusDay = item5
        }
        
        if let item6 = dictionary[IsTwentyFourBySevenAvailability]?.boolValue {
            isTwentyFourBySevenAvailability = item6
        }

        
        if let item7 = dictionary[ID]?.intValue {
            iD = item7
        }

        if let item8 = dictionary[LocationCategoryName]?.stringValue {
            locationCategoryName = item8
        }
        if let item9 = dictionary[LocationName]?.stringValue {
            locationName = item9
        }
        
        if let item10 = dictionary[TaxRate]?.floatValue {
            taxRate = item10
        }


        return self

        
    }

    

    
}


