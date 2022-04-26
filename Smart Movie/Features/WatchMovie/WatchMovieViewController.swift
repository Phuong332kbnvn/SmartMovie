//
//  WatchMovieViewController.swift
//  Smart Movie
//
//  Created by Phuong on 26/04/2022.
//

import UIKit
import AVFoundation

class WatchMovieViewController: UIViewController {

    @IBOutlet weak var playVideo: UIView!
    @IBOutlet weak var playVideoControl: UIView!
    @IBOutlet weak var viewControlVideo: UIView!
    @IBOutlet weak var lengthOfVideo: UILabel!
    @IBOutlet weak var videoProgressView: UIProgressView!
    @IBOutlet weak var playButton: UIButton!
    
    private var player: AVPlayer?
    private var playerContext = 0
    private var isPlaying = false
    private var isPlayingAudio = false
    
    private let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpVideo()
        videoProgressView.setProgress(0, animated: true)
    }
    
    func setUpVideo() {
        if let url = URL(string: videoURL) {
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            
            let playerLayer = AVPlayerLayer(player: player)
            playVideo.layer.addSublayer(playerLayer)
            playerLayer.frame = playVideo.bounds
            playVideo.bringSubviewToFront(playVideoControl)
            player?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            if let status = change?[.newKey] as? Int {
                let videoStatus: AVPlayerItem.Status = AVPlayerItem.Status(rawValue: status) ?? .unknown
                switch videoStatus {
                case .readyToPlay:
                    player?.play()
                    isPlaying = true
                    playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                    
                    var videoLength: String = ""
                    var secondsTotal: CGFloat = 0
                    
                    // get time
                    if let duration = player?.currentItem?.asset.duration {
                        let seconds = CMTimeGetSeconds(duration)
                        let secondTxt = String(format: "%02d", Int(seconds) % 60)
                        let minuteTxt = String(format: "%02d", Int(seconds) / 60)
                        secondsTotal = seconds
                        videoLength = "\(minuteTxt):\(secondTxt)"
                    }
                    
                    // get current time of video
                    let interval = CMTime(value: 1, timescale: 1)
                    player?.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { progress in
                        let seconds = CMTimeGetSeconds(progress)
                        let secondTxt = String(format: "%02d", Int(seconds) % 60)
                        let minuteTxt = String(format: "%02d", Int(seconds) / 60)
                        self.videoProgressView.setProgress(Float(seconds / secondsTotal), animated: true)
                        self.lengthOfVideo.text = "\(minuteTxt):\(secondTxt)/\(videoLength)"
                    })
                    
                    
                default:
                    break
                }
            }
        }
    }

    @IBAction func invokeButtonPlay(_ sender: UIButton) {
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying = !isPlaying
        playButton.setImage(isPlaying ? UIImage(systemName: "pause.fill") : UIImage(systemName: "play.fill"), for: .normal)
    }
    
    @IBAction func invokeBackButton(_ sender: UIButton) {
        guard let player = player else {
            return
        }
        
        let currentTime = CMTimeGetSeconds((player.currentTime()))
        var newTime = currentTime - 30.0
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player.seek(to: time)
    }
    
    @IBAction func invokeFowardButton(_ sender: UIButton) {
        guard let player = player else {
            return
        }

        guard let duration = player.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
            let newTime = currentTime + 30.0
            if newTime < (CMTimeGetSeconds(duration) - 30.0) {
                let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
                player.seek(to: time)
            }
    }
    @IBAction func invokeCloseButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        player?.pause()
    }
}
