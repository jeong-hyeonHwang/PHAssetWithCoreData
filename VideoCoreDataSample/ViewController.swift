//
//  ViewController.swift
//  VideoCoreDataSample
//
//  Created by 황정현 on 2022/10/18.
//

import UIKit
import SnapKit
import PhotosUI
import AVKit
import CoreVideo

class ViewController: UIViewController{
    
    lazy var pickerTestButton: UIButton = {
        let button = UIButton()
        button.setTitle("POP PHPICKER", for: .normal)
        return button
    }()
    
    lazy var playVideoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play Video Butotn", for: .normal)
        return button
    }()
    
    lazy var makeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Make Collection", for: .normal)
        return button
    }()
    
    var array: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        [pickerTestButton, playVideoButton, makeButton].forEach({
            view.addSubview($0)
        })
        
        layoutConfigure()
        componentConfigure()
        
        DataManager.shared.removeAllData()
        let tempInfo = VideoInformation(gymName: "gName", gymVisitDate: Date(), videoName: "vName", problemLevel: 0, isSucceed: false, isFavorite: false)
        DataManager.shared.addData(info: tempInfo)
        print("Current ", DataManager.shared.fetchReturnData().count)
        
        
    }
    
    func layoutConfigure() {
        pickerTestButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        })
        
        playVideoButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(pickerTestButton).inset(200)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        })
        
        makeButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(playVideoButton).inset(100)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        })
    }
    
    func componentConfigure() {
        pickerTestButton.addTarget(self, action: #selector(testFunc)
                                   , for: .touchUpInside)
        playVideoButton.addTarget(self, action: #selector(saveFunc), for: .touchUpInside)
        makeButton.addTarget(self, action: #selector(makeDirectoryInPhotos), for: .touchUpInside)
    }
    
    @objc func testFunc() {
        
        let photoLibrary = PHPhotoLibrary.shared()
        var config = PHPickerConfiguration(photoLibrary: photoLibrary)
        config.filter = .videos
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 15
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func saveFunc() {
        for i in 0..<array.count {
            print("hi")
//            VideoFileManager.shared.saveVideo(url: array[i], name: "movie\(i).mp4", onSuccess: { success in print(success) })
            let assets = PHAsset.fetchAssets(withLocalIdentifiers: array, options: .none)
            VideoFileManager.shared.playVideo(view: self, asset: assets[0])
            print("bye")
        }
    }
    @objc func presentVideo() {
        DispatchQueue.main.async {
            guard let contentUrls = try? FileManager.default.contentsOfDirectory(at: .documentsDirectory, includingPropertiesForKeys: nil) else { return }
            let player = AVPlayer(url: contentUrls[0])
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            self.present(playerVC, animated: true, completion: nil)
            print(contentUrls)
            print(contentUrls)
        }
    }
    
    @objc func makeDirectoryInPhotos() {
        PHPhotoLibrary.shared().performChanges {
            // MARK: Collection 만들기
//            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: "hi")
        } completionHandler: { success, error in
            print("Finished Adding the album from the folder. \(success ? "Success" : String(describing: error))")
        }
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let provider = results.first?.itemProvider else {return}
        
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        print("HEEEREEE")
        for i in 0..<fetchResult.count {
            let localIdentifier = fetchResult[i].localIdentifier
            print(localIdentifier)
            array.append(localIdentifier)
        }
        print(fetchResult.count)
//        dismiss(animated: true)
        provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
            guard error == nil else{
                print(error)
                return
            }
            // receiving the video-local-URL / filepath

            print(url)
            
//            FAB3A40A-34D3-4C7A-A775-A92E4D066B7A/L0/001
//            FAB3A40A-34D3-4C7A-A775-A92E4D066B7A/L0/001
            DispatchQueue.main.async {
                
//                let player = AVPlayer(url: newUrl)
//                let playerVC = AVPlayerViewController()
//                playerVC.player = player
                
//                VideoFileManager.shared.saveVideo(url: newUrl, name: "거지같은거.mp4", onSuccess: { success in print(success) })
                
                for i in 0..<fetchResult.count {
                    let tempInfo = VideoInformation(gymName: "gName", gymVisitDate: Date(), videoName: "vName", problemLevel: 0, isSucceed: false, isFavorite: false)
                    DataManager.shared.addData(info: tempInfo)
                    guard let url = url else {return}
                    // create a new filename
//                    let fileName = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
//                    // create new URL
//                    let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
//                    // copy item to APP Storage
//                    try? FileManager.default.copyItem(at: url, to: newUrl)
//                    self.array.append(newUrl)
//                    try? FileManager.default.removeItem(at: newUrl)
                }
                print("Current ", DataManager.shared.fetchReturnData().count)
                
                DataManager.shared.reviseData()
                print("Current GYM ", DataManager.shared.fetchReturnData()[0].gymName)
//                self.duplicatePhoto(url: newUrl)
                
//                try? FileManager.default.removeItem(at: newUrl)
//                self.present(playerVC, animated: true, completion: nil)
            }
        }
        dismiss(animated: true)
    }
    
    // MARK: 갤러리의 영상 url을 기반으로 사용자 정의 앨범에 영상을 추가한다.
    func duplicatePhoto(url: URL) {
        CustomPhotoAlbum.sharedInstance.save(url, completion: { result, error in
            print("COMPLETE!!!")
            if let e = error {
                // handle error
                return
            }
            // save successful, do something (such as inform user)
        })
    }
}
