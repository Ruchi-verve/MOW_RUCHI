//
//  StateListModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 11/08/21.
//

import Foundation
import SwiftyJSON


class StateListModel:NSObject {
    let Arr_State = "listState"
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"

    
    lazy var arrState = [StateSubListModel]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    
    
    func initWithDictionary(dictionary:[String : JSON]) -> StateListModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let jsonArr = dictionary[Arr_State]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = StateSubListModel().initWithDictionary(dictionary: objDic!)
                arrState.append(user)
            }
        }
        return self

        
    }

    

    
}





