//
//  VideoFilemanager.swift
//  VideoCoreDataSample
//
//  Created by 황정현 on 2022/10/21.
//

import UIKit
import Photos
import AVKit

class VideoFileManager {
    
    static let shared: VideoFileManager = VideoFileManager()
    
    // PHAsset의 ::URL::을 기반으로 영상을 Play하는 메소드
    func playVideo(view:UIViewController, asset:PHAsset) {

            guard (asset.mediaType == PHAssetMediaType.video)

                else {
                    print("Not a valid video media type")
                    return
            }

            PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil) { (assets, audioMix, info) in
                let asset = assets as! AVURLAsset
                DispatchQueue.main.async {

                    let player = AVPlayer(url: asset.url)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    view.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
            }
        }

    
    
    func saveVideo(url: URL, name: String,
                   onSuccess: @escaping ((Bool) -> Void)) {
        let video = NSData(contentsOf: url)
        let targetDirectory = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask)[0]
        let fileURL = targetDirectory.appendingPathComponent(name)
        do {
            // MARK: For Log Test
            print(targetDirectory)
            
            try video?.write(to: fileURL)
            
            // MARK: For Log Test
            let contentUrls = try FileManager.default.contentsOfDirectory(at: .documentsDirectory, includingPropertiesForKeys: nil)
            print(contentUrls)
        } catch let error as NSError {
            print("Failed to Save Video: \(error), \(error.userInfo)")
        }
    }
}
