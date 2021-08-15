//
//  MDDeleteUserCoreDataStorageOperation.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 15.08.2021.
//

import CoreData

final class MDDeleteUserCoreDataStorageOperation: MDOperation {
    
    fileprivate let managedObjectContext: NSManagedObjectContext
    fileprivate let coreDataStorage: MDUserCoreDataStorage
    fileprivate let userEntity: UserEntity
    fileprivate let result: MDEntityResult<UserEntity>?
    
    init(managedObjectContext: NSManagedObjectContext,
         coreDataStorage: MDUserCoreDataStorage,
         userEntity: UserEntity,
         result: MDEntityResult<UserEntity>?) {
        
        self.managedObjectContext = managedObjectContext
        self.coreDataStorage = coreDataStorage
        self.userEntity = userEntity
        self.result = result
        
        super.init()
        
    }
    
    override func main() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntityName.CDUserEntity)
        fetchRequest.predicate = NSPredicate(format: "\(CDUserEntityAttributeName.userId) == %i", userEntity.userId)
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            
            try managedObjectContext.execute(batchDeleteRequest)
            
            self.coreDataStorage.savePerform { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        guard let self = self
                        else {
                            self?.result?(.failure(MDUserOperationError.objectRemovedFromMemory));
                            self?.finish() ;
                            return
                        }
                        self.result?(.success(self.userEntity))
                        self.finish()
                    case .failure(let error):
                        self?.result?(.failure(error))
                        self?.finish()
                    }
                }
            }
            
        } catch let error {
            DispatchQueue.main.async {
                self.result?(.failure(error))
                self.finish()
            }
        }
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
        self.finish()
    }
    
}