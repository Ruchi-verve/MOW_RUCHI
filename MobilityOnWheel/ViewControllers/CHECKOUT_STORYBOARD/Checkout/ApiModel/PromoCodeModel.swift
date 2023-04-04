//
//  PromoCodeModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 28/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import Foundation
import SwiftyJSON


class PromoCodeModel:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let PromotionFigure = "PromotionFigure"
    let PromotionID = "PromotionID"
    let PromotionType = "PromotionType"
    
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var promotionFigure :Float =  0
    lazy var promotionID :Int = 0
    lazy var promotionType:Bool = false

    
    func initWithDictionary(dictionary:[String : JSON]) -> PromoCodeModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[PromotionFigure]?.floatValue {
            promotionFigure = item3
        }

        if let item4 = dictionary[PromotionID]?.intValue {
            promotionID = item4
        }

        if let item5 = dictionary[PromotionType]?.boolValue {
            promotionType = item5
        }
        return self
    }
    
}


