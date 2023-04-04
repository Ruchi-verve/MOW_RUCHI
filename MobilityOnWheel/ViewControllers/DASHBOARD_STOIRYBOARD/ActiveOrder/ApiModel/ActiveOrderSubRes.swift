//
//  ActiveOrderSubRes.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 06/08/21.
//

import Foundation
import SwiftyJSON


class ActiveOrderSubRes:NSObject {
    
    let Battery_Level = "BatteryLevel"
    let ARRIVAL_DATE            = "ArrivalDate"
    let DEPATURE_DATE           = "DepartureDate"
    let DEVICE_TYPE_NAME        = "DeviceTypeName"
    let EMVID                  = "EMVID"
    let FORMATED_ORDER_ID         = "FormatedOrderID"
    let IS_GPS_ENABLED = "IsGPSEnabled"
    let LOCATION_NAME = "LocationName"
    let ORDER_ID =   "OrderID"
    let PROFILE_PRICE = "ProfilePrice"
    let RATE_SELECTED = "RateSelected"
    let REMAINING_TIME = "RemainingTime"
    let SHADOW_PIN_DEVICE_UNIQUE_ID  = "ShadowPinDeviceUniqueID"
let imgPath = "DeviceImagePath"
        lazy var ArrivalDate = ""
        lazy var DepartureDate = ""
        lazy var DeviceTypeName  = ""
    lazy var emvId = ""
    lazy var batt_level =  ""

        lazy var FormatedOrderID = ""
        lazy var IsGPSEnabled:Bool = false
        lazy var LocationName = ""
        lazy var OrderID:Int = 0
        lazy var ProfilePrice:Float = 0
        lazy var RateSelected  = ""
        lazy var RemainingTime = ""
        lazy var ShadowPinDeviceUniqueID:Int = 0
    lazy var ImagPath = ""

    func initWithDictionary(dictionary:[String : JSON]) -> ActiveOrderSubRes {
        

        
        if let item1 = dictionary[ARRIVAL_DATE]?.stringValue {
            ArrivalDate = item1
        }
        
        if let item2 = dictionary[DEPATURE_DATE]?.stringValue {
            DepartureDate = item2
        }
        
        if let item3 = dictionary[DEVICE_TYPE_NAME]?.stringValue {
            DeviceTypeName = item3
        }
        
        if let item4 = dictionary[EMVID]?.stringValue {
            emvId = item4
        }
        
        if let item5 = dictionary[FORMATED_ORDER_ID]?.stringValue {
            FormatedOrderID = item5
        }
        
        if let item6 = dictionary[IS_GPS_ENABLED]?.boolValue {
            IsGPSEnabled = item6
        }
        if let item6 = dictionary[imgPath]?.stringValue {
            ImagPath = item6
        }

        if let item7 = dictionary[LOCATION_NAME]?.stringValue {
            LocationName = item7
        }
        
        if let item8 = dictionary[ORDER_ID]?.intValue {
            OrderID = item8
        }
        if let item9 = dictionary[PROFILE_PRICE]?.floatValue {
            ProfilePrice = item9
        }
        if let item10 = dictionary[RATE_SELECTED]?.stringValue {
            RateSelected = item10
        }
        
        if let item11 = dictionary[REMAINING_TIME]?.stringValue {
            RemainingTime = item11
        }
        
        if let item11 = dictionary[Battery_Level]?.stringValue {
            batt_level = item11
        }

        if let item12 = dictionary[SHADOW_PIN_DEVICE_UNIQUE_ID]?.intValue {
            ShadowPinDeviceUniqueID = item12
            
        }
        return self
}

}

