//
//  ExtendOrderRes.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 25/08/21.
//

import Foundation
import SwiftyJSON

class ExtendOrderRes:NSObject {
    
    let ErrorMessage = "ErrorMessage"
    let StatusCode = "StatusCode"
    let AccessoryType = "AccessoryType"
    let AccessoryTypeID = "AccessoryTypeID"
    let AccountName = "AccountName"
    let BillingProfileID = "BillingProfileID"
    let ChairPad = "ChairPad"
    let ChairPadPrice = "ChairPadPrice"
    let CompanyID = "CompanyID"
    let Compor = "Compor"
    let CustomerID = "CustomerID"
    let CustomerPickupLocation = "CustomerPickupLocation"
    let CustomerPickupLocationID = "CustomerPickupLocationID"
    let DefaultAccessoryType = "DefaultAccessoryType"
    let DefaultStateType = "DefaultStateType"
    let DevicePropertyIDs = "DevicePropertyIDs"
    let DevicePropertyOption = "DevicePropertyOption"
    let DevicePropertyOptionID = "DevicePropertyOptionID"
    let DeviceTypeID = "DeviceTypeID"
    let DeviceTypeName = "DeviceTypeName"
    let FirstName = "FirstName"
    let HandController = "HandController"
    let InventoryID = "InventoryID"
    let IsChairPadOptionAvailable = "IsChairPadOptionAvailable"
    let IsCustomerPickupLocation = "IsCustomerPickupLocation"
    let IsCustomerSecondOrder = "IsCustomerSecondOrder"
    let IsExistingOperator = "IsExistingOperator"
    let IsPickupInstructionAvailable = "IsPickupInstructionAvailable"
    let IsShippingAddress = "IsShippingAddress"
    let ItemFullDescription = "ItemFullDescription"
    let ItemImagePath = "ItemImagePath"
    let ItemName = "ItemName"
    let ItemShortDescription = "ItemShortDescription"
    let JoyStickPosition = "JoyStickPosition"
    let LastName = "LastName"
    let LocationID = "LocationID"
    let Message = "Message"
    let MiddleName = "MiddleName"
    let ModelOfItem = "ModelOfItem"
    let OccupantID = "OccupantID"
    let OperatorHeightFeet = "OperatorHeightFeet"
    let OperatorHeightInch = "OperatorHeightInch"
    let OperatorID = "OperatorID"
    let OperatorNote = "OperatorNote"
    let OperatorOccupantID = "OperatorOccupantID"
    let OperatorWeight = "OperatorWeight"
    let PickUpDate = "PickUpDate"
    let PickUpTime = "PickUpTime"
    let PickupInstructionContent = "PickupInstructionContent"
    let PreferredWheelchairSize = "PreferredWheelchairSize"
    let Price = "Price"
    let PrimaryOrderID = "PrimaryOrderID"
    let RentalPeriod = "RentalPeriod"
    let ReturnDate = "ReturnDate"
    let ReturnTime = "ReturnTime"
    let RewardPoint = "RewardPoint"
    let ShippingAddressLine1 = "ShippingAddressLine1"
    let ShippingAddressLine2 = "ShippingAddressLine2"
    let ShippingCity = "ShippingCity"
    let ShippingDeliveryNote = "ShippingDeliveryNote"
    let ShippingStateID = "ShippingStateID"
    let ShippingStateName = "ShippingStateName"
    let ShippingZipcode = "ShippingZipcode"
    let SlipNumber = "SlipNumber"
    let StateID = "StateID"
    let ChkSameAddress = "chkSameAddress"


    lazy var errorMessage = ""
    lazy var statusCode = ""
    lazy var accessoryType  = ""
    lazy var accessoryTypeID: Int = 0
    lazy var accountName   = ""
    lazy var billingProfileID: Int = 0
    lazy var chairPad  = ""
    lazy var chairPadPrice : Float = 0
    lazy var  companyID: Int = 0
    lazy var compor   = ""
    lazy var customerID:   Int = 0
    lazy var customerPickupLocation  = ""
    lazy var customerPickupLocationID:Int = 0
    lazy var defaultAccessoryType: Int = 0
    lazy var defaultStateType:   Int = 0
    lazy var devicePropertyIDs:Int = 0
    lazy var  devicePropertyOption = ""
    lazy var devicePropertyOptionID:Int? = nil
    lazy var  deviceTypeID:   Int = 0
    lazy var deviceTypeName  = ""
    lazy var firstName = ""
    lazy var handController = ""
    lazy var inventoryID:   Int = 0
    lazy var isChairPadOptionAvailable: Bool = false
    lazy var isCustomerPickupLocation: Bool = false
    lazy var isCustomerSecondOrder: Bool = false
    lazy var isExistingOperator:Bool = false
    lazy var isPickupInstructionAvailable: Bool = false
    lazy var isShippingAddress: Bool = false
    lazy var itemFullDescription = ""
    lazy var itemImagePath = ""
    lazy var itemName = ""
    lazy var itemShortDescription = ""
    lazy var joyStickPosition  = ""
    lazy var lastName = ""
    lazy var locationID:   Int = 0
    lazy var message = ""
    lazy var middleName = ""
    lazy var  modelOfItem   = ""
    lazy var occupantID: Int = 0
    lazy var operatorHeightFeet: Int = 0
    lazy var operatorHeightInch: Int = 0
    lazy var operatorID: Int = 0
    lazy var operatorNote  = ""
    lazy var operatorOccupantID:Int = 0
    lazy var operatorWeight:Float = 0
    lazy var pickUpDate = ""
    lazy var pickUpTime  = ""
    lazy var pickupInstructionContent = ""
    lazy var preferredWheelchairSize   = ""
    lazy var price:Float = 0
    lazy var primaryOrderID:   Int = 0
    lazy var rentalPeriod    = "0.00"
    lazy var returnDate = ""
    lazy var returnTime  = ""
    lazy var rewardPoint: Float = 0
    lazy var shippingAddressLine1 = ""
    lazy var shippingAddressLine2 = ""
    lazy var shippingCity = ""
    lazy var shippingDeliveryNote  = ""
    lazy var shippingStateID:   Int = 0
    lazy var shippingStateName = ""
    lazy var shippingZipcode  = ""
    lazy var slipNumber: Int  = 0
    lazy var   stateID: Int  = 0
    lazy var chkSameAddress: Bool = false

    
    func initWithDictionary(dictionary:[String : JSON]) -> ExtendOrderRes {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }
        if let item2 = dictionary[AccessoryType]?.stringValue {
            accessoryType = item2
        }
        if let item3 = dictionary[AccessoryTypeID]?.intValue {
            accessoryTypeID = item3
        }
        if let item4 = dictionary[BillingProfileID]?.intValue {
            billingProfileID = item4
        }
        if let item5 = dictionary[ChairPad]?.stringValue {
            chairPad = item5
        }
        
        if let item6 = dictionary[ChairPadPrice]?.floatValue {
            chairPadPrice = item6
        }
        
        if let item7 = dictionary[CompanyID]?.intValue {
            companyID = item7
        }
        if let item8 = dictionary[Compor]?.stringValue {
            compor = item8
        }
        if let item9 = dictionary[CustomerID]?.intValue {
            customerID = item9
        }
        if let item10 = dictionary[CustomerPickupLocation]?.stringValue {
            customerPickupLocation = item10
        }
        if let item11 = dictionary[CustomerPickupLocationID]?.intValue {
            customerPickupLocationID = item11
        }
        if let item12 = dictionary[DefaultAccessoryType]?.intValue {
            defaultAccessoryType = item12
        }
        if let item13 = dictionary[DefaultStateType]?.intValue {
            defaultStateType = item13
        }
        if let item14 = dictionary[DevicePropertyIDs]?.intValue {
            devicePropertyIDs = item14
        }
        if let item15 = dictionary[DevicePropertyOption]?.stringValue {
            devicePropertyOption = item15
        }
        if let item16 = dictionary[DevicePropertyOptionID]?.intValue {
            devicePropertyOptionID = item16
        }
        if let item17 = dictionary[DeviceTypeID]?.intValue {
            deviceTypeID = item17
        }
        if let item18 = dictionary[DeviceTypeName]?.stringValue {
            deviceTypeName = item18
        }

        if let item19 = dictionary[FirstName]?.stringValue {
            firstName = item19
        }
        
        if let item20 = dictionary[HandController]?.stringValue {
            handController = item20
        }
        if let item21 = dictionary[InventoryID]?.intValue {
            inventoryID = item21
        }
        if let item22 = dictionary[IsChairPadOptionAvailable]?.boolValue {
            isChairPadOptionAvailable = item22
        }
        
        if let item23 = dictionary[IsCustomerPickupLocation]?.boolValue {
            isCustomerPickupLocation = item23
        }

        if let item24 = dictionary[IsExistingOperator]?.boolValue {
            isExistingOperator = item24
        }

        if let item25 = dictionary[IsPickupInstructionAvailable]?.boolValue {
            isPickupInstructionAvailable = item25
        }
        if let item26 = dictionary[IsShippingAddress]?.boolValue {
            isShippingAddress = item26
        }
        if let item27 = dictionary[ItemFullDescription]?.stringValue {
            itemFullDescription = item27
        }
        if let item28 = dictionary[ItemImagePath]?.stringValue {
            itemImagePath = item28
        }
        if let item29 = dictionary[ItemName]?.stringValue {
            itemName = item29
        }
        if let item30 = dictionary[ItemShortDescription]?.stringValue {
            itemShortDescription = item30
        }
        if let item31 = dictionary[JoyStickPosition]?.stringValue {
            joyStickPosition = item31
        }
        if let item32 = dictionary[LastName]?.stringValue {
            lastName = item32
        }

        if let item33 = dictionary[LocationID]?.intValue {
            locationID = item33
        }
        if let item34 = dictionary[Message]?.stringValue {
            message = item34
        }
        if let item35 = dictionary[MiddleName]?.stringValue {
            middleName = item35
        }

        if let item36 = dictionary[ModelOfItem]?.stringValue {
            modelOfItem = item36
        }

        if let item37 = dictionary[OccupantID]?.intValue {
            occupantID = item37
        }
        if let item38 = dictionary[OperatorHeightFeet]?.intValue {
            operatorHeightFeet = item38
        }
        
        if let item39 = dictionary[OperatorHeightInch]?.intValue {
            operatorHeightInch = item39
        }
        if let item40 = dictionary[OperatorID]?.intValue {
            operatorID = item40
        }
        if let item41 = dictionary[OperatorOccupantID]?.intValue {
            operatorOccupantID = item41
        }
        
        if let item42 = dictionary[OperatorNote]?.stringValue {
            operatorNote = item42
        }
        if let item43 = dictionary[OperatorWeight]?.floatValue {
            operatorWeight = item43
        }
        if let item44 = dictionary[PickUpDate]?.stringValue {
            pickUpDate = item44
        }
        if let item45 = dictionary[PickUpTime]?.stringValue {
            pickUpTime = item45
        }
        if let item46 = dictionary[PickupInstructionContent]?.stringValue {
            pickupInstructionContent = item46
        }
        if let item47 = dictionary[Price]?.floatValue {
            price = item47
        }
        if let item48 = dictionary[PrimaryOrderID]?.intValue {
            primaryOrderID = item48
        }
        if let item49 = dictionary[RentalPeriod]?.stringValue {
            rentalPeriod = item49
        }
        if let item50 = dictionary[ReturnDate]?.stringValue {
            returnDate = item50
        }
        if let item51 = dictionary[ReturnTime]?.stringValue {
            returnTime = item51
        }
        if let item63 = dictionary[PreferredWheelchairSize]?.stringValue {
            preferredWheelchairSize = item63
        }
        if let item52 = dictionary[RewardPoint]?.floatValue {
            rewardPoint = item52
        }
        if let item53 = dictionary[ShippingAddressLine1]?.stringValue {
            shippingAddressLine1 = item53
        }
        if let item54 = dictionary[ShippingAddressLine2]?.stringValue {
            shippingAddressLine2 = item54
        }
        if let item55 = dictionary[ShippingCity]?.stringValue {
            shippingCity = item55
        }
        if let item56 = dictionary[ShippingDeliveryNote]?.stringValue {
            shippingDeliveryNote = item56
        }
        if let item57 = dictionary[ShippingStateID]?.intValue {
            shippingStateID = item57
        }
        if let item58 = dictionary[ShippingStateName]?.stringValue {
            shippingStateName = item58
        }
        if let item59 = dictionary[ShippingZipcode]?.stringValue {
            shippingZipcode = item59
        }
        if let item60 = dictionary[SlipNumber]?.intValue {
            slipNumber = item60
        }
        if let item61 = dictionary[StateID]?.intValue {
            stateID = item61
        }

        if let item62 = dictionary[ChkSameAddress]?.boolValue {
            chkSameAddress = item62
        }

        

        return self
    }

    
    
    
    
    
    
}




