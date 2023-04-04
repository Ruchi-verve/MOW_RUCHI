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
import AmazonIVSPlayer

protocol onClickPortrait {
    func onPortraitClick()
}


class LandScapeView: UIView, IVSPlayer.Delegate {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet private var bufferIndicator: UIActivityIndicatorView!
    @IBOutlet private var controlsView: UIView!
    @IBOutlet private var playButton: UIButton!
    @IBOutlet private var pauseButton: UIButton!
    @IBOutlet private var currentPositionLabel: UILabel!
    @IBOutlet private var seekSlider: UISlider!
    @IBOutlet private var durationLabel: UILabel!
    @IBOutlet private var bufferedRangeProgressView: UIProgressView!
    @IBOutlet private var viewLandscape: IVSPlayerView!
    @IBOutlet private var btnPortrait: UIButton!

    var delegate : onClickPortrait?
   override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    
    func commonInit() {
        Bundle.main.loadNibNamed("LandScapeView", owner: self, options: nil)
        contentView.frame = self.bounds
        innerView.clipsToBounds = true
        contentView.fixInView(self)
        btnPortrait.imageView?.image? =  (btnPortrait.imageView?.image?.imageWithColor(color: UIColor.white))!

        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.height,height: UIScreen.main.bounds.width))
            let degrees:CGFloat = -90 //angle to convert upside down
            let rotate = CGAffineTransform(rotationAngle:degrees * CGFloat(Double.pi)/180)
            let center = self.center
            let translate = CGAffineTransform(translationX: center.x + center.y - self.bounds.width,
                                              y: center.y - center.x)
            self.transform = translate.concatenating(rotate)
        }
        connectProgress()
        self.showData()
            playButton.imageView?.image?   =  (playButton.imageView?.image?.imageWithColor(color: UIColor.white))!
            pauseButton.imageView?.image? =  (pauseButton.imageView?.image?.imageWithColor(color: UIColor.white))!
        btnPortrait.imageView?.image? =  (btnPortrait.imageView?.image?.imageWithColor(color: UIColor.white))!
    }
    
    // MARK: IBAction

    @IBAction private func playTapped(_ sender: Any) {
        startPlayback()
    }
    @IBAction private func btnPortrairTapped(_ sender: Any) {
        pausePlayback()
        tearDownDisplayLink()
        self.durationLabel.text = ""
        self.currentPositionLabel.text = ""
        if delegate != nil {
            delegate?.onPortraitClick()
        }
    }

    @IBAction private func pauseTapped(_ sender: Any) {
        pausePlayback()
    }

    @IBAction private func onSeekSliderValueChanged(_ sender: UISlider, event: UIEvent) {
        guard let touchEvent = event.allTouches?.first else {
            seek(toFractionOfDuration: sender.value)
            return
        }
        switch touchEvent.phase {
        case .began, .moved:
            seekStatus = .choosing(sender.value)

        case .ended:
            seek(toFractionOfDuration: sender.value)

        case .cancelled:
            seekStatus = nil

        default: ()
        }
    }
    
    func showData() {
        loadStream(from: APP_DELEGATE.strVideoUrl)
        setUpDisplayLink()
            startPlayback()
    }
    
    //MARK: -AMAZON DATA
    // MARK: Application Lifecycle
    private var didPauseOnBackground = false
    @objc private func applicationDidEnterBackground(notification: Notification) {
        if player?.state == .playing || player?.state == .buffering {
            didPauseOnBackground = true
            pausePlayback()
        } else {
            didPauseOnBackground = false
        }
    }

    @objc private func applicationDidBecomeActive(notification: Notification) {
        if didPauseOnBackground && player?.error == nil {
            startPlayback()
            didPauseOnBackground = false
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

    // MARK: State display
    private var playbackPositionDisplayLink: CADisplayLink?

    private func setUpDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: #selector(playbackDisplayLinkDidFire(_:)))
        displayLink.isPaused = player?.state != .playing
        displayLink.add(to: .main, forMode: .common)
        playbackPositionDisplayLink = displayLink
    }

    private func tearDownDisplayLink() {
        playbackPositionDisplayLink?.invalidate()
        playbackPositionDisplayLink = nil
    }

    @objc private func playbackDisplayLinkDidFire(_ displayLink: CADisplayLink) {
        self.updatePositionDisplay()
        self.updateBufferProgress()
    }

    private let timeDisplayFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    private func updatePositionDisplay() {
        guard let player = self.player else {
            currentPositionLabel.text = nil
            return
        }
        let playerPosition =  player.position
        let duration =  player.duration
        let position: CMTime
        switch seekStatus {
        case let .choosing(fractionOfDuration):
            position = CMTimeMultiplyByFloat64(duration, multiplier: Float64(fractionOfDuration))
        case let .requested(seekPosition):
            position = seekPosition
        case nil:
            position = playerPosition
            updateSeekSlider(position: position, duration: duration)
        }
        guard position.seconds.isNormal else { return }
        currentPositionLabel.text = "\(timeDisplayFormatter.string(from: position.seconds) ?? "00:00")/\(durationLabel.text!)"
    }

    private var bufferedRangeProgress: Progress? {
        didSet {
            connectProgress()
        }
    }

    private func connectProgress() {
        bufferedRangeProgressView?.observedProgress = bufferedRangeProgress
    }

    private func updateBufferProgress() {
        guard let duration = player?.duration, let buffered = player?.buffered,
            duration.isNumeric, buffered.isNumeric else {
                bufferedRangeProgress?.completedUnitCount = 0
                return
        }
        let scaledBuffered = buffered.convertScale(duration.timescale, method: .default)
        bufferedRangeProgress?.completedUnitCount = scaledBuffered.value
    }

    private enum SeekStatus: Equatable {
        case choosing(Float)
        case requested(CMTime)
    }

    private var seekStatus: SeekStatus? {
        didSet {
            updatePositionDisplay()
        }
    }
    
    private func updateSeekSlider(position: CMTime, duration: CMTime) {
        if duration.isNumeric && position.isNumeric {
            let scaledPosition = position.convertScale(duration.timescale, method: .default)
            let progress = Double(scaledPosition.value) / Double(duration.value)
            seekSlider.setValue(Float(progress), animated: false)
        }
    }

    private func updateForState(_ state: IVSPlayer.State) {
        playbackPositionDisplayLink?.isPaused = state != .playing
        let showPause = state == .playing || state == .buffering
        pauseButton.isHidden = !showPause
        playButton.isHidden = showPause
        playButton.imageView?.image?   =  (playButton.imageView?.image?.imageWithColor(color: UIColor.white))!
        pauseButton.imageView?.image? =  (pauseButton.imageView?.image?.imageWithColor(color: UIColor.white))!
        btnPortrait.imageView?.image? =  (btnPortrait.imageView?.image?.imageWithColor(color: UIColor.white))!
        if state == .buffering {
            bufferIndicator?.startAnimating()
        } else {
            bufferIndicator?.stopAnimating()
        }

    }

    private func updateForDuration(duration: CMTime) {
        if duration.isIndefinite {
            durationLabel.text = "Live"
            durationLabel.isHidden = false
            seekSlider.isHidden = true
            bufferedRangeProgressView.isHidden = true
            bufferedRangeProgress = nil
        } else if duration.isNumeric {
            durationLabel.isHidden = true
            durationLabel.textColor = .clear
            durationLabel.text = timeDisplayFormatter.string(from: duration.seconds)
            currentPositionLabel.text = "\(currentPositionLabel.text! == "" ? "00:00:00":currentPositionLabel.text!)/\( durationLabel.text!)"
            durationLabel.isHidden = false
            seekSlider.isHidden = false
            bufferedRangeProgress = Progress.discreteProgress(totalUnitCount: duration.value)
            updateBufferProgress()
            bufferedRangeProgressView.isHidden = false
        } else {
            durationLabel.text = nil
            durationLabel.isHidden = true
            seekSlider.isHidden = true
            bufferedRangeProgressView.isHidden = true
            bufferedRangeProgress = nil
        }
    }

    // MARK: - Player
    var player: IVSPlayer? {
        didSet {
            if oldValue != nil {
                removeApplicationLifecycleObservers()
            }
            viewLandscape?.player = player
            seekStatus = nil
            updatePositionDisplay()
            if player != nil {
                addApplicationLifecycleObservers()
            }
        }
    }

    // MARK: Playback Control

    func loadStream(from streamURL: URL) {
        let player: IVSPlayer
        if let existingPlayer = self.player {
            player = existingPlayer
        } else {
            player = IVSPlayer()
            player.delegate = self
            self.player = player
            print("ℹ️ Player initialized: version \(player.version)")
        }
        player.load(streamURL)
    }

    private func seek(toFractionOfDuration fraction: Float) {
        guard let player = player else {
            seekStatus = nil
            return
        }
        let position = CMTimeMultiplyByFloat64(player.duration, multiplier: Float64(fraction))
        seek(to: position)
    }

    private func seek(to position: CMTime) {
        guard let player = player else {
            seekStatus = nil
            return
        }
        seekStatus = .requested(position)
        player.seek(to: position) { [weak self] _ in
            guard let self = self else {
                return
            }
            if self.seekStatus == .requested(position) {
                self.seekStatus = nil
            }
        }
    }

    private func startPlayback() {
        player?.play()
    }

    private func pausePlayback() {
        player?.pause()
    }
   
    //DELEGATE FUNCTIONS
    
    func player(_ player: IVSPlayer, didChangeState state: IVSPlayer.State) {
        updateForState(state)
    }

    func player(_ player: IVSPlayer, didFailWithError error: Error) {
        print("Content is:\(error)")
    }

    func player(_ player: IVSPlayer, didChangeDuration duration: CMTime) {
        updateForDuration(duration: duration)
    }

    func player(_ player: IVSPlayer, didOutputCue cue: IVSCue) {
        switch cue {
        case let textMetadataCue as IVSTextMetadataCue:
            print("Received Timed Metadata (\(textMetadataCue.textDescription)): \(textMetadataCue.text)")
        case let textCue as IVSTextCue:
            print("Received Text Cue: “\(textCue.text)”")
        default:
            print("Received unknown cue (type \(cue.type))")
        }
    }

    func playerWillRebuffer(_ player: IVSPlayer) {
        print("Player will rebuffer and resume playback")
    }
}




