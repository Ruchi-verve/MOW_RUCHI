//
//  ProductDetail_NewVC.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 28/10/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import WebKit
import CoreData
class ProductDetail_NewVC: SuperViewController,UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate {

    
    var dataSourceRate:GenericDataSource<Any>!
    var arrDataRate = [JSON]()

    @IBOutlet weak var lblDetail: UILabel!
    
    @IBOutlet weak var btnDesc: UIButton!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var btnCart: AddBadgeToButton!
    @IBOutlet weak var contblPriceHeight: NSLayoutConstraint!
    @IBOutlet weak var tblPrice: UITableView!
    @IBOutlet weak var lblItemHeaderName: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var webDesc: WKWebView!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnNotif: AddBadgeToButton!
    @IBOutlet weak var webShortDesc: WKWebView!
    @IBOutlet weak var conWebHeight: NSLayoutConstraint!
    @IBOutlet weak var conWebDescHeight: NSLayoutConstraint!
    @IBOutlet weak var viewRate: UIView!
    @IBOutlet weak var viewDesc: UIView!

    
   lazy  var dictProdDetail = DeviceTypeSubResModel()
    lazy var dictProdDetailRes = ProductDetailRes()
    lazy var dictRentalRateRes = RentalRateRes()

    lazy var arrChairpadReq = [DevicePropertySubResModel]()
    lazy var arrJoystickPos = [DevicePropertySubResModel]()
    lazy var arrHandController = [DevicePropertySubResModel]()
    lazy var arrPrefferedWheelchairSize = [DevicePropertySubResModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
       // Common.shared.addBadgetoButton(btnNotif, "2", imgNotification)
        let path = Bundle.main.path(forResource: "style", ofType: "css")
       let cssString = try! String(contentsOfFile: path!).components(separatedBy: .newlines).joined()
       let source = """
       var style = document.createElement('style');
       style.innerHTML = '\(cssString)';
       document.head.appendChild(style);
       """
       let userScript = WKUserScript(source: source,
                                     injectionTime: .atDocumentEnd,
                                     forMainFrameOnly: true)
       let userContentController = WKUserContentController()
       userContentController.addUserScript(userScript)
       let configuration = WKWebViewConfiguration()
       configuration.userContentController = userContentController
       
        webDesc.navigationDelegate = self
        webDesc.scrollView.isScrollEnabled = false
        webDesc.scrollView.bounces = false

        webShortDesc.navigationDelegate = self
         webShortDesc.scrollView.isScrollEnabled = false
         webShortDesc.scrollView.bounces = false
        
        self.callApiforProductDesc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    func setupUI(){
        tblPrice.register(UINib(nibName: "PriceCell", bundle: nil), forCellReuseIdentifier:"PriceCell")
        viewRate.isHidden = true
        btnLocation.setTitle(UserDefaults.standard.string(forKey: AppConstants.SelDest), for: .normal)
        lblItemName.text = dictProdDetail.ItemName
        
       // self.updateTableData(isDesc: true)
    }
    //MARK: - Webview Delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == webShortDesc {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                self.conWebHeight.constant  = height as! CGFloat
            })

        } else {
            webDesc.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            self.conWebDescHeight.constant  = height as! CGFloat

        })
}
        
    }

    //MARK: - UIAction

    @IBAction func btnDescClick(_ sender: Any) {
//        conWebHeight.constant = 0
//        conWebDescHeight.constant = 0
        self.updateTableData(isDesc: true)
    }
    @IBAction func btnHomeClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnRateClick(_ sender: Any) {
        self.updateTableData(isDesc: false)
    }
    @IBAction func btnCartClick(_ sender: Any) {
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<Users>(entityName: "Users")
        do{
            let result = try managedObjectContext.fetch(request)
            if result.count > 0 {
                let managedObject = result[0]
                if managedObject.isExtendOrder == "yes" {
                    strIsEditOrder = "extend"
                    let help = ExtendReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                    self.navigationController?.pushViewController(help, animated: true)
                } else {
                    strIsEditOrder = ""
                    let activeOrder = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                    self.navigationController?.pushViewController(activeOrder, animated: true)
                }
            } else {
                        strIsEditOrder = ""
                let activeOrder = ReservedVC.instantiate(fromAppStoryboard: .DashBoard)
                        self.navigationController?.pushViewController(activeOrder, animated: true)
                }
            }catch {
            print("Fetching data Failed")
        }
    }

    @IBAction func btnSelectDestClick(_ sender: Any) {
//        let loginScene = SelectDest.instantiate(fromAppStoryboard: .Login)
//        self.present(loginScene, animated: true, completion: nil)
        

        for controller in self.navigationController!.viewControllers as Array {
                   if controller.isKind(of: HomeVC.self) {
                       let getVC = controller as! HomeVC
                       getVC.isOpenFrom = "dest"
                       self.navigationController!.popToViewController(getVC, animated: true)
                       break
                   }
               }

    }

    @IBAction func btnAddClick(_ sender: Any) {
        let help = AddReservationVC.instantiate(fromAppStoryboard: .DashBoard)
        APP_DELEGATE.itemName = self.lblItemName.text!
        strIsEditOrder = ""
        help.getImagePath = self.dictProdDetailRes.itemImagePath
        intChairPadReqId = 0
        intHandControllerId = 0
        intPrefferedWheelchairSizeId = 0
        intJoystickPosId = 0
        OccuId = 0
        help.strDevicePropertyIDs = self.dictProdDetailRes.devicePropertyIDs
        APP_DELEGATE.shortDesc = self.dictProdDetailRes.itemShortDescription
        IsOccupantSame = dictProdDetailRes.operatorOccupantSame
        self.navigationController?.pushViewController(help, animated: true)
    }
    //MARK: - HTML Content

    func loadHTMLContent(_ htmlContent: String,_ payScale:Float , _ webView:WKWebView) {
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=\(payScale), shrink-to-fit=no\"></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

    //MARK: - UIableview Deleagte
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrDataRate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:PriceCell = tblPrice.dequeueReusableCell(withIdentifier: "PriceCell", for: indexPath) as! PriceCell
            cell.tag = indexPath.row
    
        let arrGet =  arrDataRate[indexPath.row].stringValue.components(separatedBy: "*")
        cell.lblPrice.text = arrGet.count > 1 ? arrGet[1] :arrGet[0]
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 30
    }
    

    //Mark: - Function
    
    func updateTableData(isDesc: Bool)  {
        if isDesc {
            self.lblDetail.text = "Product Description"
            self.btnDesc.setTitleColor(UIColor.white, for: .normal)
            self.btnRate.setTitleColor(UIColor.black, for: .normal)
            self.btnDesc.backgroundColor = AppConstants.kColor_Primary
            self.btnRate.backgroundColor = UIColor.white
            self.viewRate.isHidden = true
            self.viewDesc.isHidden = false
        } else {
            self.lblDetail.text = "Rate do not include tax"
            self.btnDesc.setTitleColor(UIColor.black, for: .normal)
            self.btnRate.setTitleColor(UIColor.white, for: .normal)
            self.btnDesc.backgroundColor = UIColor.white
            self.btnRate.backgroundColor = AppConstants.kColor_Primary
            self.viewDesc.isHidden = true
            self.viewRate.isHidden = false
            self.callApiforRentalRate()
        }
    }

    //MARK: - Call Api
    func callApiforProductDesc(){
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getDeviceTypebyId
        let getDesId = dictProdDetail.DeviceTypeID
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(getDesId)") {[weak self] (dicResponseWithSuccess ,_)  in
                        if let weakSelf = self {
                            if  let jsonResponse = dicResponseWithSuccess {
                                guard jsonResponse.dictionary != nil else {
                                    return
                                }
                                if let dicResponseData = jsonResponse.dictionary {
                                    weakSelf.dictProdDetailRes = ProductDetailRes().initWithDictionary(dictionary: dicResponseData)
                                    if weakSelf.dictProdDetailRes.statusCode == "OK"{
                                        do{
                                            weakSelf.loadHTMLContent(weakSelf.dictProdDetailRes.itemShortDescription, 0.7, weakSelf.webShortDesc)
                                            weakSelf.loadHTMLContent(weakSelf.dictProdDetailRes.itemFullDescription, 0.8,weakSelf.webDesc)
                                        }
                                        getchairPadPrice = Float(weakSelf.dictProdDetailRes.chairPadPrice)
                                        weakSelf.imgItem.sd_setImage (with: URL(string:AppUrl.URL.imgeBase + weakSelf.dictProdDetailRes.itemImagePath), placeholderImage: UIImage(named: "image_product"))
                                        Utils.hideProgressHud()
                                    }
                                        else {
                                            Utils.hideProgressHud()
                                            Utils.showMessage(type: .error, message: weakSelf.dictProdDetailRes.message)
                                        }
                                    }
                                } else {
                                    Utils.hideProgressHud()
                                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                                }
                            }
                    else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                    }
                        }
        
    }
    
    
    func callApiforRentalRate(){
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()

        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getRentalRatesbyDeviceId
let getToken  = USER_DEFAULTS.value(forKey: AppConstants.TOKEN) as? String ?? ""
        let getDesId = dictProdDetail.DeviceTypeID
        let param = ["DeviceTypeID":getDesId,
                     "LocationID":USER_DEFAULTS.value(forKey: AppConstants.selDestId) ??  0 , "IsCompPriceRequested":false]
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":getToken,"DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:param, httpMethodForGetOrPost: .post, setheaders: header) {[weak self] (dicResponseWithSuccess ,_)  in
            if let weakSelf = self {
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        
                        weakSelf.dictRentalRateRes = RentalRateRes().initWithDictionary(dictionary: dicResponseData)

                        if weakSelf.dictRentalRateRes.statusCode == "OK" {
                            Utils.hideProgressHud()
                            weakSelf.arrDataRate = weakSelf.dictRentalRateRes.arrRentalRate
                                weakSelf.tblPrice.reloadData()
                            weakSelf.contblPriceHeight.constant = CGFloat(weakSelf.arrDataRate.count * 30)
                        }
                        else {
                            Utils.hideProgressHud()
                            Utils.showMessage(type: .error, message: weakSelf.dictRentalRateRes.message)
                        }
                       
                    } else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                    }
                    
                } else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)

                }
                
            }
        }
}
    
 
    

}
