//
//  Users+CoreDataProperties.swift
//  MobilityOnWheel
//
//  Created by Verve on 16/12/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var accessoryId: Int32
    @NSManaged public var accessoryName: String?
    @NSManaged public var arrId: Int32
    @NSManaged public var arrivalDate: String?
    @NSManaged public var arrivalTime: String?
    @NSManaged public var billingProfileId: Int32
    @NSManaged public var chairPadId: Int32
    @NSManaged public var chairPadPrice: Float
    @NSManaged public var creditTotal: String?
    @NSManaged public var customerId: Int32
    @NSManaged public var deliveryFee: String?
    @NSManaged public var depatureDate: String?
    @NSManaged public var depatureTime: String?
    @NSManaged public var destination: String?
    @NSManaged public var destinationId: Int32
    @NSManaged public var deviceTypeId: Int32
    @NSManaged public var extenstionDays: String?
    @NSManaged public var extentionPrice: Float
    @NSManaged public var generateBonus: Bool
    @NSManaged public var handConId: Int32
    @NSManaged public var imgPath: String?
    @NSManaged public var isDefault: Bool
    @NSManaged public var isEditedOrder: Int32
    @NSManaged public var isExp: String?
    @NSManaged public var isOccupant: Bool
    @NSManaged public var isOrderComplete: Bool
    @NSManaged public var isPrimaryOrder: Bool
    @NSManaged public var isPromoapply: Bool
    @NSManaged public var isRiderRewardApply: Bool
    @NSManaged public var isShippingAddress: Bool
    @NSManaged public var itemDeliveryFee: Float
    @NSManaged public var itemDesc: String?
    @NSManaged public var itemName: String?
    @NSManaged public var itemPrice: Float
    @NSManaged public var joyStickId: Int32
    @NSManaged public var occuId: Int32
    @NSManaged public var occupantName: String?
    @NSManaged public var opeId: Int32
    @NSManaged public var operatorName: String?
    @NSManaged public var orderId: Int32
    @NSManaged public var originalPrice: String?
    @NSManaged public var paidBilingProfileId: Int32
    @NSManaged public var paidBonusDayProfile: Bool
    @NSManaged public var paidDesricption: String?
    @NSManaged public var paidRewardPoints: Float
    @NSManaged public var pickupLoc: String?
    @NSManaged public var pickupLocId: Int32
    @NSManaged public var preWheelId: Int32
    @NSManaged public var priceAdjustment: Float
    @NSManaged public var primaryOrderId: Int32
    @NSManaged public var promoCode: String?
    @NSManaged public var promoId: Int32
    @NSManaged public var promotionType: Bool
    @NSManaged public var promoValue: String?
    @NSManaged public var regPrice: Float
    @NSManaged public var rentalPeriod: String?
    @NSManaged public var rewardPoint: Int32
    @NSManaged public var shippingAddressLine1: String?
    @NSManaged public var shippingAddressLine2: String?
    @NSManaged public var shippingCity: String?
    @NSManaged public var shippingDeliveryNote: String?
    @NSManaged public var shippingStateID: Int32
    @NSManaged public var shippingStateName: String?
    @NSManaged public var shippingZipcode: String?
    @NSManaged public var strChairpad: String?
    @NSManaged public var strDevicePropertyIds: String?
    @NSManaged public var strHandCon: String?
    @NSManaged public var strJoyStick: String?
    @NSManaged public var strPreffWheel: String?
    @NSManaged public var taxRate: String?
    @NSManaged public var total: String?
    @NSManaged public var totalBonusDays: Int32
    @NSManaged public var isExtendOrder: String?
    @NSManaged public var oldArrrivalDate: String?
    @NSManaged public var oldArrivalTime: String?
    @NSManaged public var shippingCheckBox: Bool
    @NSManaged public var isDefaultOperator: Bool

}
