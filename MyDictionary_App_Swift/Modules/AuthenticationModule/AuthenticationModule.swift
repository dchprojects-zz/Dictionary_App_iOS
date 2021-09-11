//
//  AuthenticationModule.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 12.08.2021.

import UIKit

final class AuthenticationModule {
    
    let sender: Any?
    
    init(sender: Any?) {
        self.sender = sender
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

extension AuthenticationModule {
    
    var module: UIViewController {
        
        let dataProvider: AuthenticationDataProviderProtocol = AuthenticationDataProvider.init()
        var dataManager: AuthenticationDataManagerProtocol = AuthenticationDataManager.init(dataProvider: dataProvider)
        
        let textFieldDelegate: AuthTextFieldDelegateProtocol = AuthTextFieldDelegate.init()
        
        let validationTypes: [AuthValidationType] = [.nickname, .password]
        let authValidation: AuthValidationProtocol = AuthValidation.init(dataProvider: dataProvider,
                                                                         validationTypes: validationTypes)                
        
        let apiAuth: MDAPIAuthProtocol = MDAPIAuth.init(requestDispatcher: MDConstants.RequestDispatcher.defaultRequestDispatcher(reachability: MDConstants.AppDependencies.dependencies.reachability),
                                                        operationQueueService: MDConstants.AppDependencies.dependencies.operationQueueService)
        
        let sync: MDSyncProtocol = MDSync.init(apiJWT: MDConstants.AppDependencies.dependencies.apiJWT,
                                               jwtStorage: MDConstants.AppDependencies.dependencies.jwtStorage,
                                               apiUser: MDConstants.AppDependencies.dependencies.apiUser,
                                               userStorage: MDConstants.AppDependencies.dependencies.userStorage,
                                               apiLanguage: MDConstants.AppDependencies.dependencies.apiLanguage,
                                               languageStorage: MDConstants.AppDependencies.dependencies.languageStorage,
                                               apiCourse: MDConstants.AppDependencies.dependencies.apiCourse,
                                               courseStorage: MDConstants.AppDependencies.dependencies.courseStorage,
                                               apiWord: MDConstants.AppDependencies.dependencies.apiWord,
                                               wordStorage: MDConstants.AppDependencies.dependencies.wordStorage)
        
        let syncManager: MDSyncManagerProtocol = MDSyncManager.init(sync: sync)
        let authManager: MDAuthManagerProtocol = MDAuthManager.init(apiAuth: apiAuth,
                                                                    appSettings: MDConstants.AppDependencies.dependencies.appSettings,
                                                                    syncManager: syncManager)
        
        let interactor: AuthenticationInteractorProtocol = AuthenticationInteractor.init(dataManager: dataManager,
                                                                                         authValidation: authValidation,
                                                                                         textFieldDelegate: textFieldDelegate,
                                                                                         authManager: authManager)
        
        var router: AuthenticationRouterProtocol = AuthenticationRouter.init()
        let presenter: AuthenticationPresenterProtocol = AuthenticationPresenter.init(interactor: interactor, router: router)
        let vc = AuthenticationViewController.init(presenter: presenter)
        
        presenter.presenterOutput = vc
        interactor.interactorOutput = presenter
        dataManager.dataManagerOutput = interactor
        router.presenter = vc
        
        return vc
        
    }
    
}