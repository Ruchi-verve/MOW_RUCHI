//
//  CheckoutData+CoreDataProperties.swift
//  MobilityOnWheel
//
//  Created by Verve on 04/01/22.
//  Copyright © 2022 Verve_Sys. All rights reserved.
//
//

import Foundation
import CoreData


extension CheckoutData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CheckoutData> {
        return NSFetchRequest<CheckoutData>(entityName: "CheckoutData")
    }

    @NSManaged public var bounceBack: Int32
    @NSManaged public var cashTotal: NSDecimalNumber?
    @NSManaged public var companyID: Int32
    @NSManaged public var companyTaxRate: NSDecimalNumber?
    @NSManaged public var createdBy: Int32
    @NSManaged public var creditTotal: NSDecimalNumber?
    @NSManaged public var customerID: Int32
    @NSManaged public var customerPickupLocationID: Int32
    @NSManaged public var deliveryFee: NSDecimalNumber?
    @NSManaged public var deliveryFeeWithTax: NSDecimalNumber?
    @NSManaged public var deviceOrignalPriceWithChairPad: NSDecimalNumber?
    @NSManaged public var equipmentOrderDetailRequest: Data?
    @NSManaged public var isAcceptBonusDayLocation: Bool
    @NSManaged public var isCompanyOrder: Bool
    @NSManaged public var isPrimaryOrder: Bool
    @NSManaged public var isRewardTurnOn: Bool
    @NSManaged public var listEquipmentOrderDetail: Data?
    @NSManaged public var occupantID: Int32
    @NSManaged public var operatorID: Int32
    @NSManaged public var orderID: Int32
    @NSManaged public var paymentProfileID: Int32
    @NSManaged public var pickupLocationID: Int32
    @NSManaged public var pickupLocationTaxRate: NSDecimalNumber?
    @NSManaged public var priceAdjustment: Int32
    @NSManaged public var priceWithTax: NSDecimalNumber?
    @NSManaged public var primaryOrderId: Int32
    @NSManaged public var taxOnPrice: NSDecimalNumber?
    @NSManaged public var totalBonusDays: Int32

}
