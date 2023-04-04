//
//  SelectDest.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 02/08/21.
//

import UIKit
import SwiftyJSON
import CoreData
class SelectDest: SuperViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblSelectDest: UITableView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnBack: UIButton!

    var arrMainSelectData = [String:[DestResSubModel]]()
    var strSelectedDestination:String? = nil
    var SelectedDestinationId:Int? = nil
    var DeliveryFee:Float? = nil
    var dataKeys : Array = [String]()
    var arrGetValues  = DestResSubModel()
    var strIsComeFrom:String = ""
    var arrFilterArrayWithCat = [[String:Any]]()
    var arrSelectDestData = [[DestResSubModel]]()

    var dataSource:GenericDataSourceWithSection<DestResSubModel>!
    
    override func viewDidLoad() {
        if strIsComeFrom == "AppDel" {
            Common.shared.setStatusBarColor(view: view,color: AppConstants.kColor_Primary)
            btnBack.isHidden = true
        } else {
            Common.shared.setStatusBarColor(view: view,color: AppConstants.kColor_Primary)
            btnBack.isHidden = false
        }
       // let getName = USER_DEFAULTS.value(forKey: AppConstants.FIRST_NAME) as? String ??  "Steve"
        //lblUsername.text = AppConstants.setHi + getName.capitalized
        tblSelectDest.register(UINib(nibName: "SelectDestCell", bundle: nil), forCellReuseIdentifier: "SelectDestCell")
        self.navigationController?.view.removeGestureRecognizer((self.navigationController?.interactivePopGestureRecognizer!)!)
        tblSelectDest.rowHeight = UITableView.automaticDimension
        tblSelectDest.estimatedRowHeight = 50

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        strIsComeFrom = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        CommonApi.callGetDestinationApi(completionHandler:{(success) in
            if success == true {
                self.arrMainSelectData = arrLocation
                self.dataKeys = (self.arrMainSelectData as NSDictionary).allKeys as! [String]
                self.dataKeys = self.dataKeys.sorted()
                self.tblSelectDest.reloadData()
            }
        })

    }
    //MARK: - UITableview Method
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = dataKeys[section]
        return arrMainSelectData[sec]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectDestCell", for: indexPath) as? SelectDestCell
        let sec = dataKeys[indexPath.section]
        cell!.lblDestName.text = arrMainSelectData[sec]?[indexPath.row].locationName
        if arrMainSelectData[sec]?[indexPath.row].isSel == 1 {
            cell?.btnRadio.isSelected  = true
        } else {
            let getSelId = USER_DEFAULTS.value(forKey: AppConstants.selDestId) as? Int
        if getSelId != nil {
                if arrMainSelectData[sec]?[indexPath.row].id == getSelId {
                    cell?.btnRadio.isSelected = true
                } else {
                    cell?.btnRadio.isSelected = false
                }
            } else {
                cell?.btnRadio.isSelected  = false
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for (i,rowArr) in arrMainSelectData {
            for subDic in rowArr  {
                if subDic.isSel == 1 {
                    subDic.isSel = 0
                }
                arrMainSelectData[i] = rowArr
            }
        }
        let sec = dataKeys[indexPath.section]
        arrMainSelectData[sec]?[indexPath.row].isSel   = 1
        strSelectedDestination = arrMainSelectData[sec]?[indexPath.row].locationName
        SelectedDestinationId = arrMainSelectData[sec]?[indexPath.row].id
        USER_DEFAULTS.set(strSelectedDestination! , forKey:AppConstants.SelDest)
        USER_DEFAULTS.set(SelectedDestinationId! , forKey:AppConstants.selDestId)
        USER_DEFAULTS.synchronize()
        APP_DELEGATE.setHomeRootVC()
        self.tblSelectDest.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = UIColor.white
        let label = UILabel()
        label.frame = CGRect.init(x: 8, y: 8, width: headerView.frame.width-20, height: headerView.frame.height-20)
        label.text = dataKeys[section]
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = setFont.bold.of(size: 18)

        } else {
            label.font = setFont.bold.of(size: 15)
        }
        label.textColor = AppConstants.kColor_Primary
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 50
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    
    func updateTableViewData() {
        dataSource = .init(models: self.arrSelectDestData, reuseIdentifier: "SelectDestCell", reuseIdentifierSection: "headerFooter", cellConfigurator:{  (model, cell) in
            let cel:SelectDestCell = cell as! SelectDestCell
            cel.lblDestName.text = model.locationName
            if model.isSel == 1 {
                cel.btnRadio.isSelected  = true
            } else {
                let getSelId = USER_DEFAULTS.value(forKey: AppConstants.selDestId) as? Int
            if getSelId != nil {
                    if model.id == getSelId {
                        cel.btnRadio.isSelected = true
                    } else {
                        cel.btnRadio.isSelected = false
                    }
                } else {
                    cel.btnRadio.isSelected  = false
                }
            }

        }, cellConfiguratorSection: {  (headermodel, section) in }, itemClick: { (model, indexpath, cell) in
                })
        
        
        
    }
    
    
    
    
    
    //MARK:- IBActionClick
    @IBAction func btnBackClick(_ sender:UIButton) {
//        self.navigationController?.popToRootViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}


