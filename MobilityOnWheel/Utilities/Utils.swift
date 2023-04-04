//
//  Utils.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 29/07/21.
//

import Foundation
import SVProgressHUD
import SwiftMessages

class Utils {
    class func showMessage(type: Theme, title:String? = nil, message:String) {
        DispatchQueue.main.async {
            var config = SwiftMessages.Config()
            // Slide up from the bottom.
            config.presentationStyle = .bottom
            // Display in a window at the specified window level: UIWindow.Level.statusBar
            // displays over the status bar while UIWindow.Level.normal displays under.
            config.presentationContext = .window(windowLevel: .normal)
            let view = MessageView.viewFromNib(layout: .cardView)
                       // Theme message elements with the warning style.
                       view.configureTheme(type)
                       // Add a drop shadow.
                       view.configureDropShadow()
            view.bodyLabel?.font = setFont.regular.of(size: UIDevice.current.userInterfaceIdiom == .pad ? 30: 15)
                       view.button?.isHidden = true
                       // Show the message.
                       if title == nil {
                           view.titleLabel?.isHidden = true
                           view.configureContent(body: message)
                       } else {
                           view.configureContent(title: title!, body: message)
                       }
            SwiftMessages.show(config: config, view: view)
        }
    }
    
    class func showProgressHud() {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(AppConstants.kColor_Primary)
        SVProgressHUD.setBackgroundColor(UIColor.clear)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setRingThickness(4)
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    
    class func hideProgressHud() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }     
    }


}
