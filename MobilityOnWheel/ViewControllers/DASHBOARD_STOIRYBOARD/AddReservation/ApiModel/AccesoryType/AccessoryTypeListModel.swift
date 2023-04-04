//
//  AccessoryTypeListModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 13/08/21.
//

import Foundation
import SwiftyJSON



class AccessoryTypeListModel:NSObject {
    let Arr_Accessory = "ListAccessory"
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"

    
    lazy var arrAccesoryList = [AccessoryTypeSubRes]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    
    
    func initWithDictionary(dictionary:[String : JSON]) -> AccessoryTypeListModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        
        if let jsonArr = dictionary[Arr_Accessory]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = AccessoryTypeSubRes().initWithDictionary(dictionary: objDic!)
                arrAccesoryList.append(user)
            }
        }
        return self
    }
    
}

class AccessoryTypeSubRes:NSObject {
    let AccessoryTypeName  = "AccessoryTypeName"
    let ID = "ID"

    
    lazy var accessoryTypeName = ""
    lazy var iD :Int = 0
    
    func initWithDictionary(dictionary:[String : JSON]) -> AccessoryTypeSubRes {
        
        if let item = dictionary[AccessoryTypeName]?.stringValue {
            accessoryTypeName = item
        }
        
        if let item1 = dictionary[ID]?.intValue {
            iD = item1
        }


        return self

        
    }

    

    
}

