import Foundation

public enum CreditCardType: String {
    case visa = "^4[0-9]{6,}$"
    case masterCard = "^(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9]{12}$"
    case discover = "^6(?:011|5[0-9]{2})[0-9]{3,}$"
    case americanExpress = "^3[47][0-9]{5,}$"
    /// Possible C/C number lengths for each C/C type
    /// reference: https://en.wikipedia.org/wiki/Payment_card_number
    var validNumberLength: IndexSet {
        switch self {
        case .visa:
            return IndexSet([13,16])
        case .americanExpress:
            return IndexSet(integer: 15)
        default:
            return IndexSet(integer: 16)
        }
    }
}

public struct CreditCardValidator {
    
    /// Available credit card types
    private let types: [CreditCardType] = [
        .visa,
        .masterCard,
        .discover,
        .americanExpress
    ]
    
    private let string: String
    
    /// Create validation value
    /// - Parameter string: credit card number
    public init(_ string: String) {
        self.string = string.numbers
    }
    
    /// Get card type
    /// Card number validation is not perfroms here
    public var type: CreditCardType? {
        types.first { type in
            NSPredicate(format: "SELF MATCHES %@", type.rawValue)
                .evaluate(
                    with: string.numbers
                )
        }
    }
    
    /// Calculation structure
    private struct Calculation {
        let odd, even: Int
        func result() -> Bool {
            (odd + even) % 10 == 0
        }
    }
    
    /// Validate credit card number
    public var isValid: Bool {
        guard let type = type else { return false }
        let isValidLength = type.validNumberLength.contains(string.count)
        return isValidLength && isValid(for: string)
    }
    
    /// Validate card number string for type
    /// - Parameters:
    ///   - string: card number string
    ///   - type: credit card type
    /// - Returns: bool value
    public func isValid(for type: CreditCardType) -> Bool {
        isValid && self.type == type
    }
    
    /// Validate string for credit card type
    /// - Parameters:
    ///   - string: card number string
    /// - Returns: bool value
    private func isValid(for string: String) -> Bool {
        string
            .reversed()
            .compactMap({ Int(String($0)) })
            .enumerated()
            .reduce(Calculation(odd: 0, even: 0), { value, iterator in
                return .init(
                    odd: odd(value: value, iterator: iterator),
                    even: even(value: value, iterator: iterator)
                )
            })
            .result()
    }
    
    private func odd(value: Calculation, iterator: EnumeratedSequence<[Int]>.Element) -> Int {
        iterator.offset % 2 != 0 ? value.odd + (iterator.element / 5 + (2 * iterator.element) % 10) : value.odd
    }

    private func even(value: Calculation, iterator: EnumeratedSequence<[Int]>.Element) -> Int {
        iterator.offset % 2 == 0 ? value.even + iterator.element : value.even
    }
    
}

fileprivate extension String {
 
    var numbers: String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
}
