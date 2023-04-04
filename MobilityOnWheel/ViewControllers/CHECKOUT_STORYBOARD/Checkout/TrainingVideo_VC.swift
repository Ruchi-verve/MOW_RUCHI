//
//  TrainingVideo_VC.swift
//  MobilityOnWheel
//
//  Created by Verve on 10/01/22.
//  Copyright © 2022 Verve_Sys. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Alamofire
import WebKit
import MediaPlayer


protocol onClickbtnClose {
    func onClickbtnClose()
}
class TrainingVideo_VC: UIViewController,UITextViewDelegate,WKNavigationDelegate {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewVideoPlayer: UIView!
    @IBOutlet weak var viewstckVideo: UIView!
    @IBOutlet weak var viewstckbtn: UIView!
    @IBOutlet weak var scrollChange: UIScrollView!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var conlblHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var webContent: WKWebView!
    @IBOutlet weak var conwebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNoVideo: UILabel!
    
    @IBOutlet private var bufferIndicator: UIActivityIndicatorView!
    @IBOutlet private var controlsView: UIView!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var pauseButton: UIButton!
    @IBOutlet private var currentPositionLabel: UILabel!
    @IBOutlet private var seekSlider: UISlider!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var bufferedRangeProgressView: UIProgressView!

    var currentPage: Int = 0
    var MainIndex : Int = 0
    var pageIndex : Int = 0
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    //var delegate :onClickbtnClose?
    var observer: NSKeyValueObservation?
    var playerLayer:AVPlayerLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        commonMethod()
    }
    
    func commonMethod() {
        self.webContent.navigationDelegate = self
        self.pageControl.isHidden = true
        self.btnBack.isHidden = true
        self.lblTitle.text = "Rider Reward Policy"
            self.showData()
    }
    
    func loadHTMLContent(_ htmlContent: String) {
        let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width - 20, initial-scale=1.0, shrink-to-fit=no\"><STYLE>img{display: inline;height: auto;max-width: 100%;};</STYLE></HEAD><BODY>"
        let htmlEnd = "</BODY></HTML>"
       
        let htmlString = "\(htmlStart)\(htmlContent)\(htmlEnd)"
        webContent.loadHTMLString(htmlString, baseURL: nil)
    }
    
    //MARK: - Webview Delegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            self.conwebViewHeight.constant = height as! CGFloat
        })
    }
    
    //MARK: - UIAction
    @IBAction func btnBackClick(_ sender: Any) {
        pageIndex = pageIndex - 1
        pageControl.currentPage = pageIndex
        scrollChange.contentOffset = CGPoint.zero
        self.conwebViewHeight.constant = 0
        DispatchQueue.main.async {
            self.webContent.layoutIfNeeded()
            self.webContent.updateConstraintsIfNeeded()
        }
        showData()
    }


    @IBAction func btnAcceptClick(_ sender: Any) {
        self.btnBack.isHidden = false
        scrollChange.contentOffset = CGPoint.zero
        AgreeTapped()
        if MainIndex == APP_DELEGATE.arrOpeIdNEW.count {
            if pageIndex == 2 {
                APP_DELEGATE.isAgree = true
                dismiss(animated: true, completion: nil)
            }
        }
    }

    
    @IBAction func btnCloseClick(sender: UIButton!) {
            MainIndex = 0
             pageIndex = 0
        APP_DELEGATE.isAgree = APP_DELEGATE.isAgree == false ? false:true
        APP_DELEGATE.arrOpeIdNEW.removeAll()
        APP_DELEGATE.arrOpeId.removeAll()
        dismiss(animated: true, completion:nil)
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
        
        let path = Bundle.main.path(forResource: "style", ofType: "css")
       let cssString = try! String(contentsOfFile: path!).components(separatedBy: .newlines).joined()
       let source = """
       var style = document.createElement('style');
       style.innerHTML = '\(cssString)';
       document.head.appendChild(style);
       """
       let userScript = WKUserScript(source: source,
                                     injectionTime: .atDocumentEnd,
                                     forMainFrameOnly: true)
       let userContentController = WKUserContentController()
       userContentController.addUserScript(userScript)
       let configuration = WKWebViewConfiguration()
       configuration.userContentController = userContentController
       
       webContent.navigationDelegate = self
       webContent.scrollView.isScrollEnabled = false
       webContent.scrollView.bounces = false
        conlblHeaderHeight.constant = UIDevice.current.userInterfaceIdiom == .pad ? 41 : 30
        DispatchQueue.main.async {
            self.lblTitle.updateConstraintsIfNeeded()
            self.lblTitle.layoutIfNeeded()
        }

        if pageIndex == 0 {
            self.viewstckVideo.isHidden = false
            self.viewstckbtn.isHidden = false
            self.btnBack.isHidden = true
            self.lblTitle.text = "Device Training Video"
            let dict = APP_DELEGATE.arrOpeIdNEW[MainIndex]
            pageControl.currentPage = pageIndex
            self.scrollChange.isUserInteractionEnabled = true
            let strApp = dict.traningVideoText
            loadHTMLContent(strApp)
            self.webContent.scrollView.alwaysBounceVertical = false
            self.webContent.scrollView.alwaysBounceHorizontal = false
            self.webContent.scrollView.bounces = false
            var VideoUrl:URL? = nil
            if dict.trainingVideoURL != nil && dict.trainingVideoURL?.absoluteString != "" {
                VideoUrl = dict.trainingVideoURL!
                APP_DELEGATE.strVideoUrl = dict.trainingVideoURL!
            }

            if  VideoUrl != nil {
                self.viewVideoPlayer.isHidden = false
                self.lblNoVideo.isHidden = true
                if player != nil {
                    player.play()
                    player.isMuted = false
                }else{
                    player = AVPlayer(url: VideoUrl!)
                    player?.isMuted = false
                    let playerController = AVPlayerViewController()
                    playerController.player = player
                    playerController.videoGravity = .resizeAspectFill
                    playerController.allowsPictureInPicturePlayback = false
                    self.addChild(playerController)
                    playerController.view.frame = self.viewVideoPlayer.frame
                    self.viewVideoPlayer.addSubview(playerController.view)
                    player.seek(to: CMTime.zero)
                    player.actionAtItemEnd = .none
                    addApplicationLifecycleObservers()
                    DispatchQueue.main.async {
                        self.player.play()
                    }
                    
                }
            } else {
                self.lblNoVideo.isHidden = false
                self.viewVideoPlayer.isHidden = true
            }

        }else if pageIndex == 1 {
            DispatchQueue.main.async {
                self.player?.pause()
                self.player?.isMuted = true
            }
            self.viewstckVideo.isHidden = true
            self.btnBack.isHidden = false
            let dict = APP_DELEGATE.arrOpeIdNEW[MainIndex]
            let strApp1 = dict.rentalAgreementText
            loadHTMLContent(strApp1)
            self.webContent.scrollView.isScrollEnabled = false
            self.webContent.scrollView.alwaysBounceVertical = false
            self.webContent.scrollView.alwaysBounceHorizontal = false
            self.webContent.scrollView.bounces = false
            self.lblTitle.text = "Rental Agreement"
            pageControl.currentPage = pageIndex
            

        } else  {
            DispatchQueue.main.async {
                self.player?.pause()
                self.player?.isMuted = true
            }
            self.viewstckVideo.isHidden = true
            self.btnBack.isHidden = false
            let dict = APP_DELEGATE.arrOpeIdNEW[MainIndex]
            scrollChange.reloadInputViews()
            self.lblTitle.text = "Terms & Conditions"
            let strApp2 = dict.termsAndConditionText
            self.webContent.scrollView.isScrollEnabled = false
            loadHTMLContent(strApp2)
            self.webContent.scrollView.alwaysBounceVertical = false
            self.webContent.scrollView.alwaysBounceHorizontal = false
            self.webContent.scrollView.bounces = false
            pageControl.currentPage = pageIndex
        }
    }
    
    
    func AgreeTapped() {
        if pageIndex < 2 {
            pageIndex = pageIndex + 1
            APP_DELEGATE.isAgree = false
            showData()
        } else {
            if MainIndex < (APP_DELEGATE.arrOpeIdNEW.count - 1) {
                MainIndex =  MainIndex + 1
                pageIndex = 0
                APP_DELEGATE.isAgree = false
                self.conwebViewHeight.constant = 0
                DispatchQueue.main.async {
                    self.webContent.layoutIfNeeded()
                    self.webContent.updateConstraintsIfNeeded()
                }
                showData()
            } else {
                APP_DELEGATE.isAgree = true
                removeApplicationLifecycleObservers()
                APP_DELEGATE.arrOpeIdNEW.removeAll()
                APP_DELEGATE.arrOpeId.removeAll()
                self.dismiss(animated: true, completion:nil)
            }
        }
    }
    

    //MARK: -AMAZON DATA

    // MARK: Application Lifecycle

    private var didPauseOnBackground = false

    @objc private func applicationDidEnterBackground(notification: Notification) {
        if player?.currentItem?.isPlaybackLikelyToKeepUp == true {
            didPauseOnBackground = true
            //pausePlayback()
            DispatchQueue.main.async {
                self.player?.pause()
            }
        } else {
            didPauseOnBackground = false
        }
    }

    @objc private func applicationDidBecomeActive(notification: Notification) {
        if didPauseOnBackground && player?.error == nil {
            didPauseOnBackground = false
            DispatchQueue.main.async {
                self.player?.pause()
            }
        }
    }

    private func addApplicationLifecycleObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    private func removeApplicationLifecycleObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

}
