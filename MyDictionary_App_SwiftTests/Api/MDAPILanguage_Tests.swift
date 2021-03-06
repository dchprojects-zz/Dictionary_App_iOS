//
//  MDAPILanguage_Tests.swift
//  MyDictionary_App_SwiftTests
//
//  Created by Dmytro Chumakov on 16.09.2021.
//

import XCTest
@testable import MyDictionary_App_Swift

final class MDAPILanguage_Tests: XCTestCase {
    
    fileprivate var apiJWT: MDAPIJWTProtocol!
    fileprivate var apiLanguage: MDAPILanguageProtocol!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let requestDispatcher: MDRequestDispatcherProtocol = MDConstants.RequestDispatcher.defaultRequestDispatcher(reachability: .init())
        
        self.apiLanguage = MDAPILanguage.init(requestDispatcher: requestDispatcher,
                                              operationQueue: Constants_For_Tests.operationQueueManager.operationQueue(byName: MDConstants.QueueName.languageAPIOperationQueue)!)
        
        self.apiJWT = MDAPIJWT.init(requestDispatcher: requestDispatcher,
                                    operationQueue: Constants_For_Tests.operationQueueManager.operationQueue(byName: MDConstants.QueueName.jwtAPIOperationQueue)!)
        
    }
    
}

extension MDAPILanguage_Tests {
    
    func test_Get_Languages() {
        
        let expectation = XCTestExpectation(description: "Get Languages Expectation")
        
        apiJWT.accessToken(jwtApiRequest: Constants_For_Tests.jwtApiRequest) { [unowned self] jwtResult in
            
            switch jwtResult {
                
            case .success(let jwtResponse):
                
                apiLanguage.getLanguages(accessToken: jwtResponse.accessToken) { languageResult in
                    
                    switch languageResult {
                        
                    case .success:
                        
                        expectation.fulfill()
                        
                    case .failure(let error):
                        XCTExpectFailure(error.localizedDescription)
                        expectation.fulfill()
                    }
                    
                }
                
                
            case .failure(let error):
                XCTExpectFailure(error.localizedDescription)
                expectation.fulfill()
            }
            
        }
        
        wait(for: [expectation], timeout: Constants_For_Tests.testExpectationTimeout)
        
    }
    
}

