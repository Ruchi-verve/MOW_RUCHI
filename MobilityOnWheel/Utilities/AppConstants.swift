
//
//  AppConstants.swift
//  Drlogy
//
//  Created by Arvind K. on 13/01/19.
//  Copyright © 2019 app.com.drlogy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum CardType:String,CaseIterable {
    case Visa = "Visa"
    case AmericanExpress = "American Express"
    case MasterCard = "MasterCard"
    case Discover = "Discover"

}

let API_SHARED  =  ApiManager.sharedInstance
var Dict_ProductDetail = [String:Any]()
var ARR_PassData = [[String:Any]]()
var Arr_CheckOut = [[String:Any]]()
var OccuId : Int = 0
var billingId:Int = 0
var flotPricewithTax : Float = 0.0
var totalTaxPrice: Float = 0.0
let USER_DEFAULTS = UserDefaults.standard
let Extend = "extend"

var intJoystickPosId : Int = 0
var intChairPadReqId : Int = 0
var intHandControllerId : Int = 0
var intPrefferedWheelchairSizeId : Int = 0

var strJoystickPos : String = ""
var strChairPadReq : String = ""
var strHandController : String = ""
var strPrefferedWheelchairSize : String = ""

var strSubTotal = String()
var strTotal = String()
var strDeliveryFee = String()
var IsOccupantSame:Bool = false
var managedObjectContext: NSManagedObjectContext!
var TaxRate = Float()
var isSelectOccupantSame : String = ""

var strIsEditOrder = String()
var getchairPadPrice = Float()
var getTotal :  Float = 0.0
var getUserLocationId : Int = 0
var isGenerateBonusDay  : Bool = false
var cashTotal :  Float = 0.0
var gettingTotal = Float()
var getArrivalDatewithTime = String()
var getDepatureDatewithTime = String()
var taxRate  : Float = 0.0
var selAccId = Int(),  opeId : Int = 0

let imgNotification = "icon_notification"
let imgCart = "cart_white"
let intArrActiveOrderCount:String = "intArrActiveOrderCount"

struct DatabaseStringName {
    
    static let priceAdjustment = "priceAdjustment"
    static let taxOnPrice = "taxOnPrice"
    static let orderID = "orderID"
    static let priceWithTax = "priceWithTax"
    static let isPrimaryOrder = "isPrimaryOrder"
    static let primaryOrderID = "primaryOrderId"
    static let customerID = "customerID"
    static let createdBy = "createdBy"
    static let isCompanyOrder = "isCompanyOrder"
    static let pickupLocationID = "pickupLocationID"
    static let customerPickupLocationId = "customerPickupLocationID"
    static let pickupLocationTaxRate = "pickupLocationTaxRate"
    static let isAcceptBonusDayLocation = "isAcceptBonusDayLocation"
    static let isRewardTurnOn = "isRewardTurnOn"
    static let bounceBack = "bounceBack"
    static let cashTotal = "cashTotal"
    static let creditTotal = "creditTotal"
    static let paymentProfileID = "paymentProfileID"
    static let companyID = "companyID"
    static let companyTaxRate = "companyTaxRate"
    static let listEquipmentOrderDetail = "listEquipmentOrderDetail"
    static let equipmentOrderDetailRequest = "equipmentOrderDetailRequest"
    static let totalBonusDays = "totalBonusDays"
    static let deliveryFee = "deliveryFee"
    static let deliveryFeeWithTax = "deliveryFeeWithTax"
    static let operatorID = "operatorID"
    static let deviceOrignalPriceWithChairPad = "deviceOrignalPriceWithChairPad"
    static let locationName = "locationName"
    static let pickupTime = "pickupTime"
    static let returnTime = "returnTime"
    static let isExp = "0"
    static let occupantID = "occupantID"
    static let chairPadId = "chairPadId"
    static let chairPrice = "chairPadPrice"
    static let joyId = "joyStickId"
    static let strJoy = "strJoyStick"
    static let strPrefWheel = "strPreffWheel"
    static let prefWheelId = "preWheelId"
    static let handConId = "handConId"
    static let strHandCon = "strHandCon"
    static let strChairPad = "strChairpad"

    
 
    //MARK:- EquipmentORderReq
    
    static let accessoryTypeID = "accessoryTypeID"
    static let billingProfileID = "billingProfileID"
    static let deviceTypeID = "deviceTypeID"
    static let styleName = "styleName"
    static let equipCustomerID = "CustomerID"
    static let equipOperatorID = "OperatorID"
    static let arrivalDate = "arrivalDate"
    static let departureDate = "departureDate"
    static let price = "price"
    static let extPrice = "extPrice"
    static let paymentMethodID = "paymentMethodID"
    static let riderRewardPoint = "riderRewardPoint"
    static let note = "note"
    static let isSignOnFile = "isSignOnFile"
    static let promotionID = "promotionID"
    static let promotionCode = "promotionCode"
    static let promotionType = "promotionType"
    static let isPromoCodeUsed = "isPromoCodeUsed"
    static let promotionFigure = "promotionFigure"
    static let isBonusBillingProfile = "isBonusBillingProfile"
    static let rentalPeriod = "rentalPeriod"
    static let isDefaultOperator = "isDefaultOperator"
    static let equipPickupLocationID = "pickupLocationID"
    static let joystickID = "joystickID"
    static let wheelchairSizeID = "wheelchairSizeID"
    static let chairpadID = "chairpadID"
    static let handControllerID = "handControllerID"
    static let chairPadPrice = "chairPadPrice"
    static let isShippingAddress = "isShippingAddress"
    static let shippingAddressLine1 = "shippingAddressLine1"
    static let shippingAddressLine2 = "shippingAddressLine2"
    static let shippingZipcode = "shippingZipcode"
    static let shippingCity = "shippingCity"
    static let shippingDeliveryNote = "shippingDeliveryNote"
    static let shippingStateID = "shippingStateID"
    static let shippingStateName = "shippingStateName"
}

//struct PayerData {
//
//    static let priceAdjustment = "PriceAdjustment"
//    static let taxOnPrice = "TaxOnPrice"
//    static let orderID = "OrderId"
//    static let priceWithTax = "PriceWithTax"
//    static let isPrimaryOrder = "IsPrimaryOrder"
//    static let primaryOrderID = "PrimaryOrderID"
//    static let customerID = "CustomerID"
//    static let createdBy = "CreatedBy"
//    static let isCompanyOrder = "IsCompanyOrder"
//    static let pickupLocationID = "PickupLocationID"
//    static let customerPickupLocationId = "CustomerPickupLocationID"
//    static let pickupLocationTaxRate = "PickupLocationTaxRate"
//    static let isAcceptBonusDayLocation = "IsAcceptBonusDayLocation"
//    static let isRewardTurnOn = "IsRewardTurnOn"
//    static let bounceBack = "BounceBack"
//    static let cashTotal = "CashTotal"
//    static let creditTotal = "CreditTotal"
//    static let paymentProfileID = "PaymentProfileID"
//    static let companyID = "CompanyID"
//    static let companyTaxRate = "CompanyTaxRate"
////    static let listEquipmentOrderDetail = "listEquipmentOrderDetail"
//    static let equipmentOrderDetailRequest = "equipmentOrderDetailRequest"
//    static let totalBonusDays = "TotalBonusDays"
//    static let deliveryFee = "DeliveryFee"
//    static let deliveryFeeWithTax = "DeliveryFeeWithTax"
//    static let operatorID = "OperatorID"
//    static let deviceOrignalPriceWithChairPad = "DeviceOrignalPriceWithChairPad"
////    static let locationName = "locationName"
////    static let pickupTime = "pickupTime"
////    static let returnTime = "returnTime"
////    static let isExp = "0"
//    static let occupantID = "OccupantID"
//
//}
//
//struct OperatorData {
//
//    static let accessoryTypeID = "AccessoryTypeID"
//    static let billingProfileID = "BillingProfileID"
//    static let deviceTypeID = "DeviceTypeID"
//    static let styleName = "styleName"
//    static let customerID = "CustomerID"
//    static let operatorID = "OperatorID"
//    static let arrivalDate = "ArrivalDate"
//    static let departureDate = "DepartureDate"
//    static let price = "Price"
//    static let extPrice = "ExtPrice"
//    static let paymentMethodID = "PaymentMethodID"
//    static let riderRewardPoint = "RiderRewardPoint"
//    static let note = "Note"
//    static let isSignOnFile = "IsSignOnFile"
//    static let promotionID = "PromotionID"
//    static let isPromoCodeUsed = "IsPromoCodeUsed"
//    static let promotionCode = "PromotionCode"
//    static let promotionType = "PromotionType"
//    static let promotionFigure = "PromotionFigure"
//    static let isBonusBillingProfile = "IsBonusBillingProfile"
//    static let rentalPeriod = "RentalPeriod"
//    static let isDefaultOperator = "isDefaultOperator"
//    static let equipPickupLocationID = "PickupLocationID"
//    static let joystickID = "JoystickID"
//    static let wheelchairSizeID = "WheelchairSizeID"
//    static let chairpadID = "ChairpadID"
//    static let handControllerID = "HandControllerID"
//    static let chairPadPrice = "ChairPadPrice"
//    static let isShippingAddress = "IsShippingAddress"
//    static let shippingAddressLine1 = "ShippingAddressLine1"
//    static let shippingAddressLine2 = "ShippingAddressLine2"
//    static let shippingZipcode = "ShippingZipcode"
//    static let shippingCity = "ShippingCity"
//    static let shippingDeliveryNote = "ShippingDeliveryNote"
//    static let shippingStateID = "ShippingStateID"
//    static let shippingStateName = "ShippingStateName"
//}

class AppConstants {
    static let USER_ID:String = "user_id"
    static let TOKEN:String = "token"
    static let FIRST_NAME:String = "first_name"
    static let LAST_NAME:String = "last_name"
    static let CONTACT_NO:String = "contact_no"
    static let PINCODE:String = "pincode"
    static let EMAIL:String = "email"
    static let IMAGE:String = "image"
    static let IS_LOGIN:String = "isLogin"
    static let ROLE:String = "role"
    static let ErrorMessage:String = "Something went wrong!"
    static let NoInetrnet:String = "No Internet Connection"
    static let setHi:String = "Hi "
    static let appDel = UIApplication.shared.delegate as! AppDelegate
    static let SelDest:String = "SelLoc"
    static let selDestId:String = "SelDestId"
    static let DeliveryFee:String = "DeliveryFee"
    static let UserOcuuID:String = "UserOcuuID"
    static let equipmentOrderDetailRequest = "EquipmentOrderDetailRequest"
    static let listEquipmentOrderDetail = "ListEquipmentOrderDetail"

    static let OrderNumber:String = "Order Number: "
    static let EquipmentID:String = "Equipment ID: "

    static let kColor_Primary:UIColor = UIColor(red: 34.0/255.0, green: 83.0/255.0, blue: 143.0/255.0, alpha: 1.0)
    static let kBorder_Color:UIColor = UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)
    
    
    
    
}
