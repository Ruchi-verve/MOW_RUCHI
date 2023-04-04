//
//  SuperViewController.swift
//  VIPApp
//
//  Created by Arvind Kanjariya on 06/11/19.
//  Copyright © 2019 Arvind Kanjariya. All rights reserved.
//

import UIKit

class SuperViewController: UIViewController {
    
    func onLoginFailure() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Common.shared.setStatusBarColor(view: view, color: AppConstants.kColor_Primary)
        self.navigationController?.view.removeGestureRecognizer((self.navigationController?.interactivePopGestureRecognizer!)!)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func btnBackClick(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
