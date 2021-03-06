//
//  RegistrationPresenter.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 14.08.2021.

import UIKit

protocol RegistrationPresenterInputProtocol {
    
    var textFieldDelegate: UITextFieldDelegate { get }
    
    func registerButtonClicked()
    
    func nicknameTextFieldEditingDidChangeAction(_ text: String?)
    func passwordTextFieldEditingDidChangeAction(_ text: String?)
    func confirmPasswordTextFieldEditingDidChangeAction(_ text: String?)
    
}

protocol RegistrationPresenterOutputProtocol: AnyObject,
                                              MDShowHideUpdateProgressHUD,
                                              MDHideKeyboardProtocol,
                                              MDShowErrorProtocol {
    
    func updateNicknameFieldCounter(_ count: Int)
    func updatePasswordFieldCounter(_ count: Int)
    func updateConfirmPasswordFieldCounter(_ count: Int)
    
    func nicknameTextFieldShouldClearAction()
    
    func makePasswordFieldActive()
    func makeConfirmPasswordFieldActive()
    
}

protocol RegistrationPresenterProtocol: RegistrationPresenterInputProtocol,
                                        RegistrationInteractorOutputProtocol {
    var presenterOutput: RegistrationPresenterOutputProtocol? { get set }
}

final class RegistrationPresenter: NSObject, RegistrationPresenterProtocol {
    
    fileprivate let interactor: RegistrationInteractorInputProtocol
    fileprivate let router: RegistrationRouterProtocol
    
    internal weak var presenterOutput: RegistrationPresenterOutputProtocol?
    
    init(interactor: RegistrationInteractorInputProtocol,
         router: RegistrationRouterProtocol) {
        
        self.interactor = interactor
        self.router = router
        
        super.init()
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - RegistrationInteractorOutputProtocol
extension RegistrationPresenter {
    
    func updateNicknameFieldCounter(_ count: Int) {
        presenterOutput?.updateNicknameFieldCounter(count)
    }
    
    func updatePasswordFieldCounter(_ count: Int) {
        presenterOutput?.updatePasswordFieldCounter(count)
    }
    
    func updateConfirmPasswordFieldCounter(_ count: Int) {
        presenterOutput?.updateConfirmPasswordFieldCounter(count)
    }
    
    func nicknameTextFieldShouldClearAction() {
        presenterOutput?.nicknameTextFieldShouldClearAction()
    }
    
    func makePasswordFieldActive() {
        presenterOutput?.makePasswordFieldActive()
    }
    
    func makeConfirmPasswordFieldActive() {
        presenterOutput?.makeConfirmPasswordFieldActive()
    }
    
    func hideKeyboard() {
        presenterOutput?.hideKeyboard()
    }
    
    func showError(_ error: Error) {
        presenterOutput?.showError(error)
    }
    
    func showCourseList() {
        router.showCourseList()
    }
    
    func showProgressHUD() {
        presenterOutput?.showProgressHUD()
    }
    
    func hideProgressHUD() {
        presenterOutput?.hideProgressHUD()
    }
    
    func updateHUDProgress(_ progress: Float) {
        presenterOutput?.updateHUDProgress(progress)
    }
    
}

// MARK: - RegistrationPresenterInputProtocol
extension RegistrationPresenter {
    
    var textFieldDelegate: UITextFieldDelegate {
        return interactor.textFieldDelegate
    }
    
    // Actions //
    func registerButtonClicked() {
        interactor.registerButtonClicked()
    }
    
    func nicknameTextFieldEditingDidChangeAction(_ text: String?) {
        interactor.nicknameTextFieldEditingDidChangeAction(text)
    }
    
    func passwordTextFieldEditingDidChangeAction(_ text: String?) {
        interactor.passwordTextFieldEditingDidChangeAction(text)
    }
    
    func confirmPasswordTextFieldEditingDidChangeAction(_ text: String?) {
        interactor.confirmPasswordTextFieldEditingDidChangeAction(text)
    }
    // End Actions //
    
}
