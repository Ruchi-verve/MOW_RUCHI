//
//  DevicePropertyOptionsModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 23/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import Foundation
import SwiftyJSON

class DevicePropertyOptionsModel:NSObject {
    let Message  = "Message"
    let StatusCode  = "StatusCode"
    let ErrorMessage  = "ErrorMessage"
    let ARR_ListDevicePropertyOption = "listDevicePropertyOption"

    

    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var arrListDevicePropertyOption = [DevicePropertySubResModel]()

    func initWithDictionary(dictionary:[String : JSON]) -> DevicePropertyOptionsModel {
        
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        
        if let jsonArr = dictionary[ARR_ListDevicePropertyOption]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = DevicePropertySubResModel().initWithDictionary(dictionary: objDic!)
                arrListDevicePropertyOption.append(user)
            }
        }
        return self
    }

}


class DevicePropertySubResModel:NSObject {
    
    let Message  = "Message"
    let StatusCode  = "StatusCode"
    let ErrorMessage  = "ErrorMessage"
    let DevicePropertyID = "DevicePropertyID"
    let DevicePropertyOption = "DevicePropertyOption"
    let DevicePropertyOptionID = "DevicePropertyOptionID"
    let IsSelect = "IsSelect"

    
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var devicePropertyID:Int        = 0
    lazy var devicePropertyOption = ""
    lazy var devicePropertyOptionID:Int        = 0
    lazy var isSelect:Int        = 0

    
    func initWithDictionary(dictionary:[String : JSON]) -> DevicePropertySubResModel {
        
        if let item = dictionary[Message]?.stringValue {
            message = item
        }
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }
        if let item2 = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item2
        }
        if let item3 = dictionary[DevicePropertyID]?.intValue {
            devicePropertyID = item3
        }
        if let item4 = dictionary[DevicePropertyOptionID]?.intValue {
            devicePropertyOptionID = item4
        }
        if let item5 = dictionary[DevicePropertyOption]?.stringValue {
            devicePropertyOption = item5
        }

                return self
    }

    
    
}


