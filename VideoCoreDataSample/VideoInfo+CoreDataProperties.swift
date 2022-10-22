//
//  VideoInfo+CoreDataProperties.swift
//  VideoCoreDataSample
//
//  Created by 황정현 on 2022/10/19.
//
//

import Foundation
import CoreData


extension VideoInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VideoInfo> {
        return NSFetchRequest<VideoInfo>(entityName: "VideoInfo")
    }

    @NSManaged public var gymName: String?
    @NSManaged public var gymVisitDate: Date?
    @NSManaged public var videoName: String?
    @NSManaged public var problemLevel: Int16
    @NSManaged public var isSucceed: Bool
    @NSManaged public var feedback: String?
    @NSManaged public var isFavorite: Bool

}

extension VideoInfo : Identifiable {

}
