//
//  PlayerDetailView.swift
//  Podcast
//
//  Created by ashim Dahal on 5/25/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import AlamofireImage
import AVKit

class PlayerDetailView: UIView {
   
    fileprivate let shrunkTransform = CGAffineTransform(scaleX: 0.7 , y: 0.7)
    
    var epishod : Epishod! {
        didSet{
            miniTitleLabel.text = epishod.title
            titleLabel.text = epishod.title
            autherLabel.text = epishod.author
            guard let epishodImageurl = epishod.imageUrl else {
                return
            }
            playEpishod()
            guard let url = URL(string: epishodImageurl) else {return}
            epishodImageView.af_setImage(withURL: url)
            miniEpishodImageView.af_setImage(withURL: url)
        }
    }
    let player : AVPlayer = {
        let avPlayer  = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    fileprivate func playEpishod(){
        let stream = epishod.streamUrl.toSecureHTTPS()
        guard let url = URL(string: stream) else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }
    
    fileprivate func enlargeEpishodImage(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.epishodImageView.transform = .identity
        })
    }
    
    fileprivate func shrinkEpishodView(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.epishodImageView.transform = self.shrunkTransform
        })
    }
    
    fileprivate func observePlayerCurrentTime() {
        // this method allow when player slowly updates itself in perodic interval
        
        let interval = CMTimeMake(1, 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self](time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            self?.miniCurrentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration.toDisplayString()
            self?.durationLabel.text = durationTime
            self?.miniDurationTimeLabel.text = durationTime
            self?.updateCurrentTimeSlider()
        }
        
    }
    
    
    fileprivate func updateCurrentTimeSlider(){
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationTimeSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(1, 1) )
        let percentage = currentTimeSeconds / durationTimeSeconds
        self.currentTimeSlider.value = Float(percentage)
        
    }
    
    var panGesture : UIPanGestureRecognizer!
    
    fileprivate func setupGesture() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
        
    }
    
    @objc func handleDismissalPan(gesture : UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        if gesture.state == .changed {
           
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
          
            
        }else if gesture.state == .ended {
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.maximizedStackView.transform = .identity
                
                if translation.y > 80 || velocity.y > 600{
                    UIApplication.mainTabBarController()?.minimizePlayerDetails()
                }
            })
        }
        
    }
    
    override func awakeFromNib() {
        // prepare receiver for service after nib file has been loaded.
        // allow additional functionality after view load from interface build archive or nib file
        super.awakeFromNib()
        
        setupGesture()
        observePlayerCurrentTime()
        
        // this allow monitoring of bigining of player whenever it starts
        let time = CMTimeMake(1, 3)
        let times = [NSValue(time:time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeEpishodImage()
        }
    }
    
    static func initFromNib() -> PlayerDetailView {
        let playerDetailView = Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailView
        
        return playerDetailView
    }
    
    
    //MARK:- IB actions and outlets

    @IBAction func miniSlider(_ sender: Any) {
        let percentage = miniSliderLabel.value
        handleSliderChange(percentage: percentage, miniSlider: true)
    }
    @IBOutlet weak var miniSliderLabel: UISlider!
    
    @IBOutlet weak var miniCurrentTimeLabel: UILabel!
    @IBOutlet weak var miniDurationTimeLabel: UILabel!
    
    @IBOutlet weak var miniPlayerView: UIStackView!
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    @IBOutlet weak var miniEpishodImageView: UIImageView!
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
            miniPlayPauseButton.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5)
        }
    }
    @IBOutlet weak var miniTitleLabel: UILabel!{
        didSet {
            miniTitleLabel.numberOfLines = 2
        }
    }
    @IBOutlet weak var miniFastForward: UIButton! {
        didSet{
            miniFastForward.addTarget(self, action: #selector(handleFastForward(_:)), for: .touchUpInside)
            miniFastForward.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5)
        }
    }
    
    
    @IBAction func handleDismiss(_ sender: Any) {
//        self.removeFromSuperview()
        UIApplication.mainTabBarController()?.minimizePlayerDetails()
        
       
    }
    @IBAction func handleRewind(_ sender: Any) {
    
        seekToCurrentTime(delta: -15)
    }
   
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    fileprivate func seekToCurrentTime(delta : Int64){
        let fifteenSecond = CMTimeMake(delta, Int32(1))
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSecond)
        player.seek(to: seekTime)
        
    }
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    fileprivate func handleSliderChange(percentage : Float, miniSlider : Bool){
        guard let duration = player.currentItem?.duration else {return}
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, Int32(NSEC_PER_SEC))
        player.seek(to: seekTime)
        
        if miniSlider {
            currentTimeSlider.value = percentage
        }else{
            miniSliderLabel.value = percentage
        }
        
    }
    
    @IBAction func handleCurrentTimeSliderChange(_ sender: Any){
        let percentage = currentTimeSlider.value
        handleSliderChange(percentage: percentage, miniSlider: false)
    }


    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var currentTimeSlider: UISlider!

    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var epishodImageView: UIImageView! {
        didSet{
            epishodImageView.transform = shrunkTransform
            epishodImageView.layer.cornerRadius = 10
            epishodImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var autherLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet{
            titleLabel.numberOfLines = 2
        }
    }
    
    @objc fileprivate func handlePlayPause(){
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpishodImage()
            
        }else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpishodView()
        }
    }
}

