//
//  Common.swift
//  Drlogy
//
//  Created by Arvind Kanjariya on 18/11/17.
//  Copyright © 2017 Version. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices
import CoreData


let APP_DELEGATE: AppDelegate = UIApplication.shared.delegate as! AppDelegate
let SCREEN_RECT: CGRect = UIScreen.main.bounds
let SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height
let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
private var previousTextFieldContent: String?
private var previousSelection: UITextRange?
var arrExpiredicense : [Int] = []
var NotificationBadge:Int = 0
var arrNotUploadLicense : [Int] = []
struct ScreenSize {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenMaxLength = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

struct DeviceType {
    static let iPhone4OrLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength < 568.0
    static let iPhoneSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 568.0
    static let iPhone8 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 667.0
    static let iPhone8Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 736.0
    static let iPhoneXr = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPhoneXs = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 812.0
    static let iPhoneXsMax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 896.0
    static let iPad = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.screenMaxLength == 1024.0
}

enum setFont:String {
    
    case bold = "Roboto-Bold"
    case regular = "Roboto-Regular"
    case light = "Roboto-Light"

    func of(size: CGFloat) -> UIFont? {
          return UIFont(name: rawValue, size: size)
    }

}


class Common:NSObject {
    

   static let shared = Common()
    override init(){}

//let RUPEE_SYMBOL: String =  "\u{20B9}"

let vwLoading = UIView()
    @available(iOS 13.0, *)
    func configureVwLoading() {
    var rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
    
    vwLoading.frame = rect
    vwLoading.backgroundColor = UIColor(white: 0.0, alpha: 0.33)
    
    rect = SCREEN_RECT
    vwLoading.center = CGPoint(x: rect.size.width/2.0, y: rect.size.height/2.0)
    vwLoading.layer.cornerRadius = vwLoading.frame.size.height/10.0
    
    let style = UIActivityIndicatorView.Style.large
    let actIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: style)
    rect = vwLoading.frame
    actIndicator.center = CGPoint(x: rect.size.width/2.0, y: rect.size.height/2.0)
    
    vwLoading.addSubview(actIndicator)
    actIndicator.startAnimating()
}
    func reformatAsCardNumber(textField: UITextField) {
            var targetCursorPosition = 0
            if let startPosition = textField.selectedTextRange?.start {
                targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
            }

            var cardNumberWithoutSpaces = ""
            if let text = textField.text {
                cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
            }

            if cardNumberWithoutSpaces.count > 19 {
                textField.text = previousTextFieldContent
                textField.selectedTextRange = previousSelection
                return
            }

            let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
            textField.text = cardNumberWithSpaces

            if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
                textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
            }
        }
    


        func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
            var digitsOnlyString = ""
            let originalCursorPosition = cursorPosition

            for i in Swift.stride(from: 0, to: string.count, by: 1) {
                let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
                if characterToAdd >= "0" && characterToAdd <= "9" {
                    digitsOnlyString.append(characterToAdd)
                }
                else if i < originalCursorPosition {
                    cursorPosition -= 1
                }
            }

            return digitsOnlyString
        }

        func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
            // Mapping of card prefix to pattern is taken from
            // https://baymard.com/checkout-usability/credit-card-patterns

            // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
            let is456 = string.hasPrefix("1")

            // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
            // as 4-6-5-4 to err on the side of always letting the user type more digits.
            let is465 = [
                // Amex
                "34", "37",

                // Diners Club
                "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
            ].contains { string.hasPrefix($0) }

            // In all other cases, assume 4-4-4-4-3.
            // This won't always be correct; for instance, Maestro has 4-4-5 cards according
            // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
            // know what prefixes identify particular formats.
            let is4444 = !(is456 || is465)

            var stringWithAddedSpaces = ""
            let cursorPositionInSpacelessString = cursorPosition
            for i in 0..<string.count {
                let needs465Spacing = (is465 && (i == 4 || i == 10 || i == 15))
                let needs456Spacing = (is456 && (i == 4 || i == 9 || i == 15))
                let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)

                if needs465Spacing || needs456Spacing || needs4444Spacing {
                    stringWithAddedSpaces.append(" ")

                    if i < cursorPositionInSpacelessString {
                        cursorPosition += 1
                    }
                }

                let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
                stringWithAddedSpaces.append(characterToAdd)
            }

            return stringWithAddedSpaces
        }

    func changeDateFormat(strDate:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yyyy"
        let date = dateFormatter.date(from: strDate)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let goodDate = dateFormatter.string(from: date!)
        return goodDate
    }

func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let result = emailTest.evaluate(with: testStr)
        return result
    }


    //MARK: -  Common function for corner radius
    func setCornerRadiustoLbl(_ lblName:UILabel) {
        lblName.layer.cornerRadius = lblName.frame.size.width / 2
        lblName.layer.borderWidth = 1
        lblName.layer.borderColor = UIColor.clear.cgColor

    }
    
    func checkCartCount(_ btnToHide:AddBadgeToButton){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
            let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
            if result.count > 0 {
                btnToHide.isHidden = false
                Common.shared.addBadgetoButton(btnToHide,"\(result.count)", "cart_white")
            } else {
                btnToHide.isHidden = true
                Common.shared.addBadgetoButton(btnToHide,"\(result.count)", "cart_white")
            }
        }catch {
            print("Fetching data Failed")
        }
    }
    
    
    func setCornerRadiustoView(_ viewSet:UIView, passRadius:Float) {
        viewSet.layer.cornerRadius = CGFloat(passRadius)
        viewSet.layer.borderWidth = 1
        viewSet.layer.borderColor = UIColor.clear.cgColor
    }

    //MARK: -  Common function for add Badge
    
    func addBadgetoButton(_ btnAdd:AddBadgeToButton,_ badgeCount:String,_ addIamge:String) {
        if badgeCount != "0" {
            btnAdd.tintColor = UIColor.white
            btnAdd.setImage(UIImage(named: addIamge)?.withRenderingMode(.alwaysTemplate), for: .normal)
            btnAdd.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
            btnAdd.badge = badgeCount

        }else {
            return
        }
    }
    
    
    func convertStringtoDate(strDate:String,passDateFormat:String) -> Date {
        let dateFormatter = DateFormatter()
        if passDateFormat != "" {
            dateFormatter.dateFormat = passDateFormat
        } else {
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        }
         let condate = dateFormatter.date(from: strDate)
        return condate!
    }
    func convertNumberToBoolValue(getValue:NSNumber) -> Bool {
        let promoBoolValue = getValue.boolValue
        return promoBoolValue
    }
    
func removeVwLoading() {
    if vwLoading.superview != nil {
        UIApplication.shared.endIgnoringInteractionEvents()
        vwLoading.removeFromSuperview()
    }
}

    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
       label.numberOfLines = 0
       label.lineBreakMode = NSLineBreakMode.byWordWrapping
       label.font = font
       label.text = text
       label.sizeToFit()
       return label.frame.height
   }
    
     func deleteDatabase() {
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CheckoutData")
         request.returnsObjectsAsFaults = false
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }

    func deleteUserDatabase() {
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<Users>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext.fetch(request)
            for object in results {
                let managedObjectData:NSManagedObject = object as NSManagedObject
                managedObjectContext.delete(managedObjectData)
                try managedObjectContext.save()
             }
        } catch let error {
            print("Detele all data in InspectionDatabase  error :", error)
        }
    }

func addVwLoading() {
    removeVwLoading()
    UIApplication.shared.beginIgnoringInteractionEvents()
    APP_DELEGATE.window?.addSubview(vwLoading)
    APP_DELEGATE.window?.bringSubviewToFront(vwLoading)
}
    func isValidPhone(phone: String) -> Bool {
            let phoneRegex = "^{0,1}+[0-9]{5,16}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phoneTest.evaluate(with: phone)
        }

func decodeResponseDataToModel<T:Codable>(type:T.Type,responseObj:Any) -> T? {
    let jsonDecoder = JSONDecoder()
    var model:T
    do {
        let data = try JSONSerialization.data(withJSONObject: responseObj, options: [])
        model = try jsonDecoder.decode(type, from: data)
        return model
    } catch {
        print(error.localizedDescription)
    }
    return nil
}
    func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }


    func addPaddingAndBorder(to textfield: UITextField, placeholder:String) {
    textfield.layer.cornerRadius =  8
    textfield.autocapitalizationType = UITextAutocapitalizationType.allCharacters
    textfield.layer.borderColor = AppConstants.kBorder_Color.cgColor
        if UIDevice.current.userInterfaceIdiom == .pad {
            textfield.font = setFont.regular.of(size: 20)
        } else {
            textfield.font = setFont.regular.of(size: 13)
        }
    textfield.textColor = UIColor.black
    textfield.layer.borderWidth = 0.7
    textfield.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)])
    let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8, height: 2.0))
    textfield.leftView = leftView
    textfield.leftViewMode = .always
    textfield.text = textfield.text?.uppercased()
    textfield.addTarget(self, action: #selector(myTextFieldTextChanged), for: .editingChanged)
}
    
    @objc func myTextFieldTextChanged (textField: UITextField) {
        textField.text =  textField.text?.uppercased()
    }
    

    func addTextfieldwithAssertick(to textfield:UITextField,placeholder:String){
        let strAttriburedString = NSMutableAttributedString(string: placeholder,attributes: [.foregroundColor:UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)])
        let asterix = NSAttributedString(string: " *", attributes: [.foregroundColor: UIColor.red,.baselineOffset:3])
        strAttriburedString.append(asterix)
        textfield.layer.cornerRadius =  8
        textfield.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        textfield.layer.borderColor = UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1).cgColor
        textfield.layer.borderWidth = 0.7
        if UIDevice.current.userInterfaceIdiom == .pad {
            textfield.font = setFont.regular.of(size: 20)
        } else {
            textfield.font = setFont.regular.of(size: 13)
        }
        textfield.attributedPlaceholder = strAttriburedString
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8, height: 2.0))
        textfield.leftView = leftView
        textfield.leftViewMode = .always
        textfield.text = textfield.text?.uppercased()
        textfield.addTarget(self, action: #selector(myTextFieldTextChanged), for: .editingChanged)
    }
    
    func addTextfieldwithAssertickForNonCapital(to textfield:SkyFloatingLabelTextField,placeholder:String){
        let strAttriburedString = NSMutableAttributedString(string: placeholder,attributes: [.foregroundColor:UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)])
        let asterix = NSAttributedString(string: " *", attributes: [.foregroundColor: UIColor.red,.baselineOffset:3])
        strAttriburedString.append(asterix)
        if UIDevice.current.userInterfaceIdiom == .pad {
            textfield.font = setFont.regular.of(size: 20)
        } else {
            textfield.font = setFont.regular.of(size: 14)
        }
        textfield.attributedPlaceholder = strAttriburedString
        textfield.placeholderColor = UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)
        textfield.lineHeight = 1
        textfield.placeholderFont = setFont.regular.of(size: 13)
        textfield.selectedTitleColor =  UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)
        textfield.attributedPlaceholder = strAttriburedString
        textfield.textColor = UIColor.black
        textfield.lineColor = UIColor.darkGray
        textfield.titleLabel.attributedText  =  strAttriburedString
    }

    
    func onlySetBorder(to textfield:UITextField) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            textfield.layer.cornerRadius =  30
            textfield.font = setFont.regular.of(size: 70)

        } else {
            textfield.layer.cornerRadius =  12
            textfield.font = setFont.regular.of(size: 40)
        }

        textfield.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        textfield.textColor = UIColor.black
        textfield.text = textfield.text?.uppercased()
        textfield.addTarget(self, action: #selector(myTextFieldTextChanged), for: .editingChanged)
    }
    
    func setStatusBarColor(view: UIView,color:UIColor) {
    if #available(iOS 13.0, *) {
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        let statusbarView = UIView()
        statusbarView.backgroundColor = color == AppConstants.kColor_Primary ? AppConstants.kColor_Primary : color
        view.addSubview(statusbarView)
      
        statusbarView.translatesAutoresizingMaskIntoConstraints = false
        statusbarView.heightAnchor
            .constraint(equalToConstant: statusBarHeight).isActive = true
        statusbarView.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        statusbarView.topAnchor
            .constraint(equalTo: view.topAnchor).isActive = true
        statusbarView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor).isActive = true
      
    } else {
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = color == AppConstants.kColor_Primary ? AppConstants.kColor_Primary : color
    }
}
    
    func formatCardNumber(_ preFormatted: String?) -> String? {
        //delegate only allows numbers to be entered, so '-' is the only non-legal char.
        var workingString = preFormatted?.replacingOccurrences(of: "-", with: "")

        //insert first '-'
        if (workingString?.count ?? 0) > 4 {
            workingString = (workingString as NSString?)?.replacingCharacters(in: NSRange(location: 4, length: 0), with: "-")
        }

        //insert second '-'
        if (workingString?.count ?? 0) > 9 {
            workingString = (workingString as NSString?)?.replacingCharacters(in: NSRange(location: 9, length: 0), with: "-")
        }
        
        //insert third '-'
        if (workingString?.count ?? 0) > 14 {
            workingString = (workingString as NSString?)?.replacingCharacters(in: NSRange(location: 14, length: 0), with: "-")
        }


        return workingString

    }
    
    

    func formatPhoneLogin(_ number: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let format: [Character] = ["(", "X", "X","X", ")", "X", "X", "X", "-", "X", "X", "X","X"]

        var result = ""
        var index = cleanNumber.startIndex
        for ch in format {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }

    func uniqueElementsFrom(array: [String]) -> [String] {
      //Create an empty Set to track unique items
      var set = Set<String>()
      let result = array.filter {
        guard !set.contains($0) else {
          //If the set already contains this object, return false
          //so we skip it
          return false
        }
        //Add this item to the set since it will now be in the array
        set.insert($0)
        //Return true so that filtered array will contain this item.
        return true
      }
      return result
    }

    //MARK:- SkyFloating library
    
    func setFloatlblTextField(placeHolder:String,textField:SkyFloatingLabelTextField) {
            textField.placeholderColor = UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)
            textField.lineHeight = 1
            textField.placeholderFont = setFont.regular.of(size:  UIDevice.current.userInterfaceIdiom == .pad ? 18 : 13)
            textField.selectedTitleColor =  UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)
            if UIDevice.current.userInterfaceIdiom == .pad {
                textField.font = setFont.regular.of(size: 20)
            } else {
                textField.font = setFont.regular.of(size: 14)
            }
            textField.placeholder = placeHolder
            textField.textColor = UIColor.black
            textField.lineColor = UIColor.darkGray
            textField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
            textField.text = textField.text?.uppercased()
    }
        
    func addSkyTextfieldwithAssertick(to textfield:SkyFloatingLabelTextField,placeHolder:String){
        let strAttriburedString = NSMutableAttributedString(string: placeHolder,attributes: [.foregroundColor:UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)])
        let asterix = NSAttributedString(string: " *", attributes: [.foregroundColor: UIColor.red,.baselineOffset:3])
        strAttriburedString.append(asterix)
        if UIDevice.current.userInterfaceIdiom == .pad {
            textfield.font = setFont.regular.of(size: 20)
        } else {
            textfield.font = setFont.regular.of(size: 14)
        }
        textfield.attributedPlaceholder = strAttriburedString
        textfield.placeholderColor = UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)
        textfield.lineHeight = 1
        textfield.placeholderFont = setFont.regular.of(size: 13)
        textfield.selectedTitleColor =  UIColor(red: 126/255, green: 131/255, blue: 134/255, alpha: 1)
        textfield.attributedPlaceholder = strAttriburedString
        textfield.textColor = UIColor.black
        textfield.lineColor = UIColor.darkGray
        textfield.titleLabel.attributedText  =  strAttriburedString
        textfield.text = textfield.text?.uppercased()
        textfield.addTarget(self, action: #selector(myTextFieldTextChanged), for: .editingChanged)
    }

    func onlySetBorderSkyText(to textfield:SkyFloatingLabelTextField) {
        if UIDevice.current.userInterfaceIdiom == .pad {
          //  textfield.layer.cornerRadius =  30
            textfield.font = setFont.regular.of(size: 70)
        } else {
         //   textfield.layer.cornerRadius =  12
            textfield.font = setFont.regular.of(size: 40)
        }
        
        textfield.backgroundColor = UIColor.clear
        textfield.textAlignment = .center
        textfield.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        textfield.textColor = UIColor.black
        textfield.text = textfield.text?.uppercased()
        textfield.lineColor = UIColor.darkGray
        textfield.addTarget(self, action: #selector(myTextFieldTextChanged), for: .editingChanged)
    }
    

func checkStatus(obj:Any?,successCompletion:()->(Void),errorCompletion:(_ message:String)->(Void)) {
    if let mObj = obj {
        let data:AnyObject = mObj as AnyObject
        if data.isKind(of: NSDictionary.classForCoder()) {
            let dict:NSDictionary = data as! NSDictionary
            let statusObj:AnyObject = dict.value(forKey: "status") as AnyObject
            var messageObj:String = ""
            if let val = dict.value(forKey: "message") {
                messageObj = val as! String
            }
            
            if let val = dict.value(forKey: "msg") {
                messageObj = val as! String
            }
            
            if statusObj.isKind(of: NSNumber.classForCoder()) {
                let status:Int = statusObj as! Int
                if status == 1 {
                    successCompletion()
                }
                else {
                    errorCompletion(messageObj)
                }
            }
            else if statusObj.isKind(of: NSString.classForCoder()) {
                let status:NSString = statusObj as! NSString
                if status == "1" {
                    successCompletion()
                }
                else {
                    errorCompletion(messageObj)
                }
            }
            else {
                errorCompletion(messageObj)
            }
        }
        else {
            errorCompletion("")
        }
    }
    else {
        errorCompletion("")
    }
}
    
}


class ErrorReporting {
    static func showMessage(title: String, msg: String, `on` controller: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "UPDATE", style: UIAlertAction.Style.default, handler: { action in
            if let url = URL(string: "itms-apps://apple.com/app/id1620365281") {
                UIApplication.shared.open(url)
            }
        }))
       // controller.present(alert, animated: true, completion: nil)
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)

        }
    }
}
