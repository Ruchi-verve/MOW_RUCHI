//
//  ExistingOccupantVC.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 21/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import Foundation
import SwiftyJSON


class ExistingOccupantModel:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let CustomerID = "CustomerID"
    let CustomerName = "CustomerName"
    let OccupantID = "OccupantID"
    let OperatorID = "OperatorID"
    let OperatorName = "OperatorName"
    let OccupantName = "OccupantName"
    let IsSelect = "IsSelect"

    
    lazy var errorMessage = ""
    lazy var message = ""
    lazy var statusCode = ""
    lazy var customerID :Int = 0
    lazy var customerName = ""
    lazy var occupantName = ""
    lazy var occupantID:Int = 0
    lazy var operatorID:Int = 0
    lazy var operatorName = ""
    lazy var isSelect:Int = 0

    
    func initWithDictionary(dictionary:[String : JSON]) -> ExistingOccupantModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[CustomerID]?.intValue {
            customerID = item3
        }

        if let item4 = dictionary[CustomerName]?.stringValue {
            customerName = item4
        }

        if let item5 = dictionary[OccupantName]?.stringValue {
            occupantName = item5
        }

        if let item6 = dictionary[OccupantID]?.intValue {
            occupantID = item6
        }

        if let item16 = dictionary[OperatorID]?.intValue {
            operatorID = item16
        }
        if let item17 = dictionary[OperatorName]?.stringValue {
            operatorName = item17
        }
        
        
        return self

        
    }


    
    
    

    
    
    
}




