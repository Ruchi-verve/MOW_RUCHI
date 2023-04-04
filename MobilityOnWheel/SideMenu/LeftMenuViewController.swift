import Foundation
import UIKit



class LeftMenuViewController: UIViewController,SideMenuSubItemClick,onBtnPopupCloseClick {
    func closePopupCLick() {
        self.RewardView.removeFromSuperview()
    }
    
    func onSubOptionSelected(item: String) {
        
        print("DELEGATE CALLED:- \(item)")
        
        switch item {
        case "Select a destination and place order" :
            let loginScene = HomeVC.instantiate(fromAppStoryboard: .DashBoard)
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController:loginScene)
            loginScene.isOpenFrom = "dest"
            sideMenuViewController?.hideMenuViewController()
            break
        case "Active Orders":
            let loginScene = ActiveOrderVC.instantiate(fromAppStoryboard: .DashBoard)
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController:loginScene)
            sideMenuViewController?.hideMenuViewController()
            break
        case "Order History":
            let loginScene = HistoryVC.instantiate(fromAppStoryboard: .DashBoard)
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController:loginScene)
            sideMenuViewController?.hideMenuViewController()
            break
        case "My Profile":
            let loginScene = EditProfileVC.instantiate(fromAppStoryboard: .DashBoard)
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController:loginScene)
            sideMenuViewController?.hideMenuViewController()
            break
        case "Notifications":
            let loginScene = NotificationVC.instantiate(fromAppStoryboard: .DashBoard)
            sideMenuViewController?.contentViewController = UINavigationController(rootViewController:loginScene)
            sideMenuViewController?.hideMenuViewController()
            break
        case "Rider Rewards": sideMenuViewController?.hideMenuViewController()
            RewardView  = RewardPoints(frame: SCREEN_RECT)
            RewardView.delegate = self
            self.sideMenuViewController?.view.addSubview(RewardView)
            self.sideMenuViewController?.view.bringSubviewToFront(RewardView)
            break
        case "Deactivate My Account":
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = "Deactivate My Account"
            self.navigationController?.pushViewController(help, animated: true)
            break
        case "Shop Online": sideMenuViewController?.hideMenuViewController()
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = ""
            self.navigationController?.pushViewController(help, animated: true)
            break
        case "FAQs": sideMenuViewController?.hideMenuViewController()
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = "faq"
            self.navigationController?.pushViewController(help, animated: true)
            break
        case "Give feedback": sideMenuViewController?.hideMenuViewController()
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = "feedback"
            self.navigationController?.pushViewController(help, animated: true)
            break
        case "Privacy and Security statement": sideMenuViewController?.hideMenuViewController()
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = "privacy"
            self.navigationController?.pushViewController(help, animated: true)
            break
        case "Do Not Sell My Personal Information": sideMenuViewController?.hideMenuViewController()
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = "sell"
            self.navigationController?.pushViewController(help, animated: true)
            break
        case "Terms of Use": sideMenuViewController?.hideMenuViewController()
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = "terms"
            self.navigationController?.pushViewController(help, animated: true)
            break
        case "About": sideMenuViewController?.hideMenuViewController()
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = "about"
            self.navigationController?.pushViewController(help, animated: true)
            break
        case "Contact Customer Sevice": sideMenuViewController?.hideMenuViewController()
            let help = WebRedirectionVC.instantiate(fromAppStoryboard: .DashBoard)
            help.strIsComefrom = "contact"
            self.navigationController?.pushViewController(help, animated: true)
            break
        default:
            break
        }
    }
//    var itemArrayDelivery: [String] = ["Order", "Orders History", "My Profile", "Help"]
    var itemArrayDelivery = [[String:AnyObject]]()

    var itemImageArray: [String] = ["icon_order", "icon_history", "icon_profile", "icon_help"]
    
    var index: Int = -1
    var isExpand:Bool = false
   // var itemListener: SideMenuItemClick!

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserFirstWord: UILabel!
    @IBOutlet weak var imgUserFirstWord: UIImageView!
    @IBOutlet weak var lblversionNo: UILabel!
    var RewardView:RewardPoints!
    var subArr:[[String:AnyObject]] = [["name":"Select a destination and place order"], ["name":"Active Orders"], ["name":"Order History"]] as [[String:AnyObject]]
    var subArr1:[[String:AnyObject]] = [["name":"My Profile"], ["name":"Notifications"], ["name":"Rider Rewards"], ["name":"Deactivate My Account"]] as [[String:AnyObject]]
    var subArr2:[[String:AnyObject]] = [["name":"Shop Online"]] as [[String:AnyObject]]
    var subArr3:[[String:AnyObject]] = [["name":"FAQs"], ["name":"Give feedback"], ["name":"Privacy and Security statement"],["name":"Do Not Sell My Personal Information"],["name":"Terms of Use"],["name":"About"],["name":"Contact Customer Sevice"]] as [[String:AnyObject]]
//["name":"Place an Order"]
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemArrayDelivery = [["name":"Orders","subarr":subArr],["name":"My Account","subarr":subArr1],["name":"Retail","subarr":subArr2],["name":"Information","subarr":subArr3]] as [[String:AnyObject]]
        let getfirstName  =  USER_DEFAULTS.value(forKey: AppConstants.FIRST_NAME) as? String ?? "Steve"
        let getlastName  =  USER_DEFAULTS.value(forKey: AppConstants.LAST_NAME) as? String ?? "Steve"
        lblUserName.text = (getfirstName.capitalized)+" "+(getlastName.capitalized)
        imageWith(name: getfirstName)
        tblList.register(UINib(nibName: "LeftMenuCell", bundle: nil), forCellReuseIdentifier: LeftMenuCellID)
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.lblversionNo.text = "Version Number:\(appVersion ?? "0.0")"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblList.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnCloseClicked(_ sender: Any){
        sideMenuViewController?.hideMenuViewController()
    }
    
    @IBAction func btnSignout(_ sender: Any){
        
        
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to logout?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.remove_ClearData()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          }))

        present(refreshAlert, animated: true, completion: nil)

    }
    
    func imageWith(name: String?) {
        let lblNameInitialize = UILabel()
        lblNameInitialize.frame.size = imgUserFirstWord.frame.size
        lblNameInitialize.textColor = AppConstants.kColor_Primary
        lblNameInitialize.text = String(name!.first!)
        if UIDevice.current.userInterfaceIdiom == .pad {
            lblNameInitialize.font = setFont.bold.of(size: 60)
        } else {
            lblNameInitialize.font = setFont.bold.of(size: 40)
        }
        lblNameInitialize.textAlignment = NSTextAlignment.center
//        lblNameInitialize.backgroundColor = UIColor.bl
//    lblNameInitialize.layer.cornerRadius = 50.0

        UIGraphicsBeginImageContext(lblNameInitialize.frame.size)
        lblNameInitialize.layer.render(in: UIGraphicsGetCurrentContext()!)
        imgUserFirstWord.image = UIGraphicsGetImageFromCurrentImageContext()
        imgUserFirstWord.layer.borderWidth = 1
        imgUserFirstWord.layer.cornerRadius = imgUserFirstWord.frame.size.width / 2
        imgUserFirstWord.layer.borderColor  = UIColor.clear.cgColor
        imgUserFirstWord.backgroundColor = UIColor(red: 205/255, green: 220/255, blue: 232/255, alpha: 1)
        UIGraphicsEndImageContext()
}
    
    func remove_ClearData() {
        intHandControllerId = 0
        intChairPadReqId = 0
        intPrefferedWheelchairSizeId = 0
        intJoystickPosId = 0
        let appDomain = Bundle.main.bundleIdentifier
        let getDestId  = USER_DEFAULTS.value(forKey: AppConstants.selDestId) as? Int
        let getDestName  = USER_DEFAULTS.value(forKey: AppConstants.SelDest) as? String
        USER_DEFAULTS.removePersistentDomain(forName: appDomain ?? "com.mow.cash")
        USER_DEFAULTS.synchronize()
        APP_DELEGATE.dictEditedData = [:]
        strIsEditOrder = ""
        APP_DELEGATE.arrActiveOrder.removeAll()
        APP_DELEGATE.isComeFrom = ""
        APP_DELEGATE.strVideoUrl = nil
        APP_DELEGATE.isAgree = false
        APP_DELEGATE.getPaymentProfileId = 0
        APP_DELEGATE.deviceTypeId = 0
        APP_DELEGATE.otherStateId = 0
        APP_DELEGATE.rewardPoint = 0
        APP_DELEGATE.arrOperatorList.removeAll()
        APP_DELEGATE.arrSaveOperatorList.removeAll()
        APP_DELEGATE.saveDictLicenseRes = [:]
        arrExpiredicense.removeAll()
        arrNotUploadLicense.removeAll()
        Arr_OccupantList.removeAll()
        Common.shared.deleteDatabase()
        Common.shared.deleteUserDatabase()
        strTotal = ""
        strSubTotal = ""
        strDeliveryFee = ""
        TaxRate = 0
        getTotal = 0
        flotPricewithTax = 0.00
        USER_DEFAULTS.set(getDestId, forKey: AppConstants.selDestId)
        USER_DEFAULTS.set(getDestName, forKey: AppConstants.SelDest)
        USER_DEFAULTS.synchronize()
        APP_DELEGATE.setLoginRootVC()
    }

}


// MARK : TableViewDataSource & Delegate Methods

extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArrayDelivery.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subarr = self.itemArrayDelivery[indexPath.row]["subarr"]as? [[String:AnyObject]]
        return CGFloat((subarr!.count * (UIDevice.current.userInterfaceIdiom == .pad ? 40:30))) + (UIDevice.current.userInterfaceIdiom == .pad ? 40 : 30)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeftMenuCell = tableView.dequeueReusableCell(withIdentifier: LeftMenuCellID, for: indexPath) as! LeftMenuCell
        //cell.imgIcon.image = UIImage(named: itemImageArray[indexPath.row])
        cell.lblItem.text = "\(indexPath.row + 1). \(itemArrayDelivery[indexPath.row]["name"] as? String ?? "") "
        cell.itemArraysubDelivery = itemArrayDelivery[indexPath.row]["subarr"] as! [[String:AnyObject]]
        cell.itemSubListener  = self
        cell.tblSubMenu.reloadData()
        return cell
    }

}
