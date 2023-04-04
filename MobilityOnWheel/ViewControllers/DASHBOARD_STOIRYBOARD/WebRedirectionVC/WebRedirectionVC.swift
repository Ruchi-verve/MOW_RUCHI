//
//  WebRedirectionVC.swift
//  MobilityOnWheel
//
//  Created by Verve on 24/12/21.
//  Copyright © 2021 Verve_Sys. All rights reserved.
//

import UIKit
import WebKit

class WebRedirectionVC: SuperViewController,WKNavigationDelegate {

    @IBOutlet var  wkWebShopView:WKWebView!
    @IBOutlet var  actIndi:UIActivityIndicatorView!

    var strIsComefrom:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        actIndi.isHidden =  false
        actIndi.startAnimating()
        self.wkWebShopView.navigationDelegate = self
        actIndi.hidesWhenStopped = true
        
        print("URL CHECK HERE \(strIsComefrom)")
        print("URL CHECK HERE \(scrFlag)")
      
        if scrFlag == 0 {
            if strIsComefrom == "Deactivate My Account" {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://www.mobilityonwheels.com/deactivate-my-account/")! as URL) as URLRequest)
            } else if strIsComefrom == "faq" {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/faq/")! as URL) as URLRequest)
            } else if strIsComefrom == "feedback" {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/feedback/")! as URL) as URLRequest)
            }else if strIsComefrom == "privacy" {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/privacy-and-security-statement/")! as URL) as URLRequest)
            }else if strIsComefrom == "sell" {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/do-not-sell-my-personal-information/")! as URL) as URLRequest)
            }else if strIsComefrom == "terms" {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/terms-of-use/")! as URL) as URLRequest)
            }else if strIsComefrom == "about" {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://www.mobilityonwheels.com/about-us/")! as URL) as URLRequest)
            }else if strIsComefrom == "contact" {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://www.mobilityonwheels.com/contact-us/")! as URL) as URLRequest)
            } else if strIsComefrom == "help" {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://www.mobilityonwheels.com/help-logging-into-mymobility-app/")! as URL) as URLRequest)
            } else {
                wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://www.mobilityonwheels.com/shop/")! as URL) as URLRequest)
            }
        } else {
            wkWebShopView.load(NSURLRequest(url: NSURL(string: "\(strIsComefrom)")! as URL) as URLRequest)
        }
        
        
        
        
        
//        if strIsComefrom == "faq" {
//            wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/faq/")! as URL) as URLRequest)
//        } else if strIsComefrom == "feedback" {
//            wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/feedback/")! as URL) as URLRequest)
//        }else if strIsComefrom == "privacy" {
//            wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/privacy-and-security-statement/")! as URL) as URLRequest)
//        }else if strIsComefrom == "sell" {
//            wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/do-not-sell-my-personal-information/")! as URL) as URLRequest)
//        }else if strIsComefrom == "terms" {
//            wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://mobilityonwheels.com/terms-of-use/")! as URL) as URLRequest)
//        }else if strIsComefrom == "about" {
//            wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://www.mobilityonwheels.com/about-us/")! as URL) as URLRequest)
//        }else if strIsComefrom == "contact" {
//            wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://www.mobilityonwheels.com/contact-us/")! as URL) as URLRequest)
//        } else if strIsComefrom == "help" {
//            wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://www.mobilityonwheels.com/help-logging-into-mymobility-app/")! as URL) as URLRequest)
//        }
//        else {
//            wkWebShopView.load(NSURLRequest(url: NSURL(string: "https://www.mobilityonwheels.com/shop/")! as URL) as URLRequest)
//        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        actIndi.isHidden =  true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        actIndi.isHidden =  true
    }
    
}
