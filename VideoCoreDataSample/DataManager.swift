//
//  DataManager.swift
//  VideoCoreDataSample
//
//  Created by 황정현 on 2022/10/19.
//

import UIKit
import CoreData


struct VideoInformation {
    var gymName: String
    var gymVisitDate: Date
    var videoName: String
    var problemLevel: Int
    var isSucceed: Bool
    var feedback: String
    var isFavorite: Bool
    
    init(gymName: String, gymVisitDate: Date, videoName: String, problemLevel: Int, isSucceed: Bool, isFavorite: Bool) {
        self.gymName = gymName
        self.gymVisitDate = gymVisitDate
        self.videoName = videoName
        self.problemLevel = problemLevel
        self.isSucceed = isSucceed
        self.feedback = ""
        self.isFavorite = isFavorite
    }
}

class DataManager {
    static var shared = DataManager()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private lazy var context = appDelegate.persistentContainer.viewContext
    
    init() {
        do {
            try context.fetch(VideoInfo.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addData(info: VideoInformation) {
        let entity = NSEntityDescription.entity(forEntityName: "VideoInfo", in: context)
        
        if let entity = entity {
            let videoInfo = NSManagedObject(entity: entity, insertInto: context)
            videoInfo.setValue(info.gymName, forKey: "gymName")
            videoInfo.setValue(info.gymVisitDate, forKey: "gymVisitDate")
            videoInfo.setValue(info.videoName, forKey: "videoName")
            videoInfo.setValue(info.problemLevel, forKey: "problemLevel")
            videoInfo.setValue(info.isSucceed, forKey: "isSucceed")
            videoInfo.setValue(info.feedback, forKey: "feedback")
            videoInfo.setValue(info.isFavorite, forKey: "isFavorite")
           
            saveData(context: context)
        }
    }
    
    func removeAllData() {
        do {
            let objects = try context.fetch(VideoInfo.fetchRequest())

            for object in objects {
                context.delete(object)
            }
            
        } catch {
            print(error.localizedDescription)
            
        }
        
       saveData(context: context)
    }
    
    func saveData(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchReturnData() -> [VideoInfo] {
        var info: [VideoInfo] = []
        do {
            info = try context.fetch(VideoInfo.fetchRequest())
        } catch {
            print(error.localizedDescription)
        }
        
        return info
    }
    
    func reviseData() {
        do {
            let info = try context.fetch(VideoInfo.fetchRequest())
            info[0].setValue("NOWhere", forKey: "gymName")
        } catch {
            print(error.localizedDescription)
        }
        
        saveData(context: context)
    }
}
