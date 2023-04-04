//
//  DestinationResModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 06/08/21.
//

import Foundation
import SwiftyJSON

class DestinationResModel:NSObject {
    let Arr_Location = "ListLocation"
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let ARR_CAT_WITH_OBJ = "ARR_CAT_WITH_OBJ"

    
    lazy var arrLocation = [DestResSubModel]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var arrCatWithObj = [String:[DestResSubModel]]()

    func initWithDictionary(dictionary:[String : JSON]) -> DestinationResModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        
        if let jsonArr = dictionary[Arr_Location]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = DestResSubModel().initWithDictionary(dictionary: objDic!)
                arrLocation.append(user)
            }
        }
        if arrLocation.count > 0 {
            let groupByCategory = Dictionary(grouping: arrLocation) { (device) -> String in
                return device.locationCategoryName
            }
            arrCatWithObj = groupByCategory
        }

        return self

        
    }

    

    
}








/*
 
 "ErrorMessage": null,
     "Message": "",
     "StatusCode": "OK",
     "ListLocation": [
         {
             "ErrorMessage": null,
             "Message": null,
             "StatusCode": null,
             "DeliveryFee": 0,
             "ID": 3,
             "IsDistinctLocationCategory": true,
             "IsGenerateAcceptBonusDay": false,
             "IsTwentyFourBySevenAvailability": false,
             "LocationCategoryName": "Atlantic City Casinos",
             "LocationName": "Bally's AC",
             "TaxRate": 0
         },
         {
             "ErrorMessage": null,
             "Message": null,
             "StatusCode": null,
             "DeliveryFee": 0,
             "ID": 14,
             "IsDistinctLocationCategory": false,
             "IsGenerateAcceptBonusDay": false,
             "IsTwentyFourBySevenAvailability": false,
             "LocationCategoryName": "Atlantic City Casinos",
             "LocationName": "Borgata",
             "TaxRate": 0
         },
 
 
 
 */
