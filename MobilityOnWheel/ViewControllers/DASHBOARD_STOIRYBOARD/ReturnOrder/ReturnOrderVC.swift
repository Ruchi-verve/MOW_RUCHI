//
//  ReturnOrderVC.swift
//  MobilityOnWheel
//
//  Created by AppSaint Technology on 25/05/21.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
class ReturnOrderVC: SuperViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imgFromCamera: UIImageView!
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var btnSubmitPhoto: UIButton!
    @IBOutlet weak var  lblheader: UILabel!
    @IBOutlet weak var  lblUsername: UILabel!

    var  orderId = Int()
    var imgData = UIImage()
    var strBase64:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imgFromCamera.image = imgData
}
    
//MARK:- ImagePicker Delegate
    @IBAction func btnSendClick(_ sender: Any) {
        self.callCheckReturnDevice(completionHandler: {success in
            if success == true {
                self.createAlertView(strMsg: "Awesome! File uploaded successfully.")
            }
        })
    }
    
    @IBAction func btnHomeClick(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func createAlertView(strMsg:String) {
        let refreshAlert = UIAlertController(title: "", message: strMsg, preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }

           
    //MARK:- Api Call
    func callCheckReturnDevice(completionHandler: @escaping  (Bool) -> ()) {
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            Utils.showMessage(type: .error, message: AppConstants.NoInetrnet)
            return
        }
        Utils.showProgressHud()
        let apiUrl = AppUrl.URL.Host  + AppUrl.URL.Order.returnOrder
        let imgCompData  = self.imgData.jpegData(compressionQuality:0.3)
        strBase64 = imgCompData!.base64EncodedString()
        let param = ["OrderId":orderId,"RentalImage":strBase64,"MimeType" : "image/jpeg","FileName":"ReturnPic.jpeg"] as [String : Any]
        API_SHARED.callCommonParseApiwithDictParameter(strUrl: apiUrl, passValue: param) { (dicResponseWithSuccess ,_)  in
            
            if  let jsonResponse = dicResponseWithSuccess {
                guard jsonResponse.dictionary != nil else {
                    return
                }
                if let dicResponseData = jsonResponse.dictionary {
                    
                    print("Response in:\(dicResponseData)")
                    if dicResponseData["StatusCode"]?.stringValue == "OK"{
//                        Utils.showMessage(type: .success, message: "File uploaded successfully.") //dicResponseData["Message"]?.stringValue ??
                        Utils.hideProgressHud()
                        completionHandler(true)

                    } else {
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
}
