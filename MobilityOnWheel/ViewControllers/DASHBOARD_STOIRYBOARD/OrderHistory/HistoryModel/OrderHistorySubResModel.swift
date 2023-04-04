
import Foundation
import SwiftyJSON


class OrderHistorySubResModel:NSObject {
    
    let arrivalDate = "ArrivalDate"
    let capturePaymentTransactionDate = "CapturePaymentTransactionDate"
    let cardExpDate = "CardExpDate"
    let cardLastFourDigit = "CardLastFourDigit"
    let cardTypeName = "CardTypeName"
    let cashTotal = "CashTotal"
    let createdDate = "CreatedDate"
    let creditTotal = "CreditTotal"
    let departureDate = "DepartureDate"
    let deviceTypeName = "DeviceTypeName"
    let eaid = "EAID"
    let equipmentOrderID = "EquipmentOrderID"
    let extensionNumber = "ExtensionNumber"
    let formatedOrderID = "FormatedOrderID"
    let isCompanyOrder = "IsCompanyOrder"
    let isCreditBilled = "IsCreditBilled"
    let isDeclined = "IsDeclined"
    let isDelete = "IsDelete"
    let isOnlineOrdered = "IsOnlineOrdered"
    let isPOCharged = "IsPOCharged"
    let isPrimaryOrder = "IsPrimaryOrder"
    let isRefundCash = "IsRefundCash"
    let isRefundCredit = "IsRefundCredit"
    let isReturnImageUploaded = "IsReturnImageUploaded"
    let isReturned = "IsReturned"
    let locationName = "LocationName"
    let operatorName = "OperatorName"
    let operatorOccupantName = "OperatorOccupantName"
    let operatorStatus = "OperatorStatus"
    let originalDepartureDate = "OriginalDepartureDate"
    let payorStatus = "PayorStatus"
    let primaryOrderID = "PrimaryOrderId"
    let recepientName = "RecepientName"
    let refundType = "RefundType"
    let resendAttenstationTo = "ResendAttestationTo"
    let isResendAttestationDisable = "IsResendAttestationDisable"
    let orderStatus = "OrderStatus"
    var operatorEleAttestationUrl = "operatorEleAttestationUrl"
    var payorEleAttestationUrl = "payorEleAttestationUrl"

    
    lazy var ArrivalDate = ""
    lazy var CapturePaymentTransactionDate            = ""
    lazy var CardExpDate         = ""
    lazy var CardLastFourDigit = ""
    lazy var CardTypeName  = ""
    lazy var CashTotal:Float = 0
    lazy var CreatedDate = ""
    lazy var CreditTotal:Float = 0
    lazy var DepartureDate  =  ""
    lazy var DeviceTypeName            = ""
    lazy var EAID:Int        = 0
    lazy var EquipmentOrderID:Int = 0
    lazy var ExtensionNumber:Int = 0
    lazy var FormatedOrderID = ""
    lazy var IsCompanyOrder:Bool = false
    lazy var IsCreditBilled:Bool = false
    lazy var IsDeclined :Bool = false
    lazy var IsDelete :Bool = false
    lazy var IsOnlineOrdered :Bool = false
    lazy var IsPOCharged :Bool = false
    lazy var IsPrimaryOrder :Bool = false
    lazy var IsRefundCash :Bool = false
    lazy var IsRefundCredit :Bool = false
    lazy var IsReturnImageUploaded :Bool = false
    lazy var IsReturned:Bool = false
    lazy var LocationName = ""
    lazy var OperatorName = ""
    lazy var OperatorOccupantName = ""
    lazy var OperatorStatus :Bool = false
    lazy var OriginalDepartureDate = ""
    lazy var PayorStatus :Bool? = nil
    lazy var PrimaryOrderID :Int = 0
    lazy var RecepientName = ""
    lazy var RefundType = ""
    lazy var OrderStatus = ""
    lazy var ResendAttestationTo = ""
    lazy var IsResendAttestationDisable:Bool =  false
    lazy var OperatorEleAttestationUrl = ""
    lazy var PayorEleAttestationUrl = ""

    


    func initWithDictionary(dictionary:[String : JSON]) -> OrderHistorySubResModel {
        
        if let item = dictionary[arrivalDate]?.stringValue {
            ArrivalDate = item
        }
        if let item1 = dictionary[cardExpDate]?.stringValue {
            CardExpDate = item1
        }
        if let item2 = dictionary[cardLastFourDigit]?.stringValue {
            CardLastFourDigit = item2
        }
        if let item3 = dictionary[cardTypeName]?.stringValue {
            CardTypeName = item3
        }
        if let item4 = dictionary[cashTotal]?.floatValue {
            CashTotal = item4
        }
        if let item5 = dictionary[createdDate]?.stringValue {
            CreatedDate = item5
        }
        
        if let item6 = dictionary[creditTotal]?.floatValue {
            CreditTotal = item6
        }
        
        if let item7 = dictionary[departureDate]?.stringValue {
            DepartureDate = item7
        }
        if let item8 = dictionary[deviceTypeName]?.stringValue {
            DeviceTypeName = item8
        }
        if let item9 = dictionary[eaid]?.intValue {
            EAID = item9
        }
        if let item10 = dictionary[equipmentOrderID]?.intValue {
            EquipmentOrderID = item10
        }
        if let item11 = dictionary[extensionNumber]?.intValue {
            ExtensionNumber = item11
        }
        if let item12 = dictionary[formatedOrderID]?.stringValue {
            FormatedOrderID = item12
        }
        if let item13 = dictionary[isCompanyOrder]?.boolValue {
            IsCompanyOrder = item13
        }
        if let item14 = dictionary[isCreditBilled]?.boolValue {
            IsCreditBilled = item14
        }
        if let item15 = dictionary[isDeclined]?.boolValue {
            IsDeclined = item15
        }
        if let item16 = dictionary[isOnlineOrdered]?.boolValue {
            IsOnlineOrdered = item16
        }
        if let item17 = dictionary[isPOCharged]?.boolValue {
            IsPOCharged = item17
        }
        if let item18 = dictionary[isPrimaryOrder]?.boolValue {
            IsPrimaryOrder = item18
        }
        if let item31 = dictionary[isResendAttestationDisable]?.boolValue {
            IsResendAttestationDisable = item31
        }
        if let item32 = dictionary[orderStatus]?.stringValue {
            OrderStatus = item32
        }
        if let item33 = dictionary[resendAttenstationTo]?.stringValue {
            ResendAttestationTo = item33
        }
        if let item19 = dictionary[isRefundCash]?.boolValue {
            IsRefundCash = item19
        }
        
        if let item20 = dictionary[isRefundCredit]?.boolValue {
            IsRefundCredit = item20
        }
        if let item21 = dictionary[isReturnImageUploaded]?.boolValue {
            IsReturnImageUploaded = item21
        }
        if let item22 = dictionary[isReturned]?.boolValue {
            IsReturned = item22
        }
        if let item23 = dictionary[locationName]?.stringValue {
            LocationName = item23
        }
        if let item24 = dictionary[operatorName]?.stringValue {
            OperatorName = item24
        }
        if let item25 = dictionary[operatorOccupantName]?.stringValue {
            OperatorOccupantName = item25
        }
        if let item26 = dictionary[originalDepartureDate]?.stringValue {
            OriginalDepartureDate = item26
        }
        if let item27 = dictionary[refundType]?.stringValue {
            RefundType = item27
        }

        if let item28 = dictionary[recepientName]?.stringValue {
            RecepientName = item28
        }
        if let item29 = dictionary[payorStatus]?.boolValue {
            PayorStatus = item29
        }
        if let item30 = dictionary[primaryOrderID]?.intValue {
            PrimaryOrderID = item30
        }
        if let item31 = dictionary[operatorEleAttestationUrl]?.stringValue {
            OperatorEleAttestationUrl = item31
        }
        if let item32 = dictionary[payorEleAttestationUrl]?.stringValue {
            PayorEleAttestationUrl = item32
        }

        
        
        
        
        

        return self
    }

    
    
}


