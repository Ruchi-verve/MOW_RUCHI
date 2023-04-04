//
//  DeviceTypeSubResModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 09/08/21.
//

import Foundation
import SwiftyJSON


class DeviceTypeSubResModel:NSObject {
    

    let COMP_PRICE_DESCRIPTION           = "CompPriceDescription"
    let DEVICE_TYPE_ID           = "DeviceTypeID"
    let INVENTORY_ID        = "InventoryID"
    let ITEM_IMAGE_PATH         = "ItemImagePath"
    let ITEM_NAME = "ItemName"
    let REGULAR_PRICE_DESCRIPTION = "RegularPriceDescription"

        lazy var CompPriceDescription = ""
        lazy var DeviceTypeID:Int = 0
    lazy var InventoryID:Int  = 0
        lazy var ItemImagePath = ""
        lazy var ItemName = ""
        lazy var RegularPriceDescription = ""
    
    func initWithDictionary(dictionary:[String : JSON]) -> DeviceTypeSubResModel {
        
        
        if let item1 = dictionary[COMP_PRICE_DESCRIPTION]?.stringValue {
            CompPriceDescription = item1
        }
        
        if let item2 = dictionary[DEVICE_TYPE_ID]?.intValue {
            DeviceTypeID = item2
        }
        
        if let item3 = dictionary[INVENTORY_ID]?.intValue {
            InventoryID = item3
        }
        
        if let item4 = dictionary[ITEM_IMAGE_PATH]?.stringValue {
            ItemImagePath = item4
        }
        
        if let item5 = dictionary[ITEM_NAME]?.stringValue {
            ItemName = item5
        }
        
        if let item6 = dictionary[REGULAR_PRICE_DESCRIPTION]?.stringValue {
            RegularPriceDescription = item6
        }
        
        return self
}

}

