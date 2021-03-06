//
//  MDDeleteCourseProtocol.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 23.08.2021.
//

import Foundation

protocol MDDeleteCourseProtocol {
    func deleteCourse(fromCourseId courseId: Int64, _ completionHandler: @escaping(MDOperationResultWithCompletion<Void>))
    func deleteAllCourses(_ completionHandler: @escaping(MDOperationResultWithCompletion<Void>))
}
