//
//  NotificationVC.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 24/02/22.
//  Copyright © 2022 Verve_Sys. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class NotificationVC: SuperViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: -Define Outlets
    @IBOutlet weak var tblNotificationList: UITableView!
    @IBOutlet weak var lblNoNotification: UILabel!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnCart: AddBadgeToButton!

    var arrNotification = [JSON]()
    
    //MARK: -Define View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Common.shared.checkCartCount(btnCart)
        btnMenu.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: .touchUpInside)
        tblNotificationList.rowHeight = UITableView.automaticDimension
        tblNotificationList.estimatedRowHeight = 60
        callApi(completionHandler: {_ in})
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            self.callMarkReadApi(completionHandler: {_ in Utils.hideProgressHud()})
    }
    
    //MARK: -Define tableView cycle
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotificationList.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let arrDATE = arrNotification[indexPath.row]["CreatedDate"].stringValue.components(separatedBy: " ")
        cell.lblNotificationDate.text = "DATE: \(arrDATE[0]) Time: \(arrDATE[1])"
        cell.lblNotificationTitle.text = arrNotification[indexPath.row]["Title"].stringValue
        cell.txtNotificationDesc.text =   arrNotification[indexPath.row]["Body"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    //MARK: -Define Button Method
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
            } catch {print("Fetching data Failed")}
    }

    //MARK: -call Api
    func callApi(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let getToken = USER_DEFAULTS.value(forKey: AppConstants.TOKEN)
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Notification.getNotificationList
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":"\(getToken!)","DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:nil, httpMethodForGetOrPost: .post, setheaders: header) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        Utils.hideProgressHud()
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {
                            self.lblNoNotification.isHidden = true
                            self.arrNotification = dicResponseData["pushNotificationLogs"]?.arrayValue ?? []
                            self.arrNotification.count > 0 ? self.shortDateAsscending() : self.hideTableRecord()
                            
                            completionHandler(true)
                        }
                        }
                    } else {
                        Utils.hideProgressHud()
                        completionHandler(false)
                    }
        }
    }
    func hideTableRecord() {
        self.lblNoNotification.isHidden = false
        self.tblNotificationList.isHidden = true
    }
    func shortDateAsscending() {
        self.lblNoNotification.isHidden = true
        self.tblNotificationList.isHidden = false
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy HH:mm:ss"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(identifier: "UTC")!
        self.arrNotification = self.arrNotification.sorted {df.date(from: $0["CreatedDate"].stringValue)! > df.date(from: $1["CreatedDate"].stringValue)!}
        DispatchQueue.main.async {
            self.tblNotificationList.reloadData()
        }

    }
    
    func callMarkReadApi(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let getToken = USER_DEFAULTS.value(forKey: AppConstants.TOKEN)
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Notification.setNotificationReadStatus
        let header:HTTPHeaders = ["Content-Type":"application/json","LoggedOn":"3","token":"\(getToken!)","DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]
        Utils.showProgressHud()
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:nil, httpMethodForGetOrPost: .post, setheaders: header) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        Utils.hideProgressHud()
                        if dicResponseData["StatusCode"]?.stringValue == "OK" {completionHandler(true)}
                        }
                    } else {
                        Utils.hideProgressHud()
                        completionHandler(false)
                    }
        }
    }
}
