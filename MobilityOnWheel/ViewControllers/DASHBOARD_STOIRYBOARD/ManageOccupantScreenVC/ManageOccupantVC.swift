//
//  ManageOccupantVC.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 20/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class ManageOccupantVC: SuperViewController,UITableViewDelegate,UITableViewDataSource,OnCloseClick {
    
    @IBOutlet weak var btnAddNewOperator: UIButton!
    @IBOutlet weak var tblOccupantList: UITableView!
    @IBOutlet weak var btnExistingOperator: UIButton!

    
    var arrList = [OccupantListModel]()
    var customerId :Int = 0
    var strIsCome:String = ""
    var dictPayor = OperatorListSubRes()
    var OccuId:Int = 0
    var traingView: TrainingVideo!
    var cardView: CardAgrement!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func SetUI(){
        tblOccupantList.register(UINib(nibName: "OperatorListCell", bundle: nil), forCellReuseIdentifier: "OperatorListCell")
        callOcupantListApi()
    }
    //MARK:- Delegate Function
    func onClose() {
    
        if self.cardView != nil {
            self.cardView.removeFromSuperview()
        }
        
        if self.traingView != nil {
            self.traingView.removeFromSuperview()
        }

    }

    func callOcupantListApi(){
        Utils.showProgressHud()
        CommonApi.callOccupantList(CustId: customerId, completionHandler: { [self](success) in
                    if success == true {
                        self.view.endEditing(true)
                            self.arrList = Arr_OccupantList
                        DispatchQueue.main.async {
                            self.tblOccupantList.reloadData()
                        }
                     } else {
                        self.view.endEditing(true)
                        Utils.showMessage(type: .error, message:"No Occupants found")
                    }
        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SetUI()
    }
    
    //MARK:- UIAction
    @IBAction func btnNewOccupantClick(_ sender: Any) {
        let retrive = AddOccupantVC.instantiate(fromAppStoryboard: .DashBoard)
        retrive.operatorId = customerId
        retrive.dictPayer = dictPayor
        self.navigationController?.pushViewController(retrive, animated: true)

    }
       
    @IBAction func btnExistingOcupantClick(_ sender: Any) {
        let retrive:AddExistingOccupantVC = AddExistingOccupantVC.instantiate(fromAppStoryboard: .DashBoard)
        retrive.OperatorId = customerId
        retrive.arrOccuList = arrList
        self.navigationController?.pushViewController(retrive, animated: true)

    }

    @IBAction func btnInfoClick(_ sender: Any) {
        APP_DELEGATE.isComeFrom = "occupant"
        APP_DELEGATE.strtxtDisplay = dictOccupantOperatorInfo.defineOccupant
        traingView = TrainingVideo(frame: SCREEN_RECT)
        traingView.delegate = self
        self.view.addSubview(traingView)
        self.view.bringSubviewToFront(traingView)

    }
    @IBAction func btnHomeClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    //MARK:- UITableview Method

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperatorListCell", for: indexPath) as! OperatorListCell
        let dict = arrList[indexPath.row]
        cell.strIsCome = "Occupant"
        cell.setSelected(true, animated: false)
        cell.lblOperatorName.text! = String(format: "%@ %@", dict.firstName,dict.lastName)
        cell.lblOperatorEmail.text! = "Operator Name:\(dict.operatorName)"
        if dict.isDefault == true {
            cell.contentView.backgroundColor = UIColor(red: 191/255, green: 252/255, blue: 91/255, alpha: 1)
            cell.btnOccupant.isHidden = true
            cell.btnEdit.isHidden = true
            cell.imgEdit.isHidden = true
            cell.imgOccupant.isHidden = true
        }else {
            cell.contentView.backgroundColor = UIColor.clear
            cell.btnOccupant.isHidden = false
            cell.imgOccupant.isHidden = false
            cell.btnEdit.isHidden = false
            cell.imgEdit.isHidden = false

        }
        cell.btnEdit.tag = indexPath.row
        cell.btnOccupant.tag = indexPath.row
        cell.lblOpertatorContact.text = ""
        cell.btnEdit.addTarget(self, action: #selector(btnEditTapp(_:)), for: .touchUpInside)
        cell.btnOccupant.addTarget(self, action: #selector(btnOccuTapp(_:)), for: .touchUpInside)
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    //MARK:- Cell Function
    
    @objc func btnEditTapp(_ sender:UIButton) {
        let retrive = AddOccupantVC.instantiate(fromAppStoryboard: .DashBoard)
        retrive.isCome = "Edit"
        retrive.index = sender.tag
        retrive.dictGetData = arrList[sender.tag]
        retrive.operatorId = customerId
        retrive.dictPayer = dictPayor
        self.navigationController?.pushViewController(retrive, animated: true)

    }
    
    @objc func btnOccuTapp(_ sender:UIButton) {
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to remove occupant?", preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.removeOccupantfromList(id: self.arrList[sender.tag].iD)
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          }))

        present(refreshAlert, animated: true, completion: nil)
    }


    
    //MARK:- ApiCall
    func removeOccupantfromList(id:Int){
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Operator.removeOccupant
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        
        API_SHARED.callCommonParseApiwithstrRes(strUrl: apiUrl, passValue: "\(id)")  { (dicResponseWithSuccess ,_)  in
                        
                        if dicResponseWithSuccess != "" {
                            Utils.hideProgressHud()
                                self.callOcupantListApi()
                        } else {
                            Utils.hideProgressHud()
//                            Utils.showMessage(type: .error, message: dicResponseData["Message"]?.stringValue ?? AppConstants.ErrorMessage)
                        }
                    }
            }

    
    
}
