//
//  AuthValidation.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 13.08.2021.
//

import Foundation

protocol AuthValidationProtocol {
    var isValid: Bool { get }
    var validationErrors: [AuthValidationError] { get }
}

protocol AuthValidationDataProviderProtocol {
    var nickname: String? { get set }
    var password: String? { get set }
}

final class AuthValidation: NSObject, AuthValidationProtocol {
    
    fileprivate let dataProvider: AuthValidationDataProviderProtocol
    fileprivate let validationTypes: [AuthValidationType]
    
    init(dataProvider: AuthValidationDataProviderProtocol,
         validationTypes: [AuthValidationType]) {
        
        self.dataProvider = dataProvider
        self.validationTypes = validationTypes
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
    public var isValid: Bool {
        return validationErrors.count == .zero
    }
    
    public var validationErrors: [AuthValidationError] {
        return validationResults.filter({ $0.validationError != nil }).map({ $0.validationError! })
    }
    
    fileprivate var validationResults: [AuthValidationResult] {
        var result: [AuthValidationResult] = []
        for type in self.validationTypes {
            switch type {
            case .nickname:
                result.append(AuthValidationLogic.textIsEmpty(validationType: type,
                                                              text: dataProvider.nickname))
            case .password:
                result.append(AuthValidationLogic.textIsEmpty(validationType: type,
                                                              text: dataProvider.password))
            }
        }
        return result
    }
    
}
