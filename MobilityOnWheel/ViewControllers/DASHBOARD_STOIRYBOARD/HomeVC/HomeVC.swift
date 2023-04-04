//
//  HomeVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 24/05/21.
//

import UIKit
import SDWebImage
import CoreData
import AVFoundation

class HomeVC: SuperViewController , UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
     @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet var clvProduct: UICollectionView!
    @IBOutlet var viewStackProduction:UIView!
    @IBOutlet var viewEquipment:UIView!
    @IBOutlet var viewInsideEquipment:UIView!
    @IBOutlet var btnSave:UIButton!
    @IBOutlet var txtEquipment:UITextField!
    @IBOutlet var btnClose:UIButton!
    @IBOutlet var conCollProductHeight:NSLayoutConstraint!
    @IBOutlet var btnLocation:UIButton!
    @IBOutlet var btnCart:AddBadgeToButton!
    @IBOutlet weak var btnNotification: AddBadgeToButton!

   lazy var arrProductList = [DeviceTypeSubResModel]()
    lazy var dictProdctRes = DeviceTypeModel()
    lazy var OrderId = Int()
    lazy var dictExtendRes = ExtendOrderRes()
    lazy var dictOpeInfo = OccupantListModel()
    lazy var prevCellHeight: CGFloat = 0
    lazy var EquipOrderId = Int()
    lazy var isOpenFrom = String()
    //MARK: -View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtEquipment.keyboardType = .default
        if self.isOpenFrom == "dest" {
            let loginScene = SelectDest_view.instantiate(fromAppStoryboard: .DashBoard)
            loginScene.modalPresentationStyle = .overFullScreen
            loginScene.modalTransitionStyle = .crossDissolve
            present(loginScene, animated: true)
        }
        if UserDefaults.standard.integer(forKey: AppConstants.selDestId) != 0 {
            self.callParallelAPi()
        }
        Common.shared.checkCartCount(btnCart)
        self.navigationController?.navigationBar.isHidden = true
        btnMenu.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: UIControl.Event.touchUpInside)
    }
    
    func callRewardPointApi() {
        Utils.showProgressHud()
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
    }
    //MARK: -UI Update
    func SetUI(){
        viewEquipment.isHidden = true
        btnMenu.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: UIControl.Event.touchUpInside)
        clvProduct.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: ProductCellID)
        btnLocation.setTitle(UserDefaults.standard.string(forKey: AppConstants.SelDest), for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isOpenFrom = ""
        prevCellHeight = 0
    }
    
    //MARK: -IBACtion Method
    @IBAction func btnSelectdestClick(_ sender: Any) {
        self.view.endEditing(true)
        let loginScene = SelectDest_view.instantiate(fromAppStoryboard: .DashBoard)
        loginScene.modalPresentationStyle = .overFullScreen
        loginScene.modalTransitionStyle = .crossDissolve
        present(loginScene, animated: true)
    }
    
    @IBAction func btnNotificationClick(_ sender: Any) {
        self.view.endEditing(true)
        let loginScene = NotificationVC.instantiate(fromAppStoryboard: .DashBoard)
        self.navigationController?.pushViewController(loginScene, animated: true)
    }
    @IBAction func btnCartClick(_ sender: Any) {
        self.view.endEditing(true)
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
            } catch {
            print("Fetching data Failed")
        }
    }

    @IBAction func btnCloseClick(_ sender: Any) {
        self.view.endEditing(true)
        self.viewEquipment.isHidden = true
    }
    
    @IBAction func btnSaveClick(_ sender: Any) {
        self.view.endEditing(true)
        guard  let name  = txtEquipment.text, name != "" , !name.isEmpty else {
            return  Utils.showMessage(type: .error,message: "Please enter equipment id")
        }
        
        self.callCheckEquipIDApi(EquipOrderId:OrderId, completionHandler: {success in
            if success == true {
                Utils.hideProgressHud()
                self.viewEquipment.isHidden = true
            } else {
                Utils.hideProgressHud()
            }
        })
    }
    
    //MARK: -CollectionView method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell  {
        let cell:ProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCellID, for: indexPath) as! ProductCell
        cell.actiIndi.isHidden  = false
        cell.actiIndi.startAnimating()
        cell.lblproductName.text = arrProductList[indexPath.row].ItemName
        cell.lblproductPrice.text = arrProductList[indexPath.row].RegularPriceDescription
        DispatchQueue.main.async {
            cell.imgproductImage.sd_setImage(with: URL(string:AppUrl.URL.imgeBase + self.arrProductList[indexPath.row].ItemImagePath), completed: { (image, error, cacheType, imageURL) in
                cell.actiIndi.isHidden = true
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = ProductDetail_NewVC.instantiate(fromAppStoryboard: .DashBoard)
        product.dictProdDetail = self.arrProductList[indexPath.row]
        APP_DELEGATE.deviceTypeId = self.arrProductList[indexPath.row].DeviceTypeID
        self.navigationController?.pushViewController(product, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if UIDevice.current.userInterfaceIdiom == .pad {
                let getlblProNameHeight = getHeightForLable(labelWidth:(clvProduct.frame.width / 2) - 40, labelText: arrProductList[indexPath.row].ItemName, labelFont: setFont.regular.of(size: 20)!)
                let getlblProDescHeight = arrProductList[indexPath.row].RegularPriceDescription.height(withConstrainedWidth: (clvProduct.frame.width / 2) - 40, font: setFont.bold.of(size: 15)!)
                let setheight = getlblProDescHeight + getlblProNameHeight + 190
                if indexPath.row % 2  == 0 {
                    if  indexPath.row == 0 && prevCellHeight == 0 {
                        prevCellHeight = setheight
                    }else if indexPath.row == arrProductList.count - 1 {
                        prevCellHeight = setheight
                    } else {
                        if prevCellHeight < setheight {
                            prevCellHeight = setheight
                        }
                    }
                } else {
                    if prevCellHeight < setheight {
                        prevCellHeight = setheight
                    }
                }
                return CGSize(width: (clvProduct.frame.size.width / 2) - 5 , height:prevCellHeight)
            } else {
                let getlblProNameHeight = getHeightForLable(labelWidth:(clvProduct.frame.width / 2) - 40, labelText: arrProductList[indexPath.row].ItemName, labelFont: setFont.regular.of(size: 14)!)
                let getlblProDescHeight = arrProductList[indexPath.row].RegularPriceDescription.height(withConstrainedWidth: (clvProduct.frame.width / 2) - 40, font: setFont.bold.of(size: 11)!) + (DeviceType.iPhoneXs == true ? 0 : 20)
                let setheight = getlblProDescHeight + getlblProNameHeight + 170
                if indexPath.row % 2  == 0 {
                    if  indexPath.row == 0 && prevCellHeight == 0 {
                        prevCellHeight = setheight
                    }else if indexPath.row == arrProductList.count - 1 {
                        prevCellHeight = setheight
                    }else {
                        if prevCellHeight < setheight {
                            prevCellHeight = setheight
                        }
                    }
                } else {
                    if prevCellHeight < setheight {
                        prevCellHeight = setheight
                    }
                }
                return CGSize(width: (clvProduct.frame.size.width / 2) - 5 , height:prevCellHeight)
            }
}

    func getHeightForLable(labelWidth: CGFloat, numberOfLines: Int = 0, labelText: String, labelFont: UIFont) -> CGFloat {
            let tempLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
            tempLabel.numberOfLines = numberOfLines
            tempLabel.text = labelText
            tempLabel.font = labelFont
            tempLabel.lineBreakMode = .byTruncatingTail
            tempLabel.sizeToFit()
            return ceil(tempLabel.frame.height)
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (UIDevice.current.userInterfaceIdiom == .pad ? 20 : 10)
    }
     
    //MARK: -Call Api
    
    func callParallelAPi() {
        Utils.showProgressHud()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter() // <<---
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        dispatchGroup.enter()// <<---
        Utils.showProgressHud()
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        self.callProductListApi(completionHandler: {(succcess) in
            if succcess == true {
                DispatchQueue.main.async {
                    self.clvProduct.reloadData()
                }
                Utils.hideProgressHud()
                dispatchGroup.leave()
            }
        })
        dispatchGroup.notify(queue: .main) {
            Utils.hideProgressHud()
        }
        dispatchGroup.enter()// <<---
        CommonApi.callNotificationBadgeInfo(completionHandler: {success in
            if success == true {
                Common.shared.addBadgetoButton(self.btnNotification,"\(NotificationBadge)", "icon_notification")
                Utils.hideProgressHud()
                dispatchGroup.leave()
            }
        })
    }
    func callCheckEquipIDApi(EquipOrderId:Int,completionHandler: @escaping  (Bool) -> ()){
        Utils.showProgressHud()
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Home.setEquipmentID
        let param = ["DeviceInventoryID":self.txtEquipment.text!,"OrderID":EquipOrderId] as [String : Any]
       API_SHARED.callCommonParseApiwithDictParameter(strUrl:apiUrl, passValue:param ) { (dicResponseWithSuccess ,_)  in
      
           if  let jsonResponse = dicResponseWithSuccess {
               guard jsonResponse.dictionary != nil else {
                   return
               }
               if let dicResponseData = jsonResponse.dictionary {
                   print("Response in:\(dicResponseData)")
                   if dicResponseData["StatusCode"]?.stringValue == "OK"{
                       completionHandler(true)

                   } else {
                       completionHandler(false)
                   }

               }
           } else {
               Utils.hideProgressHud()
               completionHandler(false)
           }
       }
    }

    func callgetDefaultOperator(opeid:Int,completionHandler: @escaping  (Bool) -> ()){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.getOperatorByID
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(opeid)") { (dicResponseWithSuccess ,_)  in
        if  let jsonResponse = dicResponseWithSuccess {
            guard jsonResponse.dictionary != nil else {
                return
            }
            if let dicResponseData = jsonResponse.dictionary {
                
                if dicResponseData["StatusCode"]?.stringValue == "OK" {
                    
                    self.dictOpeInfo  = OccupantListModel().initWithDictionary(dictionary: dicResponseData)
                    Utils.hideProgressHud()
                    completionHandler(true)
                    
                } else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: dicResponseData["Message"]?.stringValue ?? AppConstants.ErrorMessage)
                    completionHandler(false)

                }
            }
         else {
            Utils.hideProgressHud()
            Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
        }
    } else {
        Utils.hideProgressHud()
        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
    }
}
        
}

    
   

    func callProductListApi(completionHandler: @escaping  (Bool) -> ()) {
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Location.getDevicebyLocationId
        let getDesId = USER_DEFAULTS.value(forKey: AppConstants.selDestId) ?? 0
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(getDesId)") { (dicResponseWithSuccess ,_)  in
            if  let jsonResponse = dicResponseWithSuccess {
                guard jsonResponse.dictionary != nil else {
                    return
                }
                if let dicResponseData = jsonResponse.dictionary {
                    self.dictProdctRes = DeviceTypeModel().initWithDictionary(dictionary: dicResponseData)
                    
                    if self.dictProdctRes.statusCode == "OK" {
                        self.arrProductList = self.dictProdctRes.arrProductList
                        DispatchQueue.main.async {
                            self.clvProduct.reloadData()
                            self.clvProduct.layoutIfNeeded()
                        }
                        completionHandler(true)
                        
                    } else {
                        Utils.hideProgressHud()
                        Utils.showMessage(type: .error, message: APP_DELEGATE.dictActiveOrderRes.message)
                        completionHandler(false)
                        
                    }
                }
            } else {
                Utils.hideProgressHud()
                Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                completionHandler(false)
            }
        }
    }
    
    func callExtendOrderApi(OrderId:Int,completionHandler: @escaping  (Bool) -> ()) {
            if !InternetConnectionManager.isConnectedToNetwork() {
                Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
                return
            }
            Utils.showProgressHud()
            let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.getOrderHistoryDetail
        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: self, passValue: "\(OrderId)") { (dicResponseWithSuccess ,_)  in
                                if  let jsonResponse = dicResponseWithSuccess {
                                    guard jsonResponse.dictionary != nil else {
                                        return
                                    }
                                    if let dicResponseData = jsonResponse.dictionary {
                                        self.dictExtendRes = ExtendOrderRes().initWithDictionary(dictionary: dicResponseData)
                
                                        if self.dictExtendRes.statusCode == "OK"  &&  self.dictExtendRes.message == "" {
                                            completionHandler(true)
                                            Utils.hideProgressHud()
                                            
                                        } else{
                                            Utils.hideProgressHud()
                                            completionHandler(false)
                                        }
                                }
                                    } else {
                                        Utils.hideProgressHud()
                                        Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                                        completionHandler(false)
                                    }
                            }
        }

    func callCheckReturnDevice(activeOrderId:Int,completionHandler: @escaping  (Bool) -> ()) {
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.checkReturnOrder
        API_SHARED.callCommonParseApiwithboolRes(strUrl: apiUrl, passValue: "\(activeOrderId)") { (dicResponseWithSuccess ,_)  in
            if dicResponseWithSuccess ==  false {
                completionHandler(true)
            }
        }
    }
    
    
}
