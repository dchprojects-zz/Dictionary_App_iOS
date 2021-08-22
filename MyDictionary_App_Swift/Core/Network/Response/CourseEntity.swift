//
//  CourseEntity.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 22.08.2021.
//

import Foundation
import CoreData

struct CourseEntity {
    
    let userId: Int64
    let courseId: Int64
    let languageId: Int64
    let languageName: String
    let createdAt: String
    let updatedAt: String
    
}

// MARK: - Core Data
extension CourseEntity {
    
    func cdCourseEntity(insertIntoManagedObjectContext: NSManagedObjectContext) -> CDCourseEntity {
        return .init(courseEntity: self,
                     insertIntoManagedObjectContext: insertIntoManagedObjectContext)
    }
    
}

// MARK: - Decodable
extension CourseEntity: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case courseId = "course_id"
        case languageId = "language_id"
        case languageName = "language_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(Int64.self, forKey: .userId)
        self.courseId = try container.decode(Int64.self, forKey: .courseId)
        self.languageId = try container.decode(Int64.self, forKey: .languageId)
        self.languageName = try container.decode(String.self, forKey: .languageName)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
    }
    
}
