//
//  AgreeTermsModel.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 12/08/21.
//

import Foundation
import SwiftyJSON


class AgreeTermsModel:NSObject {
    let StatusCode  = "StatusCode"
    let Message  = "Message"
    let ErrorMessage  = "ErrorMessage"
    let AttestationID = "AttestationID"
    let CheckOutText = "CheckOutText"
    let  CompanyName = "CompanyName"
    let DeviceTypeID = "DeviceTypeID"
    let IsPayorOperatorSame = "IsPayorOperatorSame"
    let LocationID = "LocationID"
    let ModifiedTermsAndConditionText = "ModifiedTermsAndConditionText"
    let OperatorName = "OperatorName"
    let PayorName = "PayorName"
    let RentalAgreementText = "RentalAgreementText"
    let RentalCompanyName = "RentalCompanyName"
    let RequestPortal = "RequestPortal"
    let TermsAndConditionText = "TermsAndConditionText"
    let TrainingVideoURL = "TrainingVideoURL"
    let TraningVideoText = "TraningVideoText"

    
    lazy var errorMessage = ""
    lazy var message = ""
    lazy var statusCode = ""
    lazy var attestationID:Int = 0
    lazy var checkOutText = ""
    lazy var companyName = ""
    lazy var deviceTypeID:Int = 0
    lazy var isPayorOperatorSame:Bool = false
    lazy var locationID:Int = 0
    lazy var modifiedTermsAndConditionText = ""
    lazy var operatorName = ""
    lazy var payorName = ""
    lazy var rentalAgreementText = ""
    lazy var rentalCompanyName = ""
    lazy var requestPortal = ""
    lazy var termsAndConditionText = ""
    lazy var trainingVideoURL:URL? = nil
    lazy var traningVideoText = ""

    
    func initWithDictionary(dictionary:[String : JSON]) -> AgreeTermsModel {
        
        if let item = dictionary[ErrorMessage]?.stringValue {
            errorMessage = item
        }
        
        if let item1 = dictionary[StatusCode]?.stringValue {
            statusCode = item1
        }

        if let item2 = dictionary[Message]?.stringValue {
            message = item2
        }
        
        if let item3 = dictionary[AttestationID]?.intValue {
            attestationID = item3
        }

        if let item4 = dictionary[CheckOutText]?.stringValue {
            checkOutText = item4
        }

        if let item5 = dictionary[CompanyName]?.stringValue {
            companyName = item5
        }

        if let item6 = dictionary[DeviceTypeID]?.intValue {
            deviceTypeID = item6
        }

        if let item7 = dictionary[IsPayorOperatorSame]?.boolValue {
                isPayorOperatorSame  = item7
        }
        
        if let item8 = dictionary[LocationID]?.intValue {
            locationID = item8
        }
        if let item9 = dictionary[ModifiedTermsAndConditionText]?.stringValue {
                modifiedTermsAndConditionText = item9
        }
        if let item10 = dictionary[OperatorName]?.stringValue {
                operatorName = item10
        }
        if let item11 = dictionary[PayorName]?.stringValue {
                payorName = item11
        }
        if let item12 = dictionary[RentalAgreementText]?.stringValue {
                rentalAgreementText = item12
        }
        if let item13 = dictionary[RentalCompanyName]?.stringValue {
            rentalCompanyName = item13
        }
        if let item14 = dictionary[RequestPortal]?.stringValue {
            requestPortal = item14
        }
        if let item15 = dictionary[TermsAndConditionText]?.stringValue {
            termsAndConditionText = item15
        }
        if let item16 = dictionary[TrainingVideoURL]?.url {
            trainingVideoURL = item16
        }
        if let item17 = dictionary[TraningVideoText]?.stringValue {
            traningVideoText = item17
        }

        
        return self

        
    }


    
    
    

    
    
    
}




