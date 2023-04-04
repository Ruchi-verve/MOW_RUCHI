//
//  RentalRate.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 10/08/21.
//

import Foundation
import SwiftyJSON

class RentalRateRes:NSObject {
    let Arr_RentalRate = "ListRentalPriceTag"
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"

    
    lazy var arrRentalRate = [JSON]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    
    
    func initWithDictionary(dictionary:[String : JSON]) -> RentalRateRes {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        
        if let jsonArr = dictionary[Arr_RentalRate]?.array {
            arrRentalRate.append(contentsOf: jsonArr)
        }
        return self

        
    }

    

    
}
