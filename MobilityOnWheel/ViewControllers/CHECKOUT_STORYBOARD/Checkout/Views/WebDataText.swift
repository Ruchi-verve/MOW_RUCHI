//
//  WebDataText.swift
//  MobilityOnWheel
//
//  Created by Khushbu Lotia on 24/09/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import WebKit

protocol OnbtnPopupCloseClick {
    func onClosePopup()
}

class WebDataText: UIView,WKNavigationDelegate {
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var contentWebView: WKWebView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollChange: UIScrollView!

    var delegate : OnbtnPopupCloseClick?

    override init(frame: CGRect) {
         super.init(frame: frame)
         commonInit()
     }
     
     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         commonInit()
     }

    func commonInit() {
        Bundle.main.loadNibNamed("WebDataText", owner: self, options: nil)
        contentView.frame = self.bounds
        contentWebView.loadHTMLString(APP_DELEGATE.strtxtDisplay, baseURL: nil)
        innerView.layer.borderWidth = 2.0
        innerView.layer.borderColor = UIColor.clear.cgColor
        innerView.layer.cornerRadius  = 10
        innerView.clipsToBounds = true
        contentWebView.navigationDelegate = self
        contentWebView.scrollView.alwaysBounceVertical = false
        contentWebView.scrollView.alwaysBounceHorizontal = false
        contentWebView.scrollView.isScrollEnabled = false
        contentView.fixInView(self)
    }
    @IBAction func btnCloseClick(sender: UIButton!) {
        if delegate != nil {
            delegate?.onClosePopup()
        }
    }

}


