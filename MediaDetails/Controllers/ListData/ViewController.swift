//
//  ViewController.swift
//  MediaDetails
//
//

import UIKit

class ViewController: UIViewController {
    
    var objMedia: Media?

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewLoader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.getMediaData()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let idDeletedMedia = AppSingleton.shared.deletedMediaId {
            if let arrCategory = self.objMedia?.categories {
                for (i,objCategory) in arrCategory.enumerated() {
                    if let arrVideos = objCategory.videos {
                        for (j,objVideo) in arrVideos.enumerated() {
                            if objVideo.id == idDeletedMedia {
                                self.tblView.reloadRows(at: [IndexPath(row: j, section: i)], with: .automatic)
                                AppSingleton.shared.deletedMediaId = nil
                                return
                            }
                        }
                    }
                }
            }
        }
    }

    //MARK: PRIVATE METHODS

    private func setupView() {
        self.title = "Media List"
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.sectionHeaderHeight = .leastNormalMagnitude
        self.tblView.register(UINib(nibName: "MediaListCell", bundle: nil), forCellReuseIdentifier: "MediaListCell")
        self.tblView.reloadData()
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.objMedia?.categories?[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objMedia?.categories?[section].videos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaListCell", for: indexPath) as? MediaListCell else {
            return UITableViewCell()
        }
        let objVideo = self.objMedia?.categories?[indexPath.section].videos?[indexPath.row]
        cell.tag = indexPath.row
        cell.setupData(objVideo: objVideo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MediaDetailsVC") as? MediaDetailsVC else {
            return
        }
        vc.objVideo = self.objMedia?.categories?[indexPath.section].videos?[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: API CALLS
extension ViewController {
    func getMediaData() {
        self.viewLoader.isHidden = false
        self.viewLoader.startAnimating()
        Media.getMediaDataAPI{ (objMedia, error) in
            self.viewLoader.isHidden = true
            self.viewLoader.stopAnimating()
            self.objMedia = objMedia
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }
}

