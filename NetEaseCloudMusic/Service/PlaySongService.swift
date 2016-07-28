//
//  PlaySongService.swift
//  NetEaseCloudMusic
//
//  Created by Zhengda Lee on 7/23/16.
//  Copyright © 2016 Ampire_Dan. All rights reserved.
//

import UIKit
import AVFoundation

enum PlayMode: Int {
    case Repeat = 1
    case Order = 2
    case Cycle = 3
    case Shuffle = 4
    
    mutating func next() {
        switch self {
        case .Repeat:
            self = .Order
        case .Order:
            self = .Cycle
        case .Cycle:
            self = .Shuffle
        case .Shuffle:
            self = .Repeat
        }
    }
}

protocol PlaySongServiceDelegate: class {
    func updateProgress(currentTime: Float64, durationTime: Float64)
    func didChangeSong()
}


class PlaySongService: NSObject {
    static let sharedInstance = PlaySongService()
    private override init() {}
    
    weak var delegate: PlaySongServiceDelegate?
    
    var playMode = PlayMode.Order
    var playLists: CertainSongSheet? {
        didSet {
            currentPlaySong = 0
        }
    }
    
    var currentPlaySong: Int = 0
    
    private var songPlayer: AVPlayer?
    private var out_context = 0
    private var playTimeObserver: AnyObject?
    
    // play next song
    func playNext() {
        if let playlists = playLists {
            currentPlaySong = (currentPlaySong + 1) % (playlists.tracks.count)
            if playMode == .Shuffle {
                currentPlaySong = random() % (playlists.tracks.count)
            }
            playIt(playlists.tracks[currentPlaySong]["mp3Url"] as! String)
        }
    }
    
    // play prev song
    func playPrev() {
        if let playlists = playLists {
            currentPlaySong -= 1
            if currentPlaySong < 0 {
                currentPlaySong = (playlists.tracks.count) - 1
            }
            if playMode == .Shuffle {
                currentPlaySong = random() % (playlists.tracks.count)
            }
            playIt(playlists.tracks[currentPlaySong]["mp3Url"] as! String)
        }
    }
    
    // play index'th song
    func playCertainSong(index: Int) {
        if let playlists = playLists {
            if index >= 0 && index < playlists.tracks.count {
                currentPlaySong = index
                playIt(playlists.tracks[currentPlaySong]["mp3Url"] as! String)
            }
        }
    }
    
    // pause play
    func pausePlay() {
        songPlayer?.pause()
    }
    
    // play a song at a certain time point
    func playStartPoint(percent: Float) {
        let timeScale = self.songPlayer?.currentItem?.asset.duration.timescale
        let targetTime = CMTimeMakeWithSeconds(Float64(percent) * CMTimeGetSeconds((self.songPlayer?.currentItem?.duration)!), timeScale!)
        songPlayer?.seekToTime(targetTime)
    }
    
    func startPlay() {
        if let player = songPlayer {
            player.play()
        } else {
            playCertainSong(0)
        }
    }
    
    private func playIt(urlString: String) -> Void {
        let player = AVPlayer.init(URL: NSURL.init(string: urlString)!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(playerItemDidReachEnd(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
        player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: &out_context)
        
        if let songplayer = songPlayer {
            songplayer.removeObserver(self, forKeyPath: "status")
            // songPlayer can only be assign here
            NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
            if playTimeObserver != nil {
                songplayer.removeTimeObserver(playTimeObserver!)
                playTimeObserver = nil
            }
        }
        songPlayer = player
        playTimeObserver = songPlayer?.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: dispatch_get_main_queue(), usingBlock: { [unowned self] (time) in
            let currentTime = CMTimeGetSeconds(time)
            let totalTime = CMTimeGetSeconds((self.songPlayer?.currentItem?.duration)!)
            self.delegate?.updateProgress(currentTime, durationTime: totalTime)
        })
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) -> Void {
        if context == &out_context {
            if let player = songPlayer {
                switch player.status {
                    case .Unknown:
                        break
                    case .ReadyToPlay:
                        player.play()
                        break
                    case .Failed:
                        break
                }

            }
        }
    }
    
    func playerItemDidReachEnd(notification: NSNotification) -> Void {
        print("playerItemDidReachEnd")
        if let playlists = playLists {
            if currentPlaySong == playlists.tracks.count && playMode == PlayMode.Order {
                return
            }
            playNext()
            self.delegate?.didChangeSong()
        }
    }
    
}
