//
//  PlaySongViewController.swift
//  NetEaseCloudMusic
//
//  Created by Ampire_Dan on 2016/7/14.
//  Copyright © 2016年 Ampire_Dan. All rights reserved.
//

import UIKit


class PlaySongViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var needleImageView: UIImageView!
    @IBOutlet weak var blurBackgroundImageView: UIImageView!
    @IBOutlet weak var swipableDiscView: UIScrollView!
    @IBOutlet weak var loveImageView: UIImageView!
    @IBOutlet weak var downloadImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var settingImageView: UIImageView!
    @IBOutlet weak var timePointLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentLocationSlider: UISlider!
    @IBOutlet weak var playModeImageView: UIImageView!
    @IBOutlet weak var lastSongImageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var nextImageView: UIImageView!
    @IBOutlet weak var totalSettingImageView: UIImageView!
    @IBOutlet weak var dotCurrentProcess: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // MARK: - Tap Action
    
    func tapPlayImage() -> Void {
        if isPlaying {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_play")
            needleDown()
        } else {
            playImageView.image = UIImage.init(named: "cm2_fm_btn_pause")
            needleUp()
        }
        isPlaying = !isPlaying
        isPlaying ? playSongService.startPlay() : playSongService.pausePlay()
    }
    
    func tapPrevSongImage() {
        playSongService.playPrev()
        currentSongIndex = playSongService.currentPlaySong
        currentSongIndexChange()
    }
    
    func tapNextSongImage() {
        playSongService.playNext()
        currentSongIndex = playSongService.currentPlaySong
        currentSongIndexChange()
    }
    
    func tapLoveImage() {
        if isLike {
            loveImageView.image = UIImage.init(named: "cm2_play_icn_love")
        } else {
            loveImageView.image = UIImage.init(named: "cm2_play_icn_loved")
            UIView.animateWithDuration(0.1, animations: {
                self.loveImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2)
                }, completion: { (finished) in
                    UIView.animateWithDuration(0.1, animations: {
                        self.loveImageView.transform = CGAffineTransformScale(self.loveImageView.transform, 0.8, 0.8)
                        }, completion: { (finished) in
                            UIView.animateWithDuration(0.1, animations: {
                                self.loveImageView.transform = CGAffineTransformScale(self.loveImageView.transform, 1, 1)
                                }, completion: { (finished) in
                                    self.loveImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
                            })
                    })
            })
        }
        isLike = !isLike
    }
    
    func tapPlayModeImage() {
        playMode.next()
        playModeChange()
        switch playMode {
        case PlayMode.Shuffle:
            playModeImageView.image = UIImage.init(named: "cm2_icn_shuffle")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_shuffle_prs")
            break
        case PlayMode.Cycle:
            playModeImageView.image = UIImage.init(named: "cm2_icn_loop")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_loop_prs")
            break
        case PlayMode.Repeat:
            playModeImageView.image = UIImage.init(named: "cm2_icn_one")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_one_prs")
            break
        case PlayMode.Order:
            playModeImageView.image = UIImage.init(named: "cm2_icn_order")
            playModeImageView.highlightedImage = UIImage.init(named: "cm2_icn_order_prs")
            break
        }
    }
    
    func tapBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func tapShareButton() {
        
    }
    
    // MARK: - Property
    
    var data: CertainSongSheet?
    var currentSongIndex = 0
    var picUrl = ""
    var blurPicUrl = ""
    var songname = ""
    var singers = ""
    
    var isPlaying = false
    var isLike = false
    var playMode = PlayMode.Order
    
    let playSongService = PlaySongService.sharedInstance
        
    private lazy var marqueeTitleLabel: MarqueeLabel = {
        let label =  MarqueeLabel.init(frame: CGRectMake(0, 0, 200, 24), duration: 10, fadeLength:10)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.type = .Continuous
        label.font = UIFont.systemFontOfSize(15)
        return label
    }()
    
    private lazy var singerNameLabel: UILabel = {
        let label = UILabel.init(frame: CGRectMake(0, 0, 200, 20))
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(11)
        label.center = CGPointMake(100, 33)
        label.textAlignment = .Center
        return label
    }()
    
    @IBOutlet weak var titleView: UIView!
    
    // MARK: Override method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataInit()
        viewsInit()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.sharedApplication().statusBarStyle = .Default
        setAnchorPoint(CGPointMake(0.5, 0.5), forView: self.needleImageView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var backButtonCenter = backButton.center
        backButtonCenter.y = 44
        backButton.center = backButtonCenter
        
        var shareButtonCenter = shareButton.center
        shareButtonCenter.y = 44
        shareButton.center = shareButtonCenter
    }
    
    // MARK: Supporting For Data
    
    // dataInit called only once
    func dataInit() {
        playSongService.playLists = data
        if isPlaying {
            playSongService.playCertainSong(currentSongIndex)
        }
    }
    
    func currentSongIndexChange()  {
        if let da = data {
            self.picUrl = da.tracks[currentSongIndex]["album"]!["picUrl"] as! String
            self.blurPicUrl = da.tracks[currentSongIndex]["album"]!["blurPicUrl"] as! String
            self.songname = da.tracks[currentSongIndex]["name"] as! String
            self.singers = da.tracks[currentSongIndex]["artists"]![0]["name"] as! String
        }
        changeTitleText()
        changeBackgroundBlurImage()
    }
    
    func playModeChange() {
        playSongService.playMode = playMode
    }
    
    // MARK: Supporting For View
    
    // viewsInit called only once
    func viewsInit() {
        // blurBackgroundImageView
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        visualEffectView.frame = blurBackgroundImageView.bounds
        blurBackgroundImageView.addSubview(visualEffectView)
        
        // swipableDiscView
        swipableDiscView.delegate = self
        
        // loveImageView
        let tapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapLoveImage))
        tapGest.numberOfTapsRequired = 1
        loveImageView.addGestureRecognizer(tapGest)
        
        // currentLocationSlider
        currentLocationSlider.setThumbImage(UIImage.init(named: "cm2_fm_playbar_btn"), forState: .Normal)
        currentLocationSlider.minimumTrackTintColor = FixedValue.mainRedColor
        
        // playModeImageView
        let ptapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayModeImage))
        playModeImageView.addGestureRecognizer(ptapGest)
        
        // lastSongImageView
        let ltapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPrevSongImage))
        lastSongImageView.addGestureRecognizer(ltapGest)
        
        // playImageView
        let PIVtapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapPlayImage))
        playImageView.addGestureRecognizer(PIVtapGest)
        
        // nextImageView
        let ntapGest = UITapGestureRecognizer.init(target: self, action: #selector(tapNextSongImage))
        nextImageView.addGestureRecognizer(ntapGest)
        
        // titleView
        titleView.addSubview(self.marqueeTitleLabel)
        titleView.addSubview(self.singerNameLabel)
        
        backButton.addTarget(self, action: #selector(tapBackButton), forControlEvents: .TouchUpInside)
        shareButton.addTarget(self, action: #selector(tapShareButton), forControlEvents: .TouchUpInside)
        
        changeTitleText()
        changeBackgroundBlurImage()
//        if isPlaying {
//            needleDown()
//        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    
    func needleUp() {
        
        let point = self.view.convertPoint(CGPointMake(self.view.bounds.size.width/2, 64), toView: self.needleImageView)
        let anchorPoint = CGPointMake(point.x/self.needleImageView.bounds.size.width, point.y/self.needleImageView.bounds.size.height)
        self.setAnchorPoint(anchorPoint, forView: self.needleImageView)
        
        let angle = CGFloat(0)
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.needleImageView.transform = CGAffineTransformMakeRotation(angle)
            }, completion: nil)
    }
    
    func needleDown() {
        
        let point = self.view.convertPoint(CGPointMake(self.view.bounds.size.width/2, 64), toView: self.needleImageView)
        let anchorPoint = CGPointMake(point.x/self.needleImageView.bounds.size.width, point.y/self.needleImageView.bounds.size.height)
        self.setAnchorPoint(anchorPoint, forView: self.needleImageView)
        
        let angle = -CGFloat(M_PI/360 * 50)
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.needleImageView.transform = CGAffineTransformMakeRotation(angle)
            }, completion: nil)
    }
    
    func changeTitleText() {
        marqueeTitleLabel.text = songname + "22222220000000000222"
        singerNameLabel.text = singers
    }
    
    func changeBackgroundBlurImage() {
        blurBackgroundImageView?.sd_setImageWithURL(NSURL.init(string: blurPicUrl))
    }
}

extension PlaySongViewController: UIScrollViewDelegate {
}
