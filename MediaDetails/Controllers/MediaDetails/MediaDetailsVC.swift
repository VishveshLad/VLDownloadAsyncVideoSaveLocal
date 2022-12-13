//
//  MediaDetailsVC.swift
//  MediaDetails
//
//

import UIKit
import AVFoundation

class MediaDetailsVC: UIViewController {
    
    var objVideo: Video?
    
    var player: AVPlayer?
    var isVideoPlaying: Bool = false

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDownloadStatus: UILabel!
    @IBOutlet weak var lblFileSize: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var viewVideoPreview: UIView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    deinit {
        print("Deinit \(self)")
        self.clearPlayerData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }

    func setupView() {
        self.title = "Details"
        self.lblTitle.text = "Title :- " + (self.objVideo?.title ?? "")
        self.lblSubTitle.text = "SubTitle :- " + (self.objVideo?.subtitle ?? "")
        
        self.lblDownloadStatus.text = "Status :- " + (self.objVideo?.isDownloadingProcess.rawValue ?? "")
        self.lblFileSize.text = "File Size :- " + (self.objVideo?.getMediaUrl()?.getFileSize()?.covertToFileString().str ?? "-")
        self.lblDesc.text = self.objVideo?.videoDescription
        
        self.lblFileSize.isHidden = self.objVideo?.isDownloadingProcess == .Downloaded ? false : true
        
        self.btnDelete.isHidden = self.objVideo?.isDownloadingProcess == .Downloaded ? false : true
        
        self.addPlayerToView()
        
        self.loadVideo()
    }
    
    func managePlayPuase() {
        if self.isVideoPlaying {
            self.pauseVideo()
        }else{
            self.playVideo()
        }
    }
    
    func playVideo() {
        self.isVideoPlaying = true
        self.player?.play()
        self.btnPlay.isSelected = true
    }
    
    func pauseVideo() {
        self.isVideoPlaying = false
        self.player?.pause()
        self.btnPlay.isSelected = false
    }
    
    func deleteMedia() {
        guard let videoURL = self.objVideo?.getMediaUrl() else {
            return
        }
        
        if FileManager.default.fileExists(atPath: videoURL.path) {
            do {
                try FileManager.default.removeItem(at: videoURL)
                self.objVideo?.isDownloadingProcess = .Download
                self.lblDownloadStatus.text = "Status :- " + (self.objVideo?.isDownloadingProcess.rawValue ?? "")
                self.lblFileSize.isHidden = self.objVideo?.isDownloadingProcess == .Downloaded ? false : true
                self.btnDelete.isHidden = true
                AppSingleton.shared.deletedMediaId = self.objVideo?.id
            }catch {
                print(error)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    fileprivate func clearPlayerData() {
        self.player = nil
    }

    fileprivate func loadVideo() {
        guard let videoURL = self.objVideo?.getMediaUrl() else {
            return
        }
        let playerItem = AVPlayerItem(url: videoURL)
        player?.replaceCurrentItem(with: playerItem)
    }
    
    fileprivate func addPlayerToView() {
        player = AVPlayer()
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.viewVideoPreview.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.viewVideoPreview.layer.addSublayer(playerLayer)
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func playerEndPlay() {
        print("Player ends playing video")
        self.player?.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
        self.pauseVideo()
    }
    
    @IBAction func btnPlay_Clicked(_ sender: UIButton) {
        self.managePlayPuase()
    }
    
    @IBAction func btnDelete_Clicked(_ sender: UIButton) {
        self.deleteMedia()
    }
}
