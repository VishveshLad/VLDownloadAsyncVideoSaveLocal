//
//  MediaListCell.swift
//  MediaDetails
//
//

import UIKit
import Kingfisher
import Alamofire

class MediaListCell: UITableViewCell {
    
    var objVideo: Video?

    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDownloadStatus: UILabel!
    @IBOutlet weak var btnDownload: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(objVideo: Video?) {
        self.objVideo = objVideo
        
        let url = URL(string: Constant.baseUrl)?.appending(component: self.objVideo?.thumb ?? "")
        self.imgThumb.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        self.lblTitle.text = self.objVideo?.title
        self.lblSubTitle.text = self.objVideo?.subtitle
        
        self.lblDownloadStatus.tag = self.tag
        
        self.getMediaStatus()
    }
    
    @IBAction func btnDownload_Clicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            if let progress = self.objVideo?.isDownloadingProcess, progress == DownloadStatus.Download {
                self.downloadMedia(id: self.objVideo?.id)
                self.objVideo?.isDownloadingProcess = .Downloading
                self.lblDownloadStatus.text = self.objVideo?.isDownloadingProcess.rawValue
            }else{
                self.lblDownloadStatus.text = self.objVideo?.isDownloadingProcess.rawValue
            }
        }
    }
}

extension MediaListCell {
    
    func getMediaStatus() {
        let mediaUrlString = self.objVideo?.sources?.first ?? ""
        let url = URL(string: mediaUrlString)
        let mediaLastComponent = url?.lastPathComponent ?? "\(UUID().uuidString).mp4"
        var documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        documentsPathURL = documentsPathURL?.appending(component: mediaLastComponent)
        let filePath = documentsPathURL?.path ?? ""
        DispatchQueue.main.async {
            if FileManager.default.fileExists(atPath: filePath) {
                self.objVideo?.isDownloadingProcess = .Downloaded
                self.lblDownloadStatus.text = self.objVideo?.isDownloadingProcess.rawValue
                self.btnDownload.isUserInteractionEnabled = false
            }else{
                if let progress = self.objVideo?.isDownloadingProcess{
                    if progress == DownloadStatus.Downloading {
                        self.objVideo?.isDownloadingProcess = .Downloading
                        self.btnDownload.isUserInteractionEnabled = false
//                        self.lblDownloadStatus.text = self.objVideo?.isDownloadingProcess.rawValue
                    }else{
                        self.objVideo?.isDownloadingProcess = .Download
                        self.lblDownloadStatus.text = self.objVideo?.isDownloadingProcess.rawValue
                        self.btnDownload.isUserInteractionEnabled = true
                    }
                }else{
                    self.objVideo?.isDownloadingProcess = .Download
                    self.lblDownloadStatus.text = self.objVideo?.isDownloadingProcess.rawValue
                    self.btnDownload.isUserInteractionEnabled = true
                }
                
            }
        }
    }
    
    
    func downloadMedia(id: Int?) {
        let mediaUrlString = self.objVideo?.sources?.first ?? ""
        let url = URL(string: mediaUrlString)
        let mediaLastComponent = url?.lastPathComponent ?? "\(UUID().uuidString).mp4"
        var documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        documentsPathURL = documentsPathURL?.appending(component: mediaLastComponent)
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
        
        guard let url = url else {
            return
        }
        
        AF.download(url,to: destination).downloadProgress { (progress) in
            DispatchQueue.main.async {
                if self.objVideo?.id == (id ?? 0){
                    self.lblDownloadStatus.text = String(format: "%.2f", ((progress.fractionCompleted) * 100)).appending("%")
                }else{
                    self.lblDownloadStatus.text = self.objVideo?.isDownloadingProcess.rawValue
                }
                print(progress)
            }
        }.responseData { (response) in
            switch response.result {
                
            case .success(let data):
                guard let documentsPathURL = documentsPathURL else {
                    return
                }
                do {
                    try data.write(to: documentsPathURL)
                    print("URL: -", documentsPathURL)
                } catch {
                    self.objVideo?.isDownloadingProcess = .Download
                    print("Something went wrong!")
                }
                self.getMediaStatus()
            case .failure(let error):
                self.objVideo?.isDownloadingProcess = .Download
                print(error.localizedDescription)
                self.getMediaStatus()
            }
        }
    }
}
