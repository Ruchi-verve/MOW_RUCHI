//
//  CreditCardFormat.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 15/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import Foundation
class StringUtils: NSObject {
    class func formatCreditCard(_ input: String?) -> String? {
        var input = input
        input = self.trimSpecialCharacters(input)
        var output: String?
        switch (input?.count ?? 0) {
        case 1, 2, 3, 4:
            output = "\((input as NSString?)?.substring(to: input?.count ?? 0) ?? "")"
        case 5, 6, 7, 8:
            output = "\((input as NSString?)?.substring(to: 4) ?? "")-\((input as NSString?)?.substring(from: 4) ?? "")"
        case 9, 10, 11, 12:
            output = "\((input as NSString?)?.substring(to: 4) ?? "")-\((input as NSString?)?.substring(with: NSRange(location: 4, length: 4)) ?? "")-\((input as NSString?)?.substring(from: 8) ?? "")"
        case 13, 14, 15, 16:
            output = "\((input as NSString?)?.substring(to: 4) ?? "")-\((input as NSString?)?.substring(with: NSRange(location: 4, length: 4)) ?? "")-\((input as NSString?)?.substring(with: NSRange(location: 8, length: 4)) ?? "")-\((input as NSString?)?.substring(from: 12) ?? "")"
        default:
            output = ""
        }
        return output
    }

    class func trimSpecialCharacters(_ input: String?) -> String? {
        let special = CharacterSet(charactersIn: "/+-() ")
        return input?.components(separatedBy: special).joined(separator: "")
    }
}
