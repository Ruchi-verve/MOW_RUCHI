//
//  TopPicksView.swift
//  VIPApp
//
//  Created by Arvind Kanjariya on 18/02/20.
//  Copyright © 2020 Arvind Kanjariya. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import WebKit

protocol OnPopupCloseClick {
    func onClose()
    func onAgree()
    func onBack()
}


class TrainingVideo: UIView ,UITextViewDelegate,WKNavigationDelegate{
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var viewVideoPlayer: UIView!
    @IBOutlet weak var conVideoHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollChange: UIScrollView!
    @IBOutlet weak var conViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var conlblHeaderHeight: NSLayoutConstraint!


    var delegate : OnCloseClick?
    var currentPage: Int = 0
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var MainIndex : Int = 0
    var pageIndex : Int = 0

   override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("TrainingVideo", owner: self, options: nil)
        contentView.frame = self.bounds
        innerView.layer.borderWidth = 2.0
        innerView.layer.borderColor = UIColor.clear.cgColor
        innerView.layer.cornerRadius  = 10
        innerView.clipsToBounds = true
        contentView.fixInView(self)
        self.btnBack.isHidden = true
        self.txtContent.text  =  ""
        if APP_DELEGATE.isComeFrom == "reservation" || APP_DELEGATE.isComeFrom == "AddOperator" || APP_DELEGATE.isComeFrom == "occupant" || APP_DELEGATE.isComeFrom == "operator" || APP_DELEGATE.isComeFrom == "PickupLocInfo" {
            self.txtContent.text = APP_DELEGATE.strtxtDisplay.htmlToString
            conViewHeight.constant = 0
            conVideoHeight.constant = 0
            self.scrollChange.isUserInteractionEnabled = true
            if APP_DELEGATE.isComeFrom == "AddOperator"  || APP_DELEGATE.isComeFrom == "occupant" || APP_DELEGATE.isComeFrom == "operator"  || APP_DELEGATE.isComeFrom == "PickupLocInfo" {
                self.lblTitle.text = ""
                conlblHeaderHeight.constant = 0
                self.lblTitle.updateConstraintsIfNeeded()
                self.lblTitle.layoutIfNeeded()

            } else {
                conlblHeaderHeight.constant = 21
                self.lblTitle.updateConstraintsIfNeeded()
                self.lblTitle.layoutIfNeeded()
                self.lblTitle.text = "Rider Reward Policy"
            }
            self.viewBtn.updateConstraintsIfNeeded()
            self.viewBtn.layoutIfNeeded()
            self.viewVideoPlayer.updateConstraintsIfNeeded()
            self.viewVideoPlayer.layoutIfNeeded()
            
        } else {
            self.showData()
      }

    }
    //MARK:- UIAction
    @IBAction func btnBackClick(_ sender: Any) {
        pageIndex = pageIndex - 1
        pageControl.currentPage = pageIndex
        scrollChange.contentOffset = CGPoint.zero

        showData()
    }
    
    @IBAction func btnAcceptClick(_ sender: Any) {
        self.btnBack.isHidden = false
        scrollChange.contentOffset = CGPoint.zero
        AgreeTapped()
        if MainIndex == APP_DELEGATE.arrOpeId.count {
            if pageIndex == 2 {
                if delegate != nil {
                    delegate?.onClose()
                }
            }
        }
        
    }
    
    @IBAction func btnCloseClick(sender: UIButton!) {
        if delegate != nil {
            APP_DELEGATE.isAgree = false
            MainIndex = 0
             pageIndex = 0
            delegate?.onClose()
        }
    }
    
    @IBAction func changePage(_ sender: UIPageControl) {
        moveScrollViewToCurrentPage()
    }
    
    private func moveScrollViewToCurrentPage() {

     //You can use your UICollectionView variable too instead of my scrollview variable
                self.scrollChange
                    .scrollRectToVisible(CGRect(
                                            x: Int(self.scrollChange.frame.size.width) * self.pageControl.currentPage,
                        y: 0,
                         width:Int(self.scrollChange.frame.size.width),
                        height: Int(self.scrollChange.frame.size.height)),
                                         animated: true)

        }
    
    
    func showData() {
        conlblHeaderHeight.constant = 21
        self.lblTitle.updateConstraintsIfNeeded()
        self.lblTitle.layoutIfNeeded()

        if pageIndex == 0 {
            self.btnBack.isHidden = true
            self.lblTitle.text = "Device Training Video"
            let dict = APP_DELEGATE.arrOpeId[MainIndex]
            self.txtContent.text = dict["videoText"] as? String ?? ""
            if dict["videoUrl"] as? String  != ""  &&  dict["videoUrl"] as? String != nil {
                self.player = AVPlayer(url: URL(string:dict["videoUrl"] as! String)!)
                self.avpController = AVPlayerViewController()
                self.avpController.player = self.player
                self.avpController.view.frame = self.viewVideoPlayer.bounds
                self.avpController.allowsPictureInPicturePlayback = false
                self.avpController.showsPlaybackControls = true
                self.viewVideoPlayer.addSubview(self.avpController.view)
                pageControl.currentPage = pageIndex
            }
            conVideoHeight.constant = 200
            self.scrollChange.isUserInteractionEnabled = true
            conViewHeight.constant = 120
            self.viewVideoPlayer.updateConstraintsIfNeeded()
            self.viewVideoPlayer.layoutIfNeeded()
            self.viewBtn.updateConstraintsIfNeeded()
            self.viewBtn.layoutIfNeeded()

        }
        else if pageIndex == 1 {
            self.btnBack.isHidden = false
            let dict = APP_DELEGATE.arrOpeId[MainIndex]
            self.txtContent.text = dict["agreeText"] as? String ?? ""
            self.lblTitle.text = "Rental Agreement"
            self.conVideoHeight.constant = 0
            self.viewVideoPlayer.updateConstraintsIfNeeded()
            self.viewVideoPlayer.layoutIfNeeded()
            pageControl.currentPage = pageIndex

        }
        else  {
            self.btnBack.isHidden = false
            let dict = APP_DELEGATE.arrOpeId[MainIndex]
            scrollChange.reloadInputViews()
            self.conVideoHeight.constant = 0
            self.lblTitle.text = "Terms & Conditions"
            self.txtContent.text = dict["terms&ConText"] as? String ?? ""
            pageControl.currentPage = pageIndex
            self.viewVideoPlayer.updateConstraintsIfNeeded()
            self.viewVideoPlayer.layoutIfNeeded()
        }
        
        

    }
    
    func AgreeTapped() {
        if pageIndex < 2 {
//            pageIndex = currentPage
            pageIndex = pageIndex + 1
            showData()
        }
        else {
            if MainIndex < (APP_DELEGATE.arrOpeId.count - 1) {
                MainIndex =  MainIndex + 1
                pageIndex = 0
                showData()
            } else {
                if delegate != nil {
                    APP_DELEGATE.isAgree = true
                    delegate?.onClose()
                }
            }
        }
    }

}

