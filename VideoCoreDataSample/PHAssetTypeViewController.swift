//
//  PHAssetTypeViewController.swift
//  VideoCoreDataSample
//
//  Created by 황정현 on 2022/10/21.
//

import UIKit
import SnapKit
import PhotosUI
import AVKit
import CoreVideo

class PHAssetTypeViewController: UIViewController {
    
    lazy var popPickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("POP PHPICKER", for: .normal)
        return button
    }()
    
    lazy var playVideoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play Video Butotn", for: .normal)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Video Save", for: .normal)
        return button
    }()
    
    lazy var removeAllButton: UIButton = {
       let button = UIButton()
        button.setTitle("Remove All Video", for: .normal)
        return button
    }()
    
    var array: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        [popPickerButton, playVideoButton, saveButton, removeAllButton].forEach({
            view.addSubview($0)
            $0.backgroundColor = .yellow
            $0.setTitleColor(.black, for: .normal)
        })
        
        layoutConfigure()
        componentConfigure()
        
    }
    
    func layoutConfigure() {
        popPickerButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        })
        
        playVideoButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(popPickerButton).inset(200)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(75)
        })
        
        saveButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(playVideoButton).inset(100)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(75)
        })
        
        removeAllButton.snp.makeConstraints({
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        })
    }
    
    func componentConfigure() {
        popPickerButton.addTarget(self, action: #selector(showPhotoPicker)
                                  , for: .touchUpInside)
        playVideoButton.addTarget(self, action: #selector(LoadVideoFile), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveVideo), for: .touchUpInside)
        removeAllButton.addTarget(self, action: #selector(removeAllData), for: .touchUpInside)
    }
    
    @objc func showPhotoPicker() {
        
        let photoLibrary = PHPhotoLibrary.shared()
        var config = PHPickerConfiguration(photoLibrary: photoLibrary)
        config.filter = .videos
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 15
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func LoadVideoFile() {
        let array = DataManager.shared.fetchReturnData()
        var identifiers: [String] = []
        for item in array {
            identifiers.append(item.videoName ?? "")
        }
        
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: .none)
        
        VideoFileManager.shared.playVideo(view: self, asset: assets[0])
    }
    @objc func saveVideo() {
        print("----------")
        for videoIdentifier in array {
            DataManager.shared.addData(info: VideoInformation(gymName: "NOEIJIE", gymVisitDate: Date(), videoName: videoIdentifier, problemLevel: 2, isSucceed: false, isFavorite: false))
            print("Saved Video!")
        }
        array.removeAll()
        print("----------")
    }
    
    @objc func removeAllData() {
        DataManager.shared.removeAllData()
        print("REMOVED ALL DATA")
    }
}

extension PHAssetTypeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let provider = results.first?.itemProvider else {return}
        
        let identifiers = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        for i in 0..<fetchResult.count {
            let localIdentifier = fetchResult[i].localIdentifier
            print(localIdentifier)
            array.append(localIdentifier)
        }
        print("FETCHED FOR ", fetchResult.count)
        provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
            guard error == nil else {
                print(error)
                return
            }
        }
        dismiss(animated: true)
    }
}
