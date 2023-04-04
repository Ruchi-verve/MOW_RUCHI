//
//  ApplyBonusModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 21/10/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import Foundation
import SwiftyJSON


class ApplyBonusModel: NSObject{
    
    var billingProfileID : Int = 0
    var chairPadPrice = ""
    var compPrice = ""
    var deliveryFee : Float = 0
    var descriptionField = ""
    var deviceTypeID : Int = 0
    var errorMessage  = ""
    var extensionDescription  = ""
    var extPrice : Float = 0
    var extPriceWithOutPromoCodeEffect : Int = 0
    var extPriceWithPromoCodeEffect  : Int = 0
    var isAcceptBonusDayLocation : Bool = false
    var isBonusDayProfile : Bool = false
    var isWholeBonusDayProfileAvailable : Bool = false
    var locationID  : Int = 0
    var message = ""
    var orderRegularPrice  : Float = 0
    var dictPaidBillingProfileResponse = PaidBillingProfileResponse()
    var pickUpDate = ""
    var pickupLocationTaxRate : Float = 0.0
    var pickUpTime  = ""
    var price : Float = 0
    var priceAdjustment : Float = 0
    var priceWithTax : Float = 0
    var rentalPeriod = ""
    var returnDate = ""
    var returnTime = ""
    var rewardPoint : Float = 0
    var statusCode = ""
    var subTotal : Float = 0
    var taxOnPrice : Float = 0
    var totalBonusDay : Int = 0
    var totalPriceDecimal : Float = 0

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */

    func initWithDictionary(dictionary:[String : JSON])  -> ApplyBonusModel
    {
        if let item = dictionary["ErrorMessage"]?.stringValue {
            errorMessage = item
        }
        if let item2 = dictionary["Message"]?.stringValue {
            message = item2
        }
        if let item3 = dictionary["StatusCode"]?.stringValue {
            statusCode = item3
        }
        if let item4 = dictionary["BillingProfileID"]?.intValue {
            billingProfileID = item4
        }
        if let item5 = dictionary["ChairPadPrice"]?.stringValue {
            chairPadPrice = item5
        }
        if let item6 = dictionary["CompPrice"]?.stringValue {
            compPrice = item6
        }
        if let item7 = dictionary["DeliveryFee"]?.floatValue {
            deliveryFee = item7
        }
        if let item8 = dictionary["Description"]?.stringValue {
            descriptionField = item8
        }
        if let item9 = dictionary["DeviceTypeID"]?.intValue {
            deviceTypeID = item9
        }
        if let item10 = dictionary["ExtPrice"]?.floatValue {
            extPrice = item10
        }
        if let item11 = dictionary["ExtPriceWithPromoCodeEffect"]?.intValue {
            extPriceWithPromoCodeEffect = item11
        }
        if let item12 = dictionary["ExtPriceWithOutPromoCodeEffect"]?.intValue {
            extPriceWithOutPromoCodeEffect = item12
        }
        if let item13 = dictionary["ExtensionDescription"]?.stringValue {
            extensionDescription = item13
        }
        if let item14 = dictionary["IsAcceptBonusDayLocation"]?.boolValue {
            isAcceptBonusDayLocation = item14
        }
        if let item15 = dictionary["IsBonusDayProfile"]?.boolValue {
            isBonusDayProfile = item15
        }
        if let item16 = dictionary["IsWholeBonusDayProfileAvailable"]?.boolValue {
            isWholeBonusDayProfileAvailable = item16
        }
        if let item17 = dictionary["LocationID"]?.intValue {
            locationID = item17
        }
        if let item18 = dictionary["OrderRegularPrice"]?.floatValue {
            orderRegularPrice = item18
        }
        if let item19 = dictionary["PaidBillingProfileResponse"]?.dictionary {
            let user = PaidBillingProfileResponse().initWithDictionary(dictionary: item19)
            self.dictPaidBillingProfileResponse = user

        }
        

        if let item20 = dictionary["PickUpDate"]?.stringValue {
            pickUpDate = item20
        }
        if let item21 = dictionary["PickUpTime"]?.stringValue {
            pickUpTime = item21
        }
        if let item22 = dictionary["PickupLocationTaxRate"]?.floatValue {
            pickupLocationTaxRate = item22
        }
        if let item23 = dictionary["Price"]?.floatValue{
            price = item23
        }
        if let item24 = dictionary["PriceAdjustment"]?.floatValue {
            priceAdjustment = item24
        }
        if let item25 = dictionary["PriceWithTax"]?.floatValue {
            priceWithTax = item25
        }
        if let item26 = dictionary["RentalPeriod"]?.stringValue {
            rentalPeriod = item26
        }
        if let item27 = dictionary["ReturnDate"]?.stringValue {
            returnDate = item27
        }
        if let item28 = dictionary["ReturnTime"]?.stringValue {
            returnTime = item28
        }
        if let item29 = dictionary["RewardPoint"]?.floatValue {
            rewardPoint = item29
        }
        if let item30 = dictionary["TaxOnPrice"]?.floatValue {
            taxOnPrice = item30
        }
        if let item31 = dictionary["TotalBonusDay"]?.intValue {
            totalBonusDay = item31
        }
        if let item32 = dictionary["TotalPriceDecimal"]?.floatValue {
            totalPriceDecimal = item32
        }
        if let item33 = dictionary["subTotal"]?.floatValue {
            subTotal = item33
        }
       
        return self
    }

    

}

class PaidBillingProfileResponse:NSObject {
    var errorMessage  = ""
    var message = ""
    var statusCode = ""
    var billingProfileID : Int = 0
    var compPrice = ""
    var descriptionField = ""
    var fromHour : Int = 0
    var isBonusDayProfile : Bool = false
    var isDispalyOnReservationPortal : Bool = false
    var regularPrice  : Float = 0
    var rewardPoint : Float = 0
    var toHour : Int = 0
    var newRenatlhours = 0

    func initWithDictionary(dictionary:[String : JSON])  -> PaidBillingProfileResponse
    {
        if let item = dictionary["ErrorMessage"]?.stringValue {
            errorMessage = item
        }
        if let item2 = dictionary["Message"]?.stringValue {
            message = item2
        }
        if let item3 = dictionary["StatusCode"]?.stringValue {
            statusCode = item3
        }
        if let item4 = dictionary["BillingProfileID"]?.intValue {
            billingProfileID = item4
        }
        if let item6 = dictionary["CompPrice"]?.stringValue {
            compPrice = item6
        }

        if let item8 = dictionary["Description"]?.stringValue {
            descriptionField = item8
        }

        if let item15 = dictionary["IsBonusDayProfile"]?.boolValue {
            isBonusDayProfile = item15
        }
        if let item18 = dictionary["IsDispalyOnReservationPortal"]?.boolValue {
            isDispalyOnReservationPortal = item18
        }
        if let item16 = dictionary["RegularPrice"]?.floatValue {
            regularPrice = item16
        }
        if let item17 = dictionary["FromHour"]?.intValue {
            fromHour = item17
        }
        if let item19 = dictionary["ToHour"]?.intValue {
            toHour = item19
        }
        if let item29 = dictionary["RewardPoint"]?.floatValue {
            rewardPoint = item29
        }
        if let item20 = dictionary["newRenatlhours"]?.intValue {
            newRenatlhours = item20
        }

        
        return self
        
    }


    
}
