//
//  SameDayReserModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 24/08/21.
//

import Foundation
import SwiftyJSON

class SameDayReserModel:NSObject {
    let Message  = "Message"
    let Day = "Day"
    let EndTime = "EndTime"
    let StartTime = "StartTime"
    let StatusCode  = "StatusCode"
    let ErrorMessage  = "ErrorMessage"
    let DeviceTypeId = "DeviceTypeId"
    let LocationId = "LocationId"
    let ID = "ID"


        
    lazy var deviceTypeId:Int = 0
    lazy var iD:Int = 0
    lazy var locationID:Int = 0
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var day = ""
    lazy var endTime = ""
    lazy var startTime = ""

    
    func initWithDictionary(dictionary:[String : JSON]) -> SameDayReserModel {
        
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[DeviceTypeId]?.intValue {
            deviceTypeId = item3
        }

        if let item4 = dictionary[LocationId]?.intValue {
            locationID = item4
        }
        
        if let item5 = dictionary[ID]?.intValue {
            iD = item5
        }

        if let item6 = dictionary[StartTime]?.stringValue {
            startTime = item6
        }

        if let item7 = dictionary[EndTime]?.stringValue {
            endTime = item7
        }

        if let item8 = dictionary[Day]?.stringValue {
            day  = item8
        }


        return self

        
    }

    

    
}


