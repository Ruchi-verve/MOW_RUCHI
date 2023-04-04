//
//  StateSubListModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 11/08/21.
//

import Foundation
import SwiftyJSON


class StateSubListModel:NSObject {
    
    let Abbreviation            = "Abbreviation"
    let ID                     = "ID"
    let StateName               = "StateName"
   
    lazy var abbreviation = ""
    lazy var id:Int           = 0
    lazy var stateName         = ""

    func initWithDictionary(dictionary:[String : JSON]) -> StateSubListModel {
        
        if let item = dictionary[Abbreviation]?.stringValue {
            abbreviation = item
        }
        if let item5 = dictionary[ID]?.intValue {
            id = item5
        }
        
        if let item6 = dictionary[StateName]?.stringValue {
            stateName = item6
        }
        
        
        return self
    }

    
    
}


