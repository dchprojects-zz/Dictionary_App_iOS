//
//  MDCreateJWTCoreDataStorageOperation.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 16.08.2021.
//

import Foundation
import CoreData

final class MDCreateJWTCoreDataStorageOperation: MDOperation {
    
    fileprivate let managedObjectContext: NSManagedObjectContext
    fileprivate let coreDataStack: CoreDataStack
    fileprivate let coreDataStorage: MDJWTCoreDataStorage
    fileprivate let jwtResponse: JWTResponse
    fileprivate let result: MDOperationResultWithCompletion<JWTResponse>?
    
    init(managedObjectContext: NSManagedObjectContext,
         coreDataStack: CoreDataStack,
         coreDataStorage: MDJWTCoreDataStorage,
         jwtResponse: JWTResponse,
         result: MDOperationResultWithCompletion<JWTResponse>?) {
        
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        self.coreDataStorage = coreDataStorage
        self.jwtResponse = jwtResponse
        self.result = result
        
        super.init()
    }
    
    override func main() {
        
        let newAuthResponse = CDJWTResponseEntity.init(jwtResponse: self.jwtResponse,
                                                       insertIntoManagedObjectContext: self.managedObjectContext)
        
        coreDataStack.savePerformAndWait { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.result?(.success(newAuthResponse.jwtResponse))
                    self?.finish()
                case .failure(let error):
                    self?.result?(.failure(error))
                    self?.finish()
                }
            }
        }
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
        self.finish()
    }
    
}
