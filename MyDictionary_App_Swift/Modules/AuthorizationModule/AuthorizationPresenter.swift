//
//  AuthorizationPresenter.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 12.08.2021.

import UIKit

protocol AuthorizationPresenterInputProtocol {
    var textFieldDelegate: UITextFieldDelegate { get }
    func loginButtonClicked()
    func nicknameTextFieldEditingDidChangeAction(_ text: String?)
    func passwordTextFieldEditingDidChangeAction(_ text: String?)
}

protocol AuthorizationPresenterOutputProtocol: AnyObject {
    func makePasswordFieldActive()
    func hideKeyboard()
}

protocol AuthorizationPresenterProtocol: AuthorizationPresenterInputProtocol,
                                         AuthorizationInteractorOutputProtocol {
    var presenterOutput: AuthorizationPresenterOutputProtocol? { get set }
}

final class AuthorizationPresenter: NSObject, AuthorizationPresenterProtocol {
    
    fileprivate let interactor: AuthorizationInteractorInputProtocol
    fileprivate let router: AuthorizationRouterProtocol
    
    internal weak var presenterOutput: AuthorizationPresenterOutputProtocol?
    
    init(interactor: AuthorizationInteractorInputProtocol,
         router: AuthorizationRouterProtocol) {
        
        self.interactor = interactor
        self.router = router
        
        super.init()
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - AuthorizationInteractorOutputProtocol
extension AuthorizationPresenter {
    
    func makePasswordFieldActive() {
        presenterOutput?.makePasswordFieldActive()
    }
    
    func hideKeyboard() {
        presenterOutput?.hideKeyboard()
    }
    
}

// MARK: - AuthorizationPresenterInputProtocol
extension AuthorizationPresenter {
    
    var textFieldDelegate: UITextFieldDelegate {
        return interactor.textFieldDelegate
    }
    
    // Actions //
    func loginButtonClicked() {
        interactor.loginButtonClicked()
    }
    
    func nicknameTextFieldEditingDidChangeAction(_ text: String?) {
        interactor.nicknameTextFieldEditingDidChangeAction(text)
    }
    
    func passwordTextFieldEditingDidChangeAction(_ text: String?) {
        interactor.passwordTextFieldEditingDidChangeAction(text)
    }
    // End Actions //
    
}