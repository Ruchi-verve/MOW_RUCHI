//
//  GetBillingPriceModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 17/08/21.
//

import Foundation
import SwiftyJSON



class BillingPriceModel:NSObject {
    let Message  = "Message"
    let BillingProfileID = "BillingProfileID"
    let Description = "Description"
    let RegularPrice = "RegularPrice"
    let Result = "Result"
    let RewardPoint = "RewardPoint"
    let SecondNdTripPrice = "SecondNdTripPrice"
    let TotalPrice = "TotalPrice"
    

        
    lazy var message = ""
    lazy var billingProfileID:Int = 0
    lazy var shortDescription = ""
    lazy var regularPrice:Float = 0.0
    lazy var result:Bool = false
    lazy var rewardPoint:Int = 0
    lazy var secondNdTripPrice:Float = 0.0
    lazy var totalPrice:Float = 0.0

    
    func initWithDictionary(dictionary:[String : JSON]) -> BillingPriceModel {
        
        if let item = dictionary[Message]?.stringValue {
            message = item
        }
        
        if let item1 = dictionary[Description]?.stringValue {
            shortDescription = item1
        }

        if let item2 = dictionary[RegularPrice]?.floatValue {
            regularPrice = item2
        }
        
        if let item3 = dictionary[BillingProfileID]?.intValue {
            billingProfileID = item3
        }

        if let item5 = dictionary[Result]?.boolValue {
            result = item5
        }

        if let item6 = dictionary[SecondNdTripPrice]?.floatValue {
            secondNdTripPrice = item6
        }

        if let item7 = dictionary[TotalPrice]?.floatValue {
            totalPrice  = item7
        }
        if let item8 = dictionary[RewardPoint]?.intValue {
            rewardPoint = item8
        }


        return self

        
    }

    

    
}

