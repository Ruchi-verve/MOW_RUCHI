//
//  DestResSubModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 06/08/21.
//

import Foundation
import SwiftyJSON

class DestResSubModel:NSObject {
    
    let Error_Message            = "ErrorMessage"
    let Message                     = "Message"
    let Status_Code                  = "StatusCode"
    let Delivery_Fee                  = "DeliveryFee"
    let ID                         = "ID"
    let Is_Distinct_LocationCategory = "IsDistinctLocationCategory"
    let Is_Generate_AcceptBonusDay = "IsGenerateAcceptBonusDay"
    let Is_TwentyFourBySeven_Availability = "IsTwentyFourBySevenAvailability"
    let Location_CategoryName     = "LocationCategoryName"
    let Location_Name             = "LocationName"
    let Tax_Rate                  = "TaxRate"
    let IS_Sel                  = "isSel"

    lazy var errormessage = ""
    lazy var message            = ""
    lazy var statuscode         = ""
    lazy var deliveryfee:Float   = 0
    lazy var id:Int               = 0
    lazy var isdistinctLocationCategory:Bool = false
    lazy var isgenerateAcceptBonusDay:Bool      = false
    lazy var istwentyFourBySevenAvailability:Bool = false
    lazy var locationCategoryName  =  ""
    lazy var locationName            = ""
    lazy var taxRate:Float        = 0
    lazy var isSel:Int        = 0

    func initWithDictionary(dictionary:[String : JSON]) -> DestResSubModel {
        
        if let item = dictionary[IS_Sel]?.intValue {
            isSel = item
        }

        
        if let item1 = dictionary[Error_Message]?.stringValue {
            errormessage = item1
        }
        
        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[Status_Code]?.stringValue {
            statuscode = item3
        }
        
        if let item4 = dictionary[Delivery_Fee]?.floatValue {
            deliveryfee = item4
        }
        
        if let item5 = dictionary[ID]?.intValue {
            id = item5
        }
        
        if let item6 = dictionary[Is_Distinct_LocationCategory]?.boolValue {
            isdistinctLocationCategory = item6
        }
        
        if let item7 = dictionary[Is_Generate_AcceptBonusDay]?.boolValue {
            isgenerateAcceptBonusDay = item7
        }
        
        if let item8 = dictionary[Is_TwentyFourBySeven_Availability]?.boolValue {
            istwentyFourBySevenAvailability = item8
        }
        if let item9 = dictionary[Location_CategoryName]?.stringValue {
            locationCategoryName = item9
        }
        if let item10 = dictionary[Location_Name]?.stringValue {
            locationName = item10
        }
        
        if let item18 = dictionary[Tax_Rate]?.floatValue {
            taxRate = item18
        }
        
        return self
    }

    
    
}

