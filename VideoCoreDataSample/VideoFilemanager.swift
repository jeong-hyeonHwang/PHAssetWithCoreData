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
}
