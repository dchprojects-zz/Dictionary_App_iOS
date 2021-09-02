//
//  CourseListInteractor.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 11.08.2021.

import UIKit

protocol CourseListInteractorInputProtocol {
    var collectionViewDelegate: CourseListCollectionViewDelegateProtocol { get }
    var collectionViewDataSource: CourseListCollectionViewDataSourceProtocol { get }
}

protocol CourseListInteractorOutputProtocol: AnyObject,
                                             AppearanceHasBeenUpdatedProtocol {
    
}

protocol CourseListInteractorProtocol: CourseListInteractorInputProtocol,
                                       CourseListDataManagerOutputProtocol {
    var interactorOutput: CourseListInteractorOutputProtocol? { get set }
}

final class CourseListInteractor: NSObject, CourseListInteractorProtocol {

    fileprivate let dataManager: CourseListDataManagerInputProtocol
    
    internal var collectionViewDelegate: CourseListCollectionViewDelegateProtocol
    internal var collectionViewDataSource: CourseListCollectionViewDataSourceProtocol
    internal weak var interactorOutput: CourseListInteractorOutputProtocol?
    
    init(dataManager: CourseListDataManagerInputProtocol,
         collectionViewDelegate: CourseListCollectionViewDelegateProtocol,
         collectionViewDataSource: CourseListCollectionViewDataSourceProtocol) {
        
        self.dataManager = dataManager
        self.collectionViewDelegate = collectionViewDelegate
        self.collectionViewDataSource = collectionViewDataSource
        
        super.init()
        subscribe()        
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
        unsubscribe()
    }
    
}

// MARK: - CourseListDataManagerOutputProtocol
extension CourseListInteractor {
    
}

// MARK: - Subscribe
fileprivate extension CourseListInteractor {
    
    func subscribe() {
        didChangeAppearanceObservableSubscribe()
    }
    
    func didChangeAppearanceObservableSubscribe() {
        Appearance
            .current
            .didChangeAppearanceObservable
            .addObserver(self) { [weak self] (value) in
                self?.interactorOutput?.appearanceHasBeenUpdated(value)
                self?.dataManager.appearanceHasBeenUpdated(value)
            }
    }
    
}

// MARK: - Unsubscribe
fileprivate extension CourseListInteractor {
    
    func unsubscribe() {
        Appearance
            .current
            .didChangeAppearanceObservable
            .removeObserver(self)
    }
    
}
