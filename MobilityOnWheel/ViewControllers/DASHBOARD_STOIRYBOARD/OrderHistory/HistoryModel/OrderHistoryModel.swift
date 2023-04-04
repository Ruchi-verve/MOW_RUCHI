//
//  OrderHistoryModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 09/08/21.
//

import Foundation
import SwiftyJSON
class OrderHistoryModel:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let userRewardsPoint = "UserRewardsPoint"
    let Arr_OrderHistories = "orderHistories"
    
    lazy var arrHistory = [OrderHistorySubResModel]()
    lazy var statusCode = ""
    lazy var message = ""
    lazy var errorMessage = ""
    lazy var rewardPoints:Int = 0

    
    func initWithDictionary(dictionary:[String : JSON]) -> OrderHistoryModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        if let item3 = dictionary[userRewardsPoint]?.intValue {
            rewardPoints = item3
        }

        
        if let jsonArr = dictionary[Arr_OrderHistories]?.array {
            for i in 0 ..< jsonArr.count {
                let objDic = jsonArr[i].dictionary
                let user = OrderHistorySubResModel().initWithDictionary(dictionary: objDic!)
                arrHistory.append(user)
            }
        }
        return self

        
    }

    

    
}
