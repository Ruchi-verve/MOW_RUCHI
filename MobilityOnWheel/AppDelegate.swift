//
//  AppDelegate.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 20/05/21.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import CoreData
import SwiftyJSON
import FirebaseCore
import FirebaseCrashlytics
import UserNotifications
import FirebaseMessaging
import FirebaseDynamicLinks

//ADD MessagingDelegate for Turn OnPush
//DATA CHANGED
var scrFlag = 0

enum AppStoryboard : String {
    case Login,History,CheckOut,DashBoard
    var instance : UIStoryboard {
      return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
         
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }

}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,MessagingDelegate {

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var navVC:UINavigationController?
    var isAgree:Bool = false
    var dictActiveOrderRes = ActiveOrderResModel()
    var arrActiveOrder = [ActiveOrderSubRes]()
    var strDest = String()
    var arrGetState = [StateSubListModel]()
    var dictGetState = StateListModel()
    var arrOperatorList = [OperatorListSubRes]()
    var dictApiRes =  OperatorListModel()
    var arrgetPickupLoc =  [PickupLocationModelSubRes]()
    var dictgetPickupLoc =  PickupLocationModel()
    var itemName  = String()
    var rewardPoint  = Int()
    var getPaymentProfileId :Int = 0
    var arrPassData = [[String:Any]]()
    var isComeFrom  = String()
    var strtxtDisplay = String()
    var arrSaveOperatorList =  [[String:Any]]()
    var  shortDesc = String()
    var deviceTypeId = Int()
    var dictEditedData = [String:Any]()
    var otherStateId:Int? = nil
    var arrOpeId  = [[String:Any]]()
    var arrOpeIdNEW  = [AgreeTermsModel]()
    var scanerKey:String = ""
    var strVideoUrl:URL!
    var fltRewarardPoints:Float = 0
    var dictPayorData = [String:Any]()
    var saveDictLicenseRes = [String:JSON]()
    var components = URLComponents()
    let gcmMessageIDKey = "gcm.message_id"
    var intCardIndex:Int  = 0
    let appXVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    var getAppStoreVal = String()
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        fetchData()
        callParallelApi()
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
                if #available(iOS 10.0, *) {
                  // For iOS 10 display notification (sent via APNS)
                  UNUserNotificationCenter.current().delegate = self
                  let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                  UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: { _, _ in }
                  )
                } else {
                  let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                  application.registerUserNotificationSettings(settings)
                }
                application.registerForRemoteNotifications()

        CommonApi.callgetVersionInfoKey(completionHandler: {(storeValue) in
            self.getAppStoreVal = storeValue
            let result =  self.appXVersion!.versionCompare(storeValue)
            switch result {
            case .orderedSame : print("versions are equal")
            case .orderedAscending : let Displayalert = UIAlertController(title: "Alert", message: "There is new version available for download. Please update the app by visiting the AppStore ", preferredStyle: UIAlertController.Style.alert)
                Displayalert.addAction(UIAlertAction(title: "UPDATE", style: .default, handler: { action in
                    switch action.style{
                        case .default:
                        if let url = URL(string: "itms-apps://apple.com/app/id1620365281") {
                            UIApplication.shared.open(url)
                        }
                        case .cancel:
                        print("cancel")

                        case .destructive:
                        print("destructive")

                    @unknown default:
                        print("")
                    }
                }))

                self.window?.rootViewController?.present(Displayalert, animated: true, completion: nil)

            case .orderedDescending : print("version1 is greater than version2")

            }
        }, controler: (self.window?.rootViewController)!)
        ApiManager.sharedInstance.deviceId = UIDevice.current.identifierForVendor!.uuidString
        UserDefaults.standard.set( ApiManager.sharedInstance.deviceId, forKey: "deviceId")
        UserDefaults.standard.synchronize()
        window?.makeKeyAndVisible()
        return true
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//         let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
//         if dynamicLink != nil {
//              print("Dynamic link : \(String(describing: dynamicLink?.url))")
//              return true
//         }
//         return false
//    }



    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

        func application(_ application: UIApplication,
                         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            print("Device token is :\(deviceToken)")
            let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            print("device token is : \(token)")
          Messaging.messaging().apnsToken = deviceToken
        }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                        didReceive response: UNNotificationResponse,
                                        withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        setNotificationRootVC()
        completionHandler()
    }

    
     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
          print("Firebase registration token: \(String(describing: fcmToken))")
          let dataDict: [String: String] = ["token": fcmToken ?? ""]
         getFCMToken  = fcmToken ?? ""
          NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
          )
        }

    func fetchData() {
        print("Fetching Data..")
        managedObjectContext = APP_DELEGATE.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedObjectContext.fetch(request) as? [NSManagedObject]
            if result!.count > 0 {
                for dict in result! {
                    if dict.value(forKey: "isOrderComplete") as? NSNumber == 1 {
                        Common.shared.deleteDatabase()
                        Common.shared.deleteUserDatabase()
                    }
                }
            }
        }catch {
            print("Fetching data Failed")
        }
    }
  
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("It is calling")
        APP_DELEGATE.dictEditedData = [:]
        APP_DELEGATE.isComeFrom = ""
        strIsEditOrder = ""
        fetchData()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Background called")
        APP_DELEGATE.dictEditedData = [:]
        APP_DELEGATE.isComeFrom = ""
        strIsEditOrder = ""
        fetchData()
//        let result =  self.appXVersion!.versionCompare(getAppStoreVal)
//        switch result {
//        case .orderedSame : print("versions are equal")
//        case .orderedAscending : let Displayalert = UIAlertController(title: "Alert", message: "There is new version available for download. Please update the app by visiting the AppStore ", preferredStyle: UIAlertController.Style.alert)
//            Displayalert.addAction(UIAlertAction(title: "UPDATE", style: .default, handler: { action in
//                switch action.style{
//                    case .default:
//                    if let url = URL(string: "itms-apps://apple.com/app/id1620365281") {
//                        UIApplication.shared.open(url)
//                    }
//                    case .cancel:
//                    print("cancel")
//
//                    case .destructive:
//                    print("destructive")
//
//                @unknown default:
//                    print("")
//                }
//            }))
//
//            self.window?.rootViewController?.present(Displayalert, animated: true, completion: nil)
//
//        case .orderedDescending : print("version1 is greater than version2")
//        }

    }
 
    func retrieveFromJsonFile() {
        // Get the url of Persons.json in document directory
        guard let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileUrl = documentsDirectoryUrl.appendingPathComponent("CheckoutData.json")
        // Read data from .json file and transform data into an array
        do {
            let data = try Data(contentsOf: fileUrl, options: [])
            guard let personArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else { return }
            print(personArray)
        } catch {
            print(error)
        }
    }


    func applicationWillTerminate(_ application: UIApplication) {
        Common.shared.deleteDatabase()
        Common.shared.deleteUserDatabase()
    }
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "MobilityOnWheel")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        // MARK: - Core Data Saving support
        func saveContext () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }

    func setLoginRootVC() {
        let loginScene = WelcomeVC.instantiate(fromAppStoryboard: .Login)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.navVC = UINavigationController(rootViewController: loginScene)
        self.navVC?.navigationBar.isHidden = true
        self.window?.rootViewController = self.navVC
        self.window?.makeKeyAndVisible()
    }
    
        func setHomeRootVC() {
        let loginScene = HomeVC.instantiate(fromAppStoryboard: .DashBoard)
            USER_DEFAULTS.value(forKey: AppConstants.selDestId) == nil ? (loginScene.isOpenFrom = "dest") : (loginScene.isOpenFrom = "")
        let leftMenuViewController = LeftMenuViewController.instantiate(fromAppStoryboard: .DashBoard)
        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: loginScene), leftMenuViewController: leftMenuViewController)
        sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: false, scaleBackground: false))
        sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 1.0))
        sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.clear, opacity: 0.6, radius: 6.0))
        self.navVC = UINavigationController(rootViewController: sideMenu)
        self.navVC?.navigationBar.isHidden = true
        self.window?.rootViewController =  self.navVC
        self.window?.makeKeyAndVisible()
    }
    
    func setNotificationRootVC() {
    let loginScene = NotificationVC.instantiate(fromAppStoryboard: .DashBoard)
    let leftMenuViewController = LeftMenuViewController.instantiate(fromAppStoryboard: .DashBoard)
    let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: loginScene), leftMenuViewController: leftMenuViewController)
    sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: false, scaleBackground: false))
    sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 1.0))
    sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.clear, opacity: 0.6, radius: 6.0))
    self.navVC = UINavigationController(rootViewController: sideMenu)
    self.navVC?.navigationBar.isHidden = true
    self.window?.rootViewController =  self.navVC
    self.window?.makeKeyAndVisible()
}

    
    func setActiveorderRootVC(){
        let loginScene = ActiveOrderVC.instantiate(fromAppStoryboard: .DashBoard)
        let leftMenuViewController = LeftMenuViewController.instantiate(fromAppStoryboard: .DashBoard)
        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: loginScene), leftMenuViewController: leftMenuViewController)
        sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: false, scaleBackground: false))
        sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 1.0))
        sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.clear, opacity: 0.6, radius: 6.0))
        self.navVC = UINavigationController(rootViewController: sideMenu)
        self.navVC?.navigationBar.isHidden = true
        self.window?.rootViewController =  self.navVC
        self.window?.makeKeyAndVisible()
    }
    
    func setProfileRootVC(){
        let loginScene = EditProfileVC.instantiate(fromAppStoryboard: .DashBoard)
        let leftMenuViewController = LeftMenuViewController.instantiate(fromAppStoryboard: .DashBoard)
        let sideMenu = SSASideMenu(contentViewController: UINavigationController(rootViewController: loginScene), leftMenuViewController: leftMenuViewController)
        sideMenu.configure(SSASideMenu.MenuViewEffect(fade: true, scale: false, scaleBackground: false))
        sideMenu.configure(SSASideMenu.ContentViewEffect(alpha: 1.0, scale: 1.0))
        sideMenu.configure(SSASideMenu.ContentViewShadow(enabled: true, color: UIColor.clear, opacity: 0.6, radius: 6.0))
        self.navVC = UINavigationController(rootViewController: sideMenu)
        self.navVC?.navigationBar.isHidden = true
        self.window?.rootViewController =  self.navVC
        self.window?.makeKeyAndVisible()
    }
    

    func setDestinationRootVC() {
        //AppDel
        let loginScene = SelectDest.instantiate(fromAppStoryboard: .Login)
        loginScene.strIsComeFrom = "AppDel"
        self.navVC = UINavigationController(rootViewController: loginScene)
        self.navVC?.navigationBar.isHidden = true
        self.window?.rootViewController = self.navVC
        self.window?.makeKeyAndVisible()
    }
    
 //MARK:- PARALLEL API CALL
    func callParallelApi() {
        Utils.showProgressHud()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter() // <<---
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
            CommonApi.callOccupantOperatorInfo(completionHandler: {(success) in
                        dispatchGroup.leave()   // <<----
                })
        dispatchGroup.enter()// <<---
        Utils.showProgressHud()
        self.callStateApi(completionHandler: {(success) in
                    self.arrGetState = self.dictGetState.arrState
                    dispatchGroup.leave()   // <<----
        })
        dispatchGroup.enter()// <<---
        Utils.showProgressHud()
        CommonApi.callRewardPointsApi( completionHandler: {success in
            if success ==  true {
                dispatchGroup.leave()
            }
        })
        
        dispatchGroup.enter()// <<---
        Utils.showProgressHud()
        let getValue =  USER_DEFAULTS.bool(forKey: AppConstants.IS_LOGIN)
        if getValue == true {
            Utils.showProgressHud()
            self.validateLicenseApi(completionHandler: {success in
                Utils.hideProgressHud()
                if success == true {
                    if self.saveDictLicenseRes["IsActiveOrderAval"]?.boolValue == true   {
                        self.setActiveorderRootVC()
                    } else {
                        self.setHomeRootVC()
                    }
                } else {
                        self.setProfileRootVC()
                    }
                dispatchGroup.leave()
            })
        } else {
            self.setLoginRootVC()
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            Utils.hideProgressHud()
        }
    }
    
    func validateLicenseApi(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Auth.validateLicense

        API_SHARED.callCommonParseApi(strUrl: apiUrl, controller: (self.window?.rootViewController)! , passValue: "") { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard
                        jsonResponse.dictionary != nil else {
                        return
                    }
                    if let dicResponseData = jsonResponse.dictionary {
                        arrExpiredicense.removeAll()
                        arrNotUploadLicense.removeAll()
                        self.saveDictLicenseRes = dicResponseData
                        arrExpiredicense  = dicResponseData["NotValidLicenseForOperator"]?.arrayObject as! [Int]
                        arrNotUploadLicense  = dicResponseData["lstLicenseNotAvailableForOperator"]?.arrayObject as! [Int]
                        Utils.hideProgressHud()
                        if  arrNotUploadLicense.count == 0  && dicResponseData["IsLicenseAvailableForPayor"]?.boolValue == true {
                            if dicResponseData["IsValidLicenseForPayor"]?.boolValue == true && arrExpiredicense.count == 0  {
                                completionHandler(true)
                            } else {
                                completionHandler(false)
                            }
                        }else {
                            completionHandler(false)
                        }
                    } else {
                    Utils.hideProgressHud()
                    Utils.showMessage(type: .error, message: AppConstants.ErrorMessage)
                        completionHandler(false)
                }
        }

        }
        
    }

    func createAlertView(strMsg:String) {
        let refreshAlert = UIAlertController(title: "Alert", message: strMsg, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.setProfileRootVC()
        }))

        self.window?.rootViewController?.present(refreshAlert, animated: true, completion: nil)

    }

    
    func callStateApi(completionHandler: @escaping  (Bool) -> ()) {
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.State.getState
        API_SHARED.callAPIForGETorPOST(strUrl: apiUrl , parameters:nil, httpMethodForGetOrPost: .get, setheaders: ["LoggedOn":"3","DeviceId":"\(UserDefaults.standard.value(forKey: "deviceId") as? String ?? UIDevice.current.identifierForVendor!.uuidString)","IosAppVersion":"\(APP_DELEGATE.appXVersion!)"]) { (dicResponseWithSuccess ,_)  in
                if  let jsonResponse = dicResponseWithSuccess {
                    guard jsonResponse.dictionary != nil else {
                        return
                    }
                if let dicResponseData = jsonResponse.dictionary {
                        self.dictGetState = StateListModel().initWithDictionary(dictionary: dicResponseData)
                        if self.dictGetState.statusCode == "OK" {
                                completionHandler(true)
                        } else {
                            completionHandler(false)
                        }
                    }
                } else {
                    completionHandler(false)
                }
        }
    }
}

