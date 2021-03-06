//
//  RegistrationInteractor.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 14.08.2021.

import UIKit

protocol RegistrationInteractorInputProtocol {
    
    var textFieldDelegate: RegisterTextFieldDelegateProtocol { get }
    
    func nicknameTextFieldEditingDidChangeAction(_ text: String?)
    func passwordTextFieldEditingDidChangeAction(_ text: String?)
    func confirmPasswordTextFieldEditingDidChangeAction(_ text: String?)
    
    func registerButtonClicked()
    
}

protocol RegistrationInteractorOutputProtocol: AnyObject,
                                               MDShowHideUpdateProgressHUD,
                                               MDHideKeyboardProtocol,
                                               MDShowErrorProtocol {
    
    func makePasswordFieldActive()
    func makeConfirmPasswordFieldActive()
    
    func updateNicknameFieldCounter(_ count: Int)
    func updatePasswordFieldCounter(_ count: Int)
    func updateConfirmPasswordFieldCounter(_ count: Int)
    
    func nicknameTextFieldShouldClearAction()
    
    func showCourseList()
    
}

protocol RegistrationInteractorProtocol: RegistrationInteractorInputProtocol,
                                         RegistrationDataManagerOutputProtocol {
    var interactorOutput: RegistrationInteractorOutputProtocol? { get set }
}

final class RegistrationInteractor: NSObject, RegistrationInteractorProtocol {
    
    fileprivate let dataManager: RegistrationDataManagerInputProtocol
    fileprivate let registerValidation: RegisterValidationProtocol
    fileprivate let apiManager: MDAuthManagerProtocol
    
    internal weak var interactorOutput: RegistrationInteractorOutputProtocol?
    
    internal var textFieldDelegate: RegisterTextFieldDelegateProtocol
    
    init(dataManager: RegistrationDataManagerInputProtocol,
         registerValidation: RegisterValidationProtocol,
         textFieldDelegate: RegisterTextFieldDelegateProtocol,
         apiManager: MDAuthManagerProtocol) {
        
        self.dataManager = dataManager
        self.registerValidation = registerValidation
        self.textFieldDelegate = textFieldDelegate
        self.apiManager = apiManager
        
        super.init()
        subscribe()
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
}

// MARK: - RegistrationDataManagerOutputProtocol
extension RegistrationInteractor {
    
}

// MARK: - AuthorizationInteractorInputProtocol
extension RegistrationInteractor {
    
    // Actions //
    
    func nicknameTextFieldEditingDidChangeAction(_ text: String?) {
        dataManager.setNickname(text)
    }
    
    func passwordTextFieldEditingDidChangeAction(_ text: String?) {
        dataManager.setPassword(text)
    }
    
    func confirmPasswordTextFieldEditingDidChangeAction(_ text: String?) {
        dataManager.setConfirmPassword(text)
    }
    
    func registerButtonClicked() {
        interactorOutput?.hideKeyboard()
        authValidationAndRouting()
    }
    
    // End Actions //
}

// MARK: - Subscribe
fileprivate extension RegistrationInteractor {
    
    func subscribe() {
        
        nicknameTextFieldShouldReturnActionSubscribe()
        passwordTextFieldShouldReturnActionSubscribe()
        confirmPasswordTextFieldShouldReturnActionSubscribe()
        
        updateNicknameTextFieldCounterActionSubscribe()
        updatePasswordTextFieldCounterActionSubscribe()
        updateConfirmPasswordTextFieldCounterActionSubscribe()
        
        nicknameTextFieldShouldClearActionSubscribe()
        
    }
    
    func nicknameTextFieldShouldReturnActionSubscribe() {
        textFieldDelegate.nicknameTextFieldShouldReturnAction = { [weak self] in
            self?.interactorOutput?.makePasswordFieldActive()
        }
    }
    
    func passwordTextFieldShouldReturnActionSubscribe() {
        textFieldDelegate.passwordTextFieldShouldReturnAction = { [weak self] in
            self?.interactorOutput?.makeConfirmPasswordFieldActive()
        }
    }
    
    func confirmPasswordTextFieldShouldReturnActionSubscribe() {
        textFieldDelegate.confirmPasswordTextFieldShouldReturnAction = { [weak self] in
            self?.interactorOutput?.hideKeyboard()
            self?.authValidationAndRouting()
        }
    }
    
    func updateNicknameTextFieldCounterActionSubscribe() {
        textFieldDelegate.updateNicknameTextFieldCounterAction = { [weak self] (count) in
            self?.interactorOutput?.updateNicknameFieldCounter(count)
        }
    }
    
    func updatePasswordTextFieldCounterActionSubscribe() {
        textFieldDelegate.updatePasswordTextFieldCounterAction = { [weak self] (count) in
            self?.interactorOutput?.updatePasswordFieldCounter(count)
        }
    }
    
    func updateConfirmPasswordTextFieldCounterActionSubscribe() {
        textFieldDelegate.updateConfirmPasswordTextFieldCounterAction = { [weak self] (count) in
            self?.interactorOutput?.updateConfirmPasswordFieldCounter(count)
        }
    }
    
    func nicknameTextFieldShouldClearActionSubscribe() {
        textFieldDelegate.nicknameTextFieldShouldClearAction = { [weak self] in
            self?.interactorOutput?.nicknameTextFieldShouldClearAction()
        }
    }
    
}

// MARK: - Auth Validation And Routing
fileprivate extension RegistrationInteractor {
    
    func authValidationAndRouting() {
        
        if (registerValidation.isValid) {
            
            // Show Progress HUD
            interactorOutput?.showProgressHUD()
            
            let authRequest: AuthRequest = .init(nickname: dataManager.getNickname()!,
                                                 password: dataManager.getPassword()!)
            
            apiManager.register(authRequest: authRequest) { [weak self] progress in
                
                DispatchQueue.main.async {
                    self?.interactorOutput?.updateHUDProgress(progress)
                }
                
            } completionHandler: { [weak self] (result) in
                
                switch result {
                    
                case .success:
                    
                    DispatchQueue.main.async {
                        
                        // Hide Progress HUD
                        self?.interactorOutput?.hideProgressHUD()
                        //
                        self?.interactorOutput?.showCourseList()
                        //
                        
                    }
                    
                    //
                    break
                    //
                    
                case .failure(let error):
                    
                    DispatchQueue.main.async {
                        
                        // Hide Progress HUD
                        self?.interactorOutput?.hideProgressHUD()
                        //
                        self?.interactorOutput?.showError(error)
                        //
                        
                    }
                    
                    //
                    break
                    //
                    
                }
                
            }
        } else {
            interactorOutput?.showError(registerValidation.validationErrors.first!)
        }
        
    }
    
}
