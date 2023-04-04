//
//  AppUrl.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 05/08/21.
//

import Foundation
import Alamofire
import SwiftyJSON

var getFCMToken:String = ""
class AppUrl:NSObject{
    struct URL {
        
//        static let Host = "http://192.168.1.165:8081/MOW/" // Developement
//        static let Host = "http://192.168.1.165:8080/MOW/"
        static let Host = "http://devapi.mobilityonwheelsonline.net/MOW/" // Developement
        static let imgeBase = "http://dev.mobilityonwheelsonline.net/" //Dev
        
        //PRODUCTION URL_-_-_-_-*****!#@
        
//        static let Host = "http://api.mobilityonwheelsonline.net/mow/"
//        static let imgeBase = "http://mobilityonwheelsonline.net/"
//        static let scannerKey = "BqGi8QEdvrgU7Xri01gxnoJL4u70tR4K"
        
        //MARK:- Authentication
        struct Auth {
            static let loginEndpoint = "GenerateOTP"
            static let verifyOTPEndpoint = "VerifyOTP"
            static let register = "SaveCustomer"
            static let registerUser = "Registration"
            static let retriveUser = "RetriveCellNumber"
            static let AppConfig = "GetAppConfiguration"
            static let validateLicense = "ValidateLicense"
            static let storefcmToken = "AddUpdateFCMToken"
        }
        struct Home {
            static let setEquipmentID = "AddDeviceInventoryID"
        }
        struct Location {
            static let getAllDestinationEndPoint = "GetAllDestiantion"
            static let getDevicebyLocationId = "GetDeviceByLocationID"
            static let getDeviceTypebyId = "GetDeviceTypeByID"
            static let getRentalRatesbyDeviceId = "GetRentalRatesByDeviceID"
            static let getPickupLocation = "GetCustomerPickupLocationByDestination"
            static let getAccessoryType = "RestrictedAccessoryByDeviceTypeID"
            static let getLocationById = "GetLocationByID"
            static let getDevicePropertOptions = "GetDevicePropertyOptionsBy"
        }
        
        struct Order {
            static let getAllActiveOrder = "GetAllActiveOrderByCustomerID"
            static let orderHistory = "GetCustomerOrderHistory"
            static let getSameDay = "GetSameDayReservation"
            static let getOrderHistoryDetail = "GetOrderDetailsByOrderID"
            static let checkReturnOrder = "CheckForReturnDeviceImage"
            static let returnOrder = "ImageUploadedForReturnDevice"
            static let reSendAttestation = "ReSendAttestation"
            static let cancelOrderByOrderId = "CancelOrderByOrderId"
            static let checkValidateOrder = "ValidateOrderListTime"
        }

        struct Card {
            static let addCard = "AuthorizePaymentRequest"
            static let getCradData = "GetAllPaymentProfileByCustomerID"
            static let removeCard = "DeleteAuthorizedPaymentProfile"
        }
        
        struct  State {
            static let getState = "GetAllState"
        }

        struct CheckOut{
            static let getBillingData = "GetOrderBillingProfile"
            static let agreeStatement = "GetDeviceTrainingVideoAndData"
            static let saveOrder = "SaveOrderList"
            static let applyPromo = "GetPromotionDetailByLocationIDNCode"
            static let applyRiderReward = "ApplyBonus"
        }
        
        struct Address {
            static let getAddress = "GetCustomerByID"
        }
        
        struct Operator {
            static let getOperatorList = "GetAllOperatorByCustomerID"
            static let getOccupantList = "GetOccupantListByOperatorID"
            static let getOccupantOperatorInfo = "GetEntityDefination"
            static let addEditOperator = "AddEditNewOperator"
            static let addOccupant = "SaveOccupant"
            static let removeOccupant = "RemoveOccupantById"
            static let existingOccupant = "GetExistingOccupant"
            static let getOccuDetails = "GetOccupantByID"
            static let getAddSameOccu = "AddDefaultOccupant"
            static let getOperatorByID = "GetOperatorByID"
        }
        
        struct Policy  {
            static let getRewardPolicy = "GetRewardPolicy"
            static let getPickupLocationInfo = "GetPickupInstructionDetailByDeviceLocationAndPickupLocation"
        }
        
        struct Notification {
            static let getNotificationBadge = "GetBadgeCount"
            static let getNotificationList = "AllPushNotificationList"
            static let setNotificationReadStatus = "MarkNotificationAsRead"
        }
    }

}
