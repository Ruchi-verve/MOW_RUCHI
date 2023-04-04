//
//  Extensions.swift
//  Drlogy
//
//  Created by Arvind Kanjariya on 19/12/17.
//  Copyright © 2017 Version. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import CoreData

enum Months: String {
    case JAN = "Jan"
    case FEB = "Feb"
    case MAR = "Mar"
    case APL = "Apr"
    case MAY = "May"
    case JUN = "Jun"
    case JUL = "Jul"
    case AUG = "Aug"
    case SEPT = "Sept"
    case OCT = "Oct"
    case NOV = "Nov"
    case DEC = "Dec"
    
    static func index(of aStatus: Months) -> Int {
        let elements = [Months.JAN, Months.FEB, Months.MAR,
        Months.APL, Months.MAY, Months.JUN,
        Months.JUL, Months.AUG, Months.SEPT,
        Months.OCT, Months.NOV, Months.DEC]
        
        return elements.firstIndex(of: aStatus)!
    }
    
    /*static func element(at index: Int) -> Months? {
        let elements = [Status.online, Status.offline, Status.na]
        
        if index >= 0 && index < elements.count {
            return elements[index]
        } else {
            return nil
        }
    }*/
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}


extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func imageWithColor(color: UIColor) -> UIImage? {
      var image = withRenderingMode(.alwaysTemplate)
      UIGraphicsBeginImageContextWithOptions(size, false, scale)
      color.set()
      image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
      image = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      return image
  }

    
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        
        draw(in: CGRect(origin: .zero, size: canvasSize))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIColor {
    convenience init(hexString:String) {
        let hexString:NSString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        let scanner = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "#%02x%02x%02x", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }

}

extension NSMutableAttributedString {

    /// Replaces the base font (typically Times) with the given font, while preserving traits like bold and italic
    func with(font: UIFont) -> NSMutableAttributedString {
        enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            if let originalFont = value as? UIFont, let newFont = applyTraitsFromFont(originalFont, to: font) {
                addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })

        return self
    }

    func applyTraitsFromFont(_ originalFont: UIFont, to newFont: UIFont) -> UIFont? {
        let originalTrait = originalFont.fontDescriptor.symbolicTraits

        if originalTrait.contains(.traitBold) {
            var traits = newFont.fontDescriptor.symbolicTraits
            traits.insert(.traitBold)

            if let fontDescriptor = newFont.fontDescriptor.withSymbolicTraits(traits) {
                return UIFont.init(descriptor: fontDescriptor, size: 0)
            }
        }

        return newFont
    }
}

extension String {
    func htmlAttributedString(size: CGFloat, color: UIColor) -> NSAttributedString? {
        let htmlTemplate = """
        <!doctype html>
        <html>
          <head>
            <style>
              body {
                color: \(color.hexString!);
                font-family: -apple-system;
                font-size: \(size)px;
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """

        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
            ) else {
            return nil
        }

        return attributedString
    }
}
extension UILabel {
    func textHeight(withWidth width: CGFloat, setfont:UIFont) -> CGFloat {
       guard let text = text else {
          return 0
       }
        return text.height(withConstrainedWidth: UIScreen.main.bounds.width - 40, font: setfont)
    }
}
extension String {
   
    var  convertingToDate: Date {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss a"
         let condate = dateFormatter.date(from: self)
        return condate!
    }

   
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: String.Encoding.utf16,allowLossyConversion: false) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
        
    }
    

    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func PadLeft( totalWidth: Int,byString:String) -> String {
    let toPad = totalWidth - self.count
    if toPad < 1 {
        return self
    }
    
    return "".padding(toLength: toPad, withPad: byString, startingAt: 0) + self
}
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        let versionDelimiter = "."

        var versionComponents = self.components(separatedBy: versionDelimiter) // <1>
        var otherVersionComponents = otherVersion.components(separatedBy: versionDelimiter)

        let zeroDiff = versionComponents.count - otherVersionComponents.count // <2>

        if zeroDiff == 0 { // <3>
            // Same format, compare normally
            return self.compare(otherVersion, options: .numeric)
        } else {
            let zeros = Array(repeating: "0", count: abs(zeroDiff)) // <4>
            if zeroDiff > 0 {
                otherVersionComponents.append(contentsOf: zeros) // <5>
            } else {
                versionComponents.append(contentsOf: zeros)
            }
            return versionComponents.joined(separator: versionDelimiter)
                .compare(otherVersionComponents.joined(separator: versionDelimiter), options: .numeric) // <6>
        }
    }



}

extension NSAttributedString {

//    public convenience init?(HTMLString html: String, font: UIFont? = nil) throws {
//        let options : [NSAttributedString.DocumentReadingOptionKey : Any] =
//            [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
//             NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
//
//        guard let data = html.data(using: .utf8, allowLossyConversion: true) else {
//            throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
//        }
//
//        if let font = font {
//            guard let attr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
//                throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
//            }
//            var attrs = attr.attributes(at: 0, effectiveRange: nil)
//            attrs[NSAttributedString.Key.font] = font
//            attr.setAttributes(attrs, range: NSRange(location: 0, length: attr.length))
//            self.init(attributedString: attr)
//        } else {
//            try? self.init(data: data, options: options, documentAttributes: nil)
//        }
//    }
    public convenience init? (html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,], documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }

    
}



extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
    
        return ceil(boundingBox.width)
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    func dayOfWeek() -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self).capitalized
            // or use capitalized(with: locale) if you want
        }
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
      let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!

      //get the month/day/year componentsfor today's date.

      var date_components = calendar.components(
        [NSCalendar.Unit.year,
         NSCalendar.Unit.month,
         NSCalendar.Unit.day],
        from: self)

      //Create an NSDate for the specified time today.
      date_components.hour = hours
      date_components.minute = minutes
      date_components.second = 0

      let newDate = calendar.date(from: date_components)!
      return newDate
    }
  
    
    func secondsFromBeginningOfTheDay() -> TimeInterval {
        let calendar = Calendar.current
        // omitting fractions of seconds for simplicity
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: self)

        let dateSeconds = dateComponents.hour! * 3600 + dateComponents.minute! * 60 + dateComponents.second!

        return TimeInterval(dateSeconds)
    }

    // Interval between two times of the day in seconds
    func timeOfDayInterval(toDate date: Date) -> TimeInterval {
        let date1Seconds = self.secondsFromBeginningOfTheDay()
        let date2Seconds = date.secondsFromBeginningOfTheDay()
        return date2Seconds - date1Seconds
    }


}

extension UIView {
    
    func roundingCorners(corners: UIRectCorner,cornerRadii: CGSize) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    func dottedLinesBorder() {
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = AppConstants.kColor_Primary.cgColor
        yourViewBorder.lineDashPattern = [15, 5]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(yourViewBorder)
    }
    func setAnchorPoint(anchorPoint: CGPoint) {

        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)

        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)

        var position : CGPoint = self.layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x;

        position.y -= oldPoint.y;
        position.y += newPoint.y;

        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }

    func dropShadow(scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize(width: -1, height: 1)
      layer.shadowRadius = 1

      layer.shadowPath = UIBezierPath(rect: bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
      layer.masksToBounds = false
      layer.shadowColor = color.cgColor
      layer.shadowOpacity = opacity
      layer.shadowOffset = offSet
      layer.shadowRadius = radius

      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

let imageCache = NSCache<NSString,UIImage>()
extension UIImageView {
    func loadImageUsingURL(urlString:String,success:@escaping ()->Void) {
        let fUrl:String = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: fUrl)
        image = UIImage(named: "placeholder")
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            success()
            return
        }
        
        
        let session:URLSession = URLSession.shared
        let task:URLSessionDataTask = session.dataTask(with: url!) { (data:Data?, response:URLResponse?, err:Error?) in
            
            if err != nil {
                return
            }
            
            DispatchQueue.main.async {
                let imageToCatch =  UIImage(data: data!)
                if let imCatch = imageToCatch {
                    imageCache.setObject(imCatch, forKey: urlString as NSString)
                    self.image = imCatch
                    success()
                }
            }
        }
        task.resume()
    }
}
//extension Array {
//    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
//        var set = Set<T>() //the unique list kept in a Set for fast retrieval
//        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
//        for value in self {
//            if !set.contains(map(value)) {
//                set.insert(map(value))
//                arrayOrdered.append(value)
//            }
//        }
//
//        return arrayOrdered
//    }
//}

//extension Array where Element: Hashable {
//  func unsortedUniqueElements() -> [Element] {
//    let set = Set(self)
//    return Array(set)
//  }
//}

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}


extension UIButton
{
    /*
     Add right arrow disclosure indicator to the button with normal and
     highlighted colors for the title text and the image
     */
    func disclosureButton()
    {
        guard let image = UIImage(named: "icon_down_arrow")?.withRenderingMode(.alwaysTemplate) else
        {
            return
        }
        
        self.imageView?.contentMode = .scaleAspectFit
        
        self.setImage(image, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.bounds.size.width-image.size.width+20, bottom: 0, right: 0);
        self.contentEdgeInsets = UIEdgeInsets(top: 10,left: -20,bottom: 10,right: 0)
        
//        let lineView = UIView(frame: CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 0.5))
//        lineView.backgroundColor=UIColor.lightGray
//
//        self.addSubview(lineView)
    }
    
    func roundedCorner(){
        self.layer.cornerRadius = self.bounds.size.height/2
        self.clipsToBounds = true
    }
    
    func roundedCorner(radius: Int){
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
}

extension UIView {
    func roundedViewCorner(radius: Int){
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
    }
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

extension UIViewController {

func showToast(message : String) {

    let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-60, width: self.view.frame.size.width, height: 60))
    toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = setFont.regular.of(size: 15)
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 8;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
}
    

}


@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    func htmlAttributedString() -> NSMutableAttributedString {

            guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
                else { return NSMutableAttributedString() }

            guard let formattedString = try? NSMutableAttributedString(data: data,
                                                            options: [.documentType: NSAttributedString.DocumentType.html,
                                                                      .characterEncoding: String.Encoding.utf8.rawValue],
                                                            documentAttributes: nil )

                else { return NSMutableAttributedString() }

            return formattedString
    }

    func changeDate(_ mydate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let convertedDate = dateFormatter.date(from: mydate)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: convertedDate!)
        return date
    }

    func changeMonthNameDate(_ mydate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let convertedDate = dateFormatter.date(from: mydate)
        dateFormatter.dateFormat = "MMMM dd,yyyy"
        let date = dateFormatter.string(from: convertedDate!)
        return date
    }
}


extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Formatter {
    static let date = DateFormatter()
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UIViewController {
   class var storyboardID : String {
     return "\(self)"
   }
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
    

}
extension UITextField {
    func addInputViewDatePicker(target: Any, selector: Selector,isDob:Bool,isTime:Bool) {

   let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

        if isTime == true {
            datePicker.datePickerMode = .time
            datePicker.minuteInterval = 5
            self.inputView = datePicker
        datePicker.autoresizingMask = .flexibleWidth
        }
        else  {
            datePicker.datePickerMode = .date
                self.inputView = datePicker
            datePicker.autoresizingMask = .flexibleWidth
                 if isDob == true {
                     datePicker.maximumDate = Date()
                 } else {
                     datePicker.minimumDate = Date()
                 }
        }
   //Add DatePicker as inputView
 
   //Add Tool Bar as input AccessoryView
   let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
   let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
   toolBar.setItems([spaceButton,doneBarButton], animated: false)
   self.inputAccessoryView = toolBar
}
    

    func addDepartureInputViewDatePicker(target: Any, selector: Selector,minDate:Date) {

   let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
            datePicker.datePickerMode = .date
            self.inputView = datePicker
            datePicker.autoresizingMask = .flexibleWidth
            datePicker.minimumDate = minDate
   //Add DatePicker as inputView
 
   //Add Tool Bar as input AccessoryView
   let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
   let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
   toolBar.setItems([spaceButton,doneBarButton], animated: false)
        self.inputAccessoryView = toolBar

    
    
    }


}
extension UIApplication {

    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

}



extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Collection where Iterator.Element == [String:Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:Any]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
    
    
}


extension Dictionary where Value: Any {
    static public func ==(lhs: [String: AnyObject], rhs: [String: AnyObject] ) -> Bool {
        return NSDictionary(dictionary: lhs).isEqual(to: rhs)
    }
}

extension Collection {
    func map2Dict<K, V>(map: ((Self.Iterator.Element) -> (K,    V)?))  -> [K: V] {
        var d = [K: V]()
        for e in self {
            if let kV = map(e) {
                d[kV.0] = kV.1
            }
        }

        return d
    }

    func map2Array<T>( map: ((Self.Iterator.Element) -> (T)?))  -> [T] {
        var a = [T]()
        for e in self {
            if let o = map(e) {
                a.append(o)
            }
        }

        return a
    }

    func map2Set<T>( map: ((Self.Iterator.Element) -> (T)?))  -> Set<T> {
        return Set(map2Array(map: map))
    }
}

extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
