//
//  MDAuthManager.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 21.08.2021.
//

import Foundation

protocol MDAuthManagerProtocol {
    func login(authRequest: AuthRequest, completionHandler: @escaping(MDAuthResultWithCompletion))
    func register(authRequest: AuthRequest, completionHandler: @escaping(MDAuthResultWithCompletion))
}

final class MDAuthManager: MDAuthManagerProtocol {
    
    fileprivate let apiAuth: MDAPIAuthProtocol
    fileprivate let userStorage: MDUserStorageProtocol
    fileprivate let jwtStorage: MDJWTStorageProtocol
    fileprivate let keychainService: KeychainService
    
    init(apiAuth: MDAPIAuthProtocol,
         userStorage: MDUserStorageProtocol,
         jwtStorage: MDJWTStorageProtocol,
         keychainService: KeychainService) {
        
        self.apiAuth = apiAuth
        self.userStorage = userStorage
        self.jwtStorage = jwtStorage
        self.keychainService = keychainService
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension MDAuthManager {
    
    func login(authRequest: AuthRequest, completionHandler: @escaping(MDAuthResultWithCompletion)) {
        
        apiAuth.login(authRequest: authRequest) { [weak self] loginResult in
            
            switch loginResult {
            
            case .success(let authResponse):
                
                self?.saveUserAndJWTAndUserPassword(authRequest: authRequest,
                                                    authResponse: authResponse,
                                                    completionHandler: completionHandler)
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
        
    }
    
    func register(authRequest: AuthRequest, completionHandler: @escaping(MDAuthResultWithCompletion)) {
        
        apiAuth.register(authRequest: authRequest) { [weak self] registerResult in
            
            switch registerResult {
            
            case .success(let authResponse):
                
                self?.saveUserAndJWTAndUserPassword(authRequest: authRequest,
                                                    authResponse: authResponse,
                                                    completionHandler: completionHandler)
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
        
    }
    
}

// MARK: - Save
fileprivate extension MDAuthManager {
    
    func saveUserAndJWTAndUserPassword(authRequest: AuthRequest,
                                       authResponse: AuthResponse,
                                       completionHandler: @escaping(MDAuthResultWithCompletion)) {
        
        let dispatchGroup: DispatchGroup = .init()
        
        // Save User
        dispatchGroup.enter()
        self.saveUser(userEntity: authResponse.userEntity) { (saveUserResult) in
            
            switch saveUserResult {
            
            case .success:
                
                dispatchGroup.leave()
                
            case .failure(let error):
                dispatchGroup.leave()
                completionHandler(.failure(error))
            }
            
        }
        
        // Save JWT
        dispatchGroup.enter()
        self.saveJWT(jwtResponse: authResponse.jwtResponse) { (saveJWTResult) in
            switch saveJWTResult {
            
            case .success:
                
                dispatchGroup.leave()
                
            case .failure(let error):
                dispatchGroup.leave()
                completionHandler(.failure(error))
            }
            
        }
        
        // Pass Result
        dispatchGroup.notify(queue: .main) {
            // Save Password In Keychain
            self.savePassword(authRequest: authRequest)
            //
            completionHandler(.success(()))
        }
        
    }
    
    func saveUser(userEntity: UserEntity, completionHandler: @escaping(MDUserResultWithCompletion)) {
        
        var userResults: [MDStorageType : UserEntity] = [ : ]
        
        self.userStorage.createUser(userEntity, storageType: .all) { (createUserResults) in
            
            createUserResults.forEach { createUserResult in
                
                switch createUserResult.result {
                
                case .success(let userEntity):
                    
                    userResults.updateValue(userEntity, forKey: createUserResult.storageType)
                    
                    if (userResults.count == createUserResults.count) {
                        completionHandler(.success(userResults.first!.value))
                    }
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
                
            }
            
        }
    }
    
    func saveJWT(jwtResponse: JWTResponse, completionHandler: @escaping(MDJWTResultWithCompletion)) {
        
        var jwtResults: [MDStorageType : JWTResponse] = [ : ]
        
        self.jwtStorage.createJWT(storageType: .all, jwtResponse: jwtResponse) { (createJWTResults) in
            
            createJWTResults.forEach { createJWTResult in
                
                switch createJWTResult.result {
                
                case .success(let jwtEntity):
                    
                    jwtResults.updateValue(jwtEntity, forKey: createJWTResult.storageType)
                    
                    if (createJWTResults.count == createJWTResults.count) {
                        completionHandler(.success(jwtResults.first!.value))
                    }
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
                
            }
            
        }
        
    }
    
    func savePassword(authRequest: AuthRequest) {
        
        keychainService.savePassword(authRequest.password,
                                     for: authRequest.nickname)
        
    }
    
}