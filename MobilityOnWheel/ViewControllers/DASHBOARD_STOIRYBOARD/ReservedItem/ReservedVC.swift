//
//  ReservedVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit
import CoreData
import SDWebImage


class ReservedVC: SuperViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblsubTotal: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblgstTax: UILabel!
    @IBOutlet weak var contblHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTitleName:UILabel!
    @IBOutlet weak var viewNorecord:UIView!
    @IBOutlet weak var btnCheckout:UIButton!
    @IBOutlet weak var btnAdditionalOrder:UIButton!
    @IBOutlet weak var ViewDetailHeight:UIView!
    @IBOutlet weak var lbLPromocode:UILabel!
    @IBOutlet weak var lblPromocodeValue:UILabel!
    @IBOutlet weak var conlblPromoHeight:NSLayoutConstraint!
    @IBOutlet weak var conlblPromoValueHeight:NSLayoutConstraint!
    @IBOutlet weak var viewTotal:UIView!
    @IBOutlet weak var btnCart: AddBadgeToButton!
    @IBOutlet weak var btnNoti: UIButton!

   lazy var isComefrom:String = ""
    lazy var arrData = [[String:Any]] ()
    lazy var dictReservedRes = OrderHistorySubResModel()
    lazy var index: Int = -1
    lazy var isExpand:Bool = false
    lazy var arrDuplicate : [NSManagedObject]? = nil
    lazy var getArrCheck = [[String:Any]]()
     var arr_CheckOut : [NSManagedObject]?
    lazy var lblIndex:Int = 0
    lazy var strCardTapped:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.register(UINib(nibName: "ReservedCell", bundle: nil), forCellReuseIdentifier: "ReservedCell")
        self.navigationController?.view.removeGestureRecognizer((self.navigationController?.interactivePopGestureRecognizer!)!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  Common.shared.addBadgetoButton(btnNoti, "2", imgNotification)
        if isComefrom == "Success" {
            lblTitleName.text = "Order Details"
            self.btnCart.isHidden  = true
        }else {
            lblTitleName.text = "Reserved Items"
            self.btnCart.isHidden  = false
        }
        fetchData()
    }
       
    //MARK:- Coredata Method
    //1
    func fetchData() {
        print("Fetching Data..")
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<Users>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedObjectContext.fetch(request)
            if result.count > 0 {
                    self.btnCheckout.isHidden =  false
                    self.btnAdditionalOrder.isHidden =  false
                lblTitleName.isHidden = false
                self.viewNorecord.isHidden = true
                viewTotal.isHidden = false
                arrData.removeAll()
                arrDuplicate = result
                arrData = Common.shared.convertToJSONArray(moArray: arrDuplicate!) as! [[String : Any]]
                self.tblList.reloadData()
                self.contblHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? CGFloat( self.arrData.count * 200) : CGFloat( self.arrData.count * 150)
                self.tblList.updateConstraintsIfNeeded()
                self.tblList.layoutIfNeeded()
                self.ViewDetailHeight.updateConstraintsIfNeeded()
                self.ViewDetailHeight.layoutIfNeeded()
                setCalculation()
            } else  {
                self.viewNorecord.isHidden = false
                lblTitleName.isHidden = true
                viewTotal.isHidden = true
                Common.shared.deleteUserDatabase()
                self.arrDuplicate = nil
                self.tblList.isHidden = true
                self.btnCheckout.isHidden = true
                self.btnAdditionalOrder.isHidden = true
            }
        } catch {
            print("Fetching data Failed")
        }
    }

    //3
    func deleteDatabase() {
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CheckoutData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try managedObjectContext.execute(deleteRequest)
           // openDatabse()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {}
    }

    func deleteUserDatabase() {
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try managedObjectContext.execute(deleteRequest)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {}
    }
    //MARK:- Tableview Method

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDuplicate?.count ??  0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var findTotalPrice = Float()
        
        let cell:ReservedCell = tblList.dequeueReusableCell(withIdentifier: "ReservedCell", for: indexPath) as! ReservedCell
        cell.lblOperatorName.text = "Operator Name: \(arrDuplicate![indexPath.row].value(forKey: "operatorName") as? String ?? "")"
        if arrDuplicate![indexPath.row].value(forKey: "occupantName") as? String != "" && arrDuplicate![indexPath.row].value(forKey:  "occupantName") as? String != "Select Occupant" {
            cell.lblRiderFullname.text = "Occupant Name: \(arrDuplicate![indexPath.row].value(forKey: "occupantName") as? String ?? "")"
            cell.conlblOccupantNameHeight.constant = 20
            cell.lblRiderFullname.layoutIfNeeded()
            cell.lblRiderFullname.updateConstraintsIfNeeded()
            
        } else {
            cell.conlblOccupantNameHeight.constant = 0
            cell.lblRiderFullname.layoutIfNeeded()
            cell.lblRiderFullname.updateConstraintsIfNeeded()
        }

        if arrDuplicate![indexPath.row].value(forKey: "strPreffWheel") as? String != "" && arrDuplicate![indexPath.row].value(forKey: "strPreffWheel") as? String != "0" {
            cell.conlbldevicePropertyHeight.constant = 15
            cell.lblDeviceProperty.text = "Wheelchair Size: " +  (arrDuplicate![indexPath.row].value(forKey: "strPreffWheel") as? String ?? "")
            cell.lblDeviceProperty.layoutIfNeeded()
            cell.lblDeviceProperty.updateConstraintsIfNeeded()
        }
         else if arrDuplicate![indexPath.row].value(forKey: "strJoyStick") as? String != "" && arrDuplicate![indexPath.row].value(forKey: "strJoyStick") as? String != "0" {
            cell.conlbldevicePropertyHeight.constant = 15
            cell.lblDeviceProperty.text = "Joystick Position: "+(arrDuplicate![indexPath.row].value(forKey: "strJoyStick") as? String ?? "")
            cell.lblDeviceProperty.layoutIfNeeded()
            cell.lblDeviceProperty.updateConstraintsIfNeeded()
        }
         else if arrDuplicate![indexPath.row].value(forKey: "strHandCon") as? String != "" && arrDuplicate![indexPath.row].value(forKey: "strHandCon") as? String != "0"{
            cell.conlbldevicePropertyHeight.constant = 15
            cell.lblDeviceProperty.text = "Hand Controller: " + (arrDuplicate![indexPath.row].value(forKey: "strHandCon") as? String ?? "")
            cell.lblDeviceProperty.layoutIfNeeded()
            cell.lblDeviceProperty.updateConstraintsIfNeeded()
        }else {
            cell.conlbldevicePropertyHeight.constant = 0
            cell.lblDeviceProperty.layoutIfNeeded()
            cell.lblDeviceProperty.updateConstraintsIfNeeded()
        }
        
        let getStrImage = arrDuplicate![indexPath.row].value(forKey: "imgPath") as? String ?? ""
        cell.lblComplimentary.text = "Complimentary Accessory: \(arrDuplicate![indexPath.row].value(forKey: "accessoryName") as? String ?? "")"
        cell.imgItem.sd_setImage(with: URL(string:AppUrl.URL.imgeBase + getStrImage), placeholderImage: UIImage(named: "image_product"))
        cell.lblItemName.text = "\(arrDuplicate![indexPath.row].value(forKey: "itemName") as? String ?? "") "
        if arrDuplicate![indexPath.row].value(forKey: "isPromoapply") as? NSNumber == 1 {
            let getFlotPrice = (arrDuplicate![indexPath.row].value(forKey: "regPrice") as!Float)  +
            (arrDuplicate![indexPath.row].value(forKey: "priceAdjustment") as!Float)
            cell.lblItemPrice.text = String(format: "Price:   $%.2f",
                                            getFlotPrice)
            cell.lblTotal.text = String(format: "Total: $%.2f (excl.tax)",((arrDuplicate![indexPath.row].value(forKey: "regPrice") as!Float)  +   (arrDuplicate![indexPath.row].value(forKey: "priceAdjustment") as!Float)  + (arrDuplicate![indexPath.row].value(forKey: "chairPadPrice") as!Float)))
        }  else if arrDuplicate![indexPath.row].value(forKey: "isRiderRewardApply") as? NSNumber == 1 {
            
            let getFlotPrice = (arrDuplicate![indexPath.row].value(forKey: "itemPrice") as!Float)  +   (arrDuplicate![indexPath.row].value(forKey: "priceAdjustment") as!Float)
            cell.lblItemPrice.text = String(format: "Price:   $%.2f",
                                            getFlotPrice)
            cell.lblTotal.text = String(format: "Total: $%.2f (excl.tax)",((arrDuplicate![indexPath.row].value(forKey: "itemPrice") as!Float)  +   (arrDuplicate![indexPath.row].value(forKey: "priceAdjustment") as!Float)  + (arrDuplicate![indexPath.row].value(forKey: "chairPadPrice") as!Float)))


        } else {
            let getFlotPrice = (arrDuplicate![indexPath.row].value(forKey: "regPrice") as!Float)  +  (arrDuplicate![indexPath.row].value(forKey: "priceAdjustment") as!Float)
            cell.lblItemPrice.text = String(format: "Price:   $%.2f",
                                            getFlotPrice)
            cell.lblTotal.text = String(format: "Total: $%.2f (excl.tax)",((arrDuplicate![indexPath.row].value(forKey: "regPrice") as!Float)  +  (arrDuplicate![indexPath.row].value(forKey: "priceAdjustment") as!Float) + (arrDuplicate![indexPath.row].value(forKey: "chairPadPrice") as!Float)))
        }
        cell.conlblChairPadHeight.constant = 0
        cell.lblChairPadPrice.layoutIfNeeded()
        cell.lblChairPadPrice.updateConstraintsIfNeeded()
        cell.lblRental.text = "Rental Period: \(arrDuplicate![indexPath.row].value(forKey: "rentalPeriod") as? String ?? "")"
        if arrDuplicate![indexPath.row].value(forKey:"isShippingAddress") as? NSNumber == 1 {
            cell.lblPickupLoc.text = "Pickup Location: \(arrDuplicate![indexPath.row].value(forKey: "pickupLoc") as! String) \n \(arrDuplicate![indexPath.row].value(forKey: "shippingAddressLine1") as! String) \n \(arrDuplicate![indexPath.row].value(forKey: "shippingAddressLine2") as! String), \(arrDuplicate![indexPath.row].value(forKey: "shippingCity")  as! String) \n \(arrDuplicate![indexPath.row].value(forKey: "shippingStateName")  as! String),\(arrDuplicate![indexPath.row].value(forKey: "shippingZipcode")  as! String) \n \(arrDuplicate![indexPath.row].value(forKey: "shippingDeliveryNote")  as? String ?? "Note:")"
        } else  {
            cell.lblPickupLoc.text = "Pickup Location: \(arrDuplicate![indexPath.row].value(forKey: "pickupLoc") as? String ?? "")"
        }
        if arrDuplicate![indexPath.row].value(forKey: "chairPadPrice") as? Float != 0 {
            cell.conlblChairPadHeight.constant = 15
            let getChairPad = String(format: "%.2f", (arrDuplicate![indexPath.row].value(forKey: "chairPadPrice")as! Float))
            cell.lblChairPadPrice.text = "Chair Pad Requirement: $\(getChairPad)"
        } else {
            cell.conlblChairPadHeight.constant = 0
        }
        cell.lblChairPadPrice.updateConstraintsIfNeeded()
        cell.lblChairPadPrice.layoutIfNeeded()
        cell.lblArrivalTime.text = "Arrival Time: \(arrDuplicate![indexPath.row].value(forKey: "arrivalTime") as? String ?? "")"
            cell.lblDepatureDate.text = "Depature Date: \(arrDuplicate![indexPath.row].value(forKey: "depatureDate") as? String ?? "")"
        cell.lblArrivalDate.text = "Arrival Date: \(arrDuplicate![indexPath.row].value(forKey: "arrivalDate") as? String ?? "")"
        cell.lblDepatureTime.text = "Depature Time: \(arrDuplicate![indexPath.row].value(forKey: "depatureTime") as? String ?? "")"
        cell.lblDestination.text = "Destination: \(arrDuplicate![indexPath.row].value(forKey: "destination") as? String ?? "")"
        let getTotal = arrDuplicate![indexPath.row].value(forKey: "total") as? String ?? "0.00"
        findTotalPrice = findTotalPrice + Float(getTotal)!
        cell.btnEditReservation.setTitle("Edit Reservation", for: .normal)
        if isComefrom == "Success" {
            cell.btnClose.isHidden = true
            cell.btnEditReservation.isHidden = true
        } else {
            cell.btnClose.isHidden = false
            cell.btnEditReservation.isHidden = false
            cell.btnEditReservation.titleLabel?.font = setFont.regular.of(size: 14)
            //cell.btnEditReservation.titleEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
            cell.btnEditReservation.imageEdgeInsets = UIEdgeInsets(top: 0, left:0, bottom: 0, right:5)
            cell.btnEditReservation.tag = indexPath.row
            cell.btnEditReservation.addTarget(self, action: #selector(btnEditClicked(_:)), for: .touchUpInside)

        }
        //isEditedOrder
        cell.btnClose.tag  = indexPath.row
        cell.btnClose.addTarget(self, action: #selector(btndeleteClicked(_:)), for: .touchUpInside)
        self.lbLPromocode.layoutIfNeeded()
        self.lbLPromocode.updateConstraintsIfNeeded()
        self.lblPromocodeValue.layoutIfNeeded()
        self.lblPromocodeValue.updateConstraintsIfNeeded()

        self.ViewDetailHeight.layoutIfNeeded()
        self.ViewDetailHeight.updateConstraintsIfNeeded()
        return cell

    }
    override func viewWillDisappear(_ animated: Bool) {
        self.isExpand = false
        self.index = -1
    }
    @objc func btnEditClicked(_ sender:UIButton) {
            strIsEditOrder = "yes"
            fetchSavedData(index: sender.tag, isCalled: "")
    }


    @objc func btndeleteClicked(_ sender:UIButton) {
        managedObjectContext.delete(arrDuplicate![sender.tag])
        do{
           try managedObjectContext.save()
            fetchData()
       } catch let error as NSError{
           print(error)
       }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.index != -1 {
            self.tblList.cellForRow(at: NSIndexPath(row: self.index, section: 0) as IndexPath)?.backgroundColor = UIColor.clear
         }
         if index != indexPath.row {
             self.isExpand = true
             self.index = indexPath.row
         } else {
             // there is no cell selected anymore
             self.isExpand = false
             self.index = -1
         }
        DispatchQueue.main.async {
            self.tblList.reloadData()
            self.tblList.layoutIfNeeded()
            self.contblHeight.constant = self.tblList.contentSize.height
            self.tblList.updateConstraintsIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == index && isExpand {
                if arrDuplicate![indexPath.row].value(forKey:"isShippingAddress") as? NSNumber == 1 {
                    if arrDuplicate![indexPath.row].value(forKey:"strDevicePropertyIds") as? String != "" && arrDuplicate![indexPath.row].value(forKey:"occupantName") as? String != "" {
                        return (UIDevice.current.userInterfaceIdiom == .pad ? 660:490)
                    } else if arrDuplicate![indexPath.row].value(forKey:"occupantName") as? String == "" &&   arrDuplicate![indexPath.row].value(forKey:"strDevicePropertyIds") as? String != "" {
                        return (UIDevice.current.userInterfaceIdiom == .pad ? 640:460)
                    } else {
                        if arrDuplicate![indexPath.row].value(forKey:"strDevicePropertyIds") as? String != "" {
                            return (UIDevice.current.userInterfaceIdiom == .pad ? 540:440)
                        } else if arrDuplicate![indexPath.row].value(forKey:"occupantName") as? String == "" &&   arrDuplicate![indexPath.row].value(forKey:"strDevicePropertyIds") as? String != "" {
                            return (UIDevice.current.userInterfaceIdiom == .pad ? 520:460)
                        }
                    }
                    return (UIDevice.current.userInterfaceIdiom == .pad ? 550:480)
                } else {
                    if arrDuplicate![indexPath.row].value(forKey:"strDevicePropertyIds") as? String != ""  && arrDuplicate![indexPath.row].value(forKey:"occupantName") as? String != ""  {
                        return (UIDevice.current.userInterfaceIdiom == .pad ? 510:410)
                    } else {
                        if arrDuplicate![indexPath.row].value(forKey:"strDevicePropertyIds") as? String == "" && arrDuplicate![indexPath.row].value(forKey:"occupantName") as? String != "" {
                            return (UIDevice.current.userInterfaceIdiom == .pad ? 450:380)
                        } else {
                            return (UIDevice.current.userInterfaceIdiom == .pad ? 420:360)
                        }
                    }
                }
            } else {
                    if arrDuplicate![indexPath.row].value(forKey: "chairPadPrice") as? Float != 0 {
                        return (UIDevice.current.userInterfaceIdiom == .pad ? 180:160)
                    } else {
                        return (UIDevice.current.userInterfaceIdiom == .pad ? 160:150)
                    }
                }
    }
    //MARK:- Proper Calculations
    func setCalculation() {
        var mainTotal = Float()
        var setSubTotal = Float()
        var totalTaxRate = Float()
        var deliveryFee =   Float()
        var arrSetofData =  Set<DeliveryFeeStruct>()
        var setNewDeliveryFee:Float = 0.0
        for i in 0..<arrData.count {
            var dict = arrData[i]
            var getStrTotal = String()
            let findTaxRate  =  dict["taxRate"] as? String ?? "0.00"
        let predicateArr =  arrData.filter{$0["isPromoapply"]as?NSNumber == 1}
        let riderRewardArr =  arrData.filter{$0["isRiderRewardApply"]as?NSNumber == 1}
        if predicateArr.count > 0  && isComefrom == "Success"{
            self.conlblPromoHeight.constant = 20
            self.conlblPromoValueHeight.constant = 20
            if predicateArr[0]["promotionType"]as? NSNumber == 1 {
                lblPromocodeValue.text = "$\(predicateArr[0]["promoValue"] as? String ?? "").off"
            } else {
                lblPromocodeValue.text = "\(predicateArr[0]["promoValue"] as? String ?? "")%.off"

            }
        } else if riderRewardArr.count > 0  && isComefrom == "Success"{
            self.conlblPromoHeight.constant = 20
            self.lbLPromocode.text = "Price Adjustment: Bonus Day(s)"
            self.conlblPromoValueHeight.constant = 20
            lblPromocodeValue.text = "-$\(riderRewardArr[0]["priceAdjustment"] as!Float).off"
            
        } else {
            self.conlblPromoHeight.constant = 0
            self.conlblPromoValueHeight.constant = 0
        }
        self.lbLPromocode.updateConstraintsIfNeeded()
        self.lbLPromocode.layoutIfNeeded()
        self.lblPromocodeValue.updateConstraintsIfNeeded()
        self.lblPromocodeValue.layoutIfNeeded()
        let arrTime =   dict["arrivalTime"] as! String
        let arrDate = dict["arrivalDate"] as! String
        let combineString = arrDate + arrTime
                            if arrSetofData.contains(where: {subdict in (subdict.arrivalDate_Time == combineString) && (subdict.loctionId == dict["destinationId"]as? Int) }) {
                                setNewDeliveryFee = 0
                            } else {
                                let createDict = DeliveryFeeStruct()
                                deliveryFee = deliveryFee + Float(dict["deliveryFee"] as? String ?? "0.00")!
                                createDict.loctionId = dict["destinationId"] as? Int
                                createDict.arrivalDate_Time = combineString
                                arrSetofData.insert(createDict)
                                dict["itemDeliveryFee"] = Float(dict["deliveryFee"] as? String ?? "0.00")!
                                setNewDeliveryFee = Float(dict["deliveryFee"] as? String ?? "0.00")!
            }
            if dict["isPromoapply"] as? NSNumber == 1 {
                if isComefrom == "Success"{
                    getStrTotal = "\((dict["itemPrice"] as! Float) + (dict["chairPadPrice"] as! Float) )"
                    let getFlotPriceTax = ((dict["itemPrice"] as!Float)  +  (dict ["chairPadPrice"] as!Float) + (dict["priceAdjustment"] as!Float) + setNewDeliveryFee )  * ((Float(findTaxRate)!)/100)
                    totalTaxRate = Float((getFlotPriceTax)) + (totalTaxRate*100).rounded() / 100
                    setSubTotal = Float(getStrTotal)! + setSubTotal //1
                } else {
                    getStrTotal = "\((dict["regPrice"] as! Float) + (dict["chairPadPrice"] as! Float) )"
                    let getFlotPriceTax = ((dict["regPrice"] as!Float)  +  (dict ["chairPadPrice"] as!Float) + (0.00) + setNewDeliveryFee )  * ((Float(findTaxRate)!)/100)
                    totalTaxRate = Float((getFlotPriceTax)) + (totalTaxRate*100).rounded() / 100
                    setSubTotal = Float(getStrTotal)! + setSubTotal //1
                }

            } else if dict["isRiderRewardApply"]as?NSNumber == 1 {
                if isComefrom == "Success"{
                    let price  = (dict["itemPrice"] as! Float)
                    let chairPad  = (dict["chairPadPrice"] as! Float)
                    let strTotal = price + chairPad
                    getStrTotal = "\(strTotal)"
                    let getFlotPriceTax = ((dict["itemPrice"] as!Float)  +  (dict ["chairPadPrice"] as!Float)  + setNewDeliveryFee )  * ((Float(findTaxRate)!)/100)
                    totalTaxRate = Float(getFlotPriceTax) + (totalTaxRate*100).rounded() / 100
                    setSubTotal = Float(getStrTotal)! + setSubTotal //1
                } else {
                    let price  = (dict["itemPrice"] as! Float)
                    let chairPad  = (dict["chairPadPrice"] as! Float)
                    let priceADj = (dict["priceAdjustment"] as! Float)
                    let strTotal = price + chairPad + priceADj
                    getStrTotal = "\(strTotal)"
                    let getFlotPriceTax = ((dict["itemPrice"] as!Float)  +  (dict ["chairPadPrice"] as!Float) + (dict["priceAdjustment"] as!Float) + setNewDeliveryFee )  * ((Float(findTaxRate)!)/100)
                    totalTaxRate = Float(getFlotPriceTax) + (totalTaxRate*100).rounded() / 100
                    setSubTotal = Float(getStrTotal)! + setSubTotal //1
                }
            } else {
                
                getStrTotal = (dict["total"] as?String ?? "0.00")
                let price  = (dict["regPrice"] as! Float)
                let chairPad  = (dict["chairPadPrice"] as! Float)
                let priceADj = (dict["priceAdjustment"] as! Float)
                let getFlotPriceTax = (((price + chairPad + priceADj) + setNewDeliveryFee) * ((Float(findTaxRate)!)/100))
                totalTaxRate = Float(getFlotPriceTax) + (totalTaxRate*100).rounded() / 100
                setSubTotal = Float(getStrTotal)! + setSubTotal //1
            }
        }

        self.lblsubTotal.text = String(format: "$%.2f (excl.tax)", setSubTotal)
        self.lblDeliveryFee.text = String(format: "$%.2f (excl.tax)", deliveryFee)
        mainTotal = setSubTotal  +  deliveryFee + (totalTaxRate)
        
        taxRate = totalTaxRate
        flotPricewithTax = (mainTotal * 100).rounded() / 100
        self.lblTotal.text = String(format: "$%.2f", (mainTotal*100).rounded() / 100)
        lblgstTax.text = String(format: "(Include $%.2f Tax)", totalTaxRate)
        TaxRate = totalTaxRate
        self.lbLPromocode.updateConstraintsIfNeeded()
        self.lbLPromocode.layoutIfNeeded()
        self.lblPromocodeValue.updateConstraintsIfNeeded()
        self.lblPromocodeValue.layoutIfNeeded()
        self.ViewDetailHeight.updateConstraintsIfNeeded()
        self.ViewDetailHeight.layoutIfNeeded()
    }

    func fetchAndUpdateDeliveryFee(newdeliveryFee:Float,index:Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do{
            let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
            let  dict =  result[index]
            dict.setValue("\(newdeliveryFee)", forKey: "deliveryFee")
            try managedObjectContext.save()
            let result1 = try managedObjectContext.fetch(request) as! [NSManagedObject]
            arrData = Common.shared.convertToJSONArray(moArray: result1) as! [[String : Any]]
        } catch {
                print("Fetching data Failed")
            }
    }
    
    
    //MARK:- Edited Order Manage
    func fetchSavedData(index:Int,isCalled:String) {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do{
            let result = try managedObjectContext.fetch(request) as! [NSManagedObject]
            for dict in result as [NSManagedObject] {
                if dict.value(forKey: "isEditedOrder") as? Int == 1 {
                    dict.setValue(0, forKey: "isEditedOrder")
                }
            }
            if isCalled == "back"{
                APP_DELEGATE.dictEditedData = [:]
                let lastObj = result.last
                APP_DELEGATE.itemName = lastObj?.value(forKey: "itemName") as? String ?? ""
                APP_DELEGATE.shortDesc = lastObj?.value(forKey: "itemDesc") as? String ?? ""
                APP_DELEGATE.deviceTypeId = lastObj?.value(forKey: "deviceTypeId") as! Int
                lastObj?.setValue(1, forKey: "isEditedOrder")
                try managedObjectContext.save()
                let result1 = try managedObjectContext.fetch(request) as! [NSManagedObject]
                arrData = Common.shared.convertToJSONArray(moArray: result1) as! [[String : Any]]
                APP_DELEGATE.dictEditedData = arrData.last!
                self.navigationController?.popViewController(animated: true)
            } else {
                APP_DELEGATE.dictEditedData = [:]
                let mangedObj = result[index]
                APP_DELEGATE.deviceTypeId = mangedObj.value(forKey: "deviceTypeId") as! Int
                APP_DELEGATE.itemName = mangedObj.value(forKey: "itemName") as? String ?? ""
                mangedObj.setValue(1, forKey: "isEditedOrder")
                try managedObjectContext.save()
                let result1 = try managedObjectContext.fetch(request) as! [NSManagedObject]
                arrData = Common.shared.convertToJSONArray(moArray: result1) as! [[String : Any]]
                APP_DELEGATE.dictEditedData = arrData[index]
                let help = AddReservationVC.instantiate(fromAppStoryboard: .DashBoard)
                APP_DELEGATE.shortDesc = arrData[index]["itemDesc"] as? String ?? ""
                self.navigationController?.pushViewController(help, animated:false)
            }
        } catch {
            print("Fetching data Failed")
        }
    }
    //MARK:- Action Method

    @IBAction func btnAdditionalOrderClick(_ sender: Any) {
        strSubTotal = self.lblsubTotal.text!
        strDeliveryFee = self.lblDeliveryFee.text!
        strTotal = self.lblTotal.text!
       // self.navigationController?.popToRootViewController(animated: false)
        APP_DELEGATE.setHomeRootVC()
    }
    
    @IBAction func btnCheckoutClick(_ sender: Any) {
        
        
        let help = Checkout_NewVC.instantiate(fromAppStoryboard: .CheckOut)
        strSubTotal = self.lblsubTotal.text!
        strDeliveryFee = self.lblDeliveryFee.text!
        strTotal = self.lblsubTotal.text!
        help.arrData.removeAll()
        help.arrData = arrData
        self.navigationController?.pushViewController(help, animated: true)
    }
    
    @IBAction func btnReturnMenuClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnHomeClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnBackClick(_ sender: Any) {
            //strIsEditOrder = "back"
            if  viewNorecord.isHidden == true {
                if strCardTapped == "cart" {
                    strIsEditOrder = "nop"
                    self.navigationController?.popViewController(animated: true)
                } else {
                    strCardTapped = ""
                    strIsEditOrder = "back"
                    fetchSavedData(index: 0, isCalled: "back")
                }
            } else {
                //self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.popViewController(animated: true)

            }
        }
    
}
class DeliveryFeeStruct:NSObject {
    var loctionId: Int?
    var arrivalDate_Time: String?
}
