//
//  SameOccupantModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 27/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import Foundation
import SwiftyJSON

class SameOccupantModel:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let SelectedOccupant = "SelectedOccupant"
    let ARR_OccupantMapper = "occupantMapper"

    
    lazy var errorMessage = ""
    lazy var message = ""
    lazy var statusCode = ""
    lazy var selectedOccupant:Int = 0
    lazy var arrOccupantMapper = [OccupantListModel]()

    
    func initWithDictionary(dictionary:[String : JSON]) -> SameOccupantModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[SelectedOccupant]?.intValue {
            selectedOccupant = item3
        }

        if let jsonArr = dictionary[ARR_OccupantMapper]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = OccupantListModel().initWithDictionary(dictionary: objDic!)
                arrOccupantMapper.append(user)
            }
        }

        return self
    }
}





