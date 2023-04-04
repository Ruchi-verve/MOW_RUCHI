//
//  OperatorOccupantInfo.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 16/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import Foundation
import SwiftyJSON

class OperatorOccupantInfoModel:NSObject {
    let DefineOccupant  = "DefineOccupant"
    let DefineOperator  = "DefineOperator"
    
    lazy var defineOperator = ""
    lazy var defineOccupant = ""

    
    func initWithDictionary(dictionary:[String : JSON]) -> OperatorOccupantInfoModel {
        
        if let item = dictionary[DefineOccupant]?.stringValue {
            defineOccupant = item
        }
        
        if let item1 = dictionary[DefineOperator]?.stringValue {
            defineOperator = item1
        }
        return self
    }

        
    }

