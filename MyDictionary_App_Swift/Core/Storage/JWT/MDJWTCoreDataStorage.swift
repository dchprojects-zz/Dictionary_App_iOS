//
//  MDJWTCoreDataStorage.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 15.08.2021.
//

import Foundation
import CoreData

protocol MDJWTCoreDataStorageProtocol: MDCRUDJWTProtocol,
                                       MDStorageInterface {
    
}

final class MDJWTCoreDataStorage: NSObject,
                                  MDJWTCoreDataStorageProtocol {
    
    fileprivate let operationQueue: OperationQueue
    fileprivate let managedObjectContext: NSManagedObjectContext
    fileprivate let coreDataStack: MDCoreDataStack
    
    init(operationQueue: OperationQueue,
         managedObjectContext: NSManagedObjectContext,
         coreDataStack: MDCoreDataStack) {
        
        self.operationQueue = operationQueue
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - Entities
extension MDJWTCoreDataStorage {
    
    func entitiesCount(_ completionHandler: @escaping(MDEntitiesCountResultWithCompletion)) {
        self.readAllJWTs() { result in
            switch result {
            case .success(let entities):
                completionHandler(.success(entities.count))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func entitiesIsEmpty(_ completionHandler: @escaping(MDEntitiesIsEmptyResultWithCompletion)) {
        self.readAllJWTs() { result in
            switch result {
            case .success(let entities):
                completionHandler(.success(entities.isEmpty))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}

// MARK: - Create
extension MDJWTCoreDataStorage {
    
    func createJWT(_ jwtResponse: JWTResponse, _ completionHandler: @escaping(MDOperationResultWithCompletion<JWTResponse>)) {
        let operation = MDCreateJWTCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                                 coreDataStack: self.coreDataStack,
                                                                 coreDataStorage: self,
                                                                 jwtResponse: jwtResponse) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
}

// MARK: - Read
extension MDJWTCoreDataStorage {
    
    func readJWT(fromAccessToken accessToken: String, _ completionHandler: @escaping(MDOperationResultWithCompletion<JWTResponse>)) {
        let operation = MDReadJWTCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                               coreDataStorage: self,
                                                               accessToken: accessToken) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
    func readFirstJWT(_ completionHandler: @escaping (MDOperationResultWithCompletion<JWTResponse>)) {
        let operation = MDReadFirstJWTCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                                    coreDataStorage: self) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
    func readAllJWTs(_ completionHandler: @escaping (MDOperationsResultWithCompletion<JWTResponse>)) {
        let operation = MDReadJWTsCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                                coreDataStorage: self) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
}


// MARK: - Update
extension MDJWTCoreDataStorage {
    
    func updateJWT(oldAccessToken accessToken: String,
                   newJWTResponse jwtResponse: JWTResponse,
                   _ completionHandler: @escaping (MDOperationResultWithCompletion<Void>)) {
        
        let operation = MDUpdateJWTCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                                 coreDataStack: self.coreDataStack,
                                                                 coreDataStorage: self,
                                                                 oldAccessToken: accessToken,
                                                                 newJWTResponse: jwtResponse) { result in
            completionHandler(result)
        }
        
        operationQueue.addOperation(operation)
        
    }
    
}

// MARK: - Delete
extension MDJWTCoreDataStorage {
    
    func deleteJWT(_ byAccessToken: String, _ completionHandler: @escaping(MDOperationResultWithCompletion<Void>)) {
        let operation = MDDeleteJWTCoreDataStorageOperation.init(managedObjectContext: self.managedObjectContext,
                                                                 coreDataStack: self.coreDataStack,
                                                                 coreDataStorage: self,
                                                                 accessToken: byAccessToken) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
    func deleteAllJWT(_ completionHandler: @escaping(MDOperationResultWithCompletion<Void>)) {
        let operation: MDDeleteAllJWTCoreDataStorageOperation = .init(managedObjectContext: self.managedObjectContext,
                                                                      coreDataStack: self.coreDataStack,
                                                                      coreDataStorage: self) { result in
            completionHandler(result)
        }
        operationQueue.addOperation(operation)
    }
    
}
