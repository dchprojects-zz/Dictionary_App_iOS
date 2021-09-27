//
//  AddWordViewController.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 27.09.2021.

import UIKit

final class AddWordViewController: MDBaseTitledBackNavigationBarViewController {
    
    fileprivate let presenter: AddWordPresenterInputProtocol
    
    fileprivate static let wordTextFieldHeight: CGFloat = 48
    fileprivate static let wordTextFieldTopOffset: CGFloat = 24
    fileprivate static let wordTextFieldLeftOffset: CGFloat = 16
    fileprivate static let wordTextFieldRightOffset: CGFloat = 16
    fileprivate let wordTextField: MDTextFieldWithToolBar = {
        let textField: MDTextFieldWithToolBar = MDTextFieldWithToolBar.init(rectInset: MDConstants.Rect.defaultInset,
                                                                            keyboardToolbar: MDKeyboardToolbar.init())
        textField.placeholder = MDLocalizedText.wordText.localized
        textField.autocorrectionType = .no
        textField.textAlignment = .left
        textField.clearButtonMode = .whileEditing
        textField.font = MDUIResources.Font.MyriadProItalic.font()
        textField.textColor = MDUIResources.Color.md_3C3C3C.color()
        textField.returnKeyType = .next
        textField.backgroundColor = MDUIResources.Color.md_FFFFFF.color()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate static let wordDescriptionTextViewTopOffset: CGFloat = 10
    fileprivate static let wordDescriptionTextViewLeftOffset: CGFloat = 16
    fileprivate static let wordDescriptionTextViewRightOffset: CGFloat = 16
    fileprivate static let wordDescriptionTextViewBottomOffset: CGFloat = .zero
    fileprivate let wordDescriptionTextView: UITextView = {
        let textView: UITextView = .init()
        textView.autocorrectionType = .no
        textView.textAlignment = .left
        textView.font = MDUIResources.Font.MyriadProItalic.font()
        textView.textColor = MDUIResources.Color.md_3C3C3C.color()
        textView.returnKeyType = .done
        textView.backgroundColor = MDUIResources.Color.md_FFFFFF.color()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    init(presenter: AddWordPresenterInputProtocol) {
        self.presenter = presenter
        super.init(title: MDLocalizedText.addWord.localized,
                   navigationBarBackgroundImage: MDUIResources.Image.background_navigation_bar_1.image)
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        addViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
        roundOffEdges()
        dropShadow()
    }
    
}

// MARK: - AddWordPresenterOutputProtocol
extension AddWordViewController: AddWordPresenterOutputProtocol {
    
}

// MARK: - Add Views
fileprivate extension AddWordViewController {
    
    func addViews() {
        addWordTextField()
        addWordDescriptionTextView()
    }
    
    func addWordTextField() {
        view.addSubview(wordTextField)
    }
    
    func addWordDescriptionTextView() {
        view.addSubview(wordDescriptionTextView)
    }
    
}

// MARK: - Add Constraints
fileprivate extension AddWordViewController {
    
    func addConstraints() {
        addWordTextFieldConstraints()
        addWordDescriptionTextViewConstraints()
    }
    
    func addWordTextFieldConstraints() {
        
        NSLayoutConstraint.addEqualConstraint(item: self.wordTextField,
                                              attribute: .top,
                                              toItem: self.navigationBarView,
                                              attribute: .bottom,
                                              constant: Self.wordTextFieldTopOffset)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.wordTextField,
                                                  toItem: self.view,
                                                  constant: Self.wordTextFieldLeftOffset)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.wordTextField,
                                                   toItem: self.view,
                                                   constant: -Self.wordTextFieldRightOffset)
        
        NSLayoutConstraint.addEqualHeightConstraint(item: self.wordTextField,
                                                    constant: Self.wordTextFieldHeight)
        
    }
    
    func addWordDescriptionTextViewConstraints() {
        
        NSLayoutConstraint.addEqualConstraint(item: self.wordDescriptionTextView,
                                              attribute: .top,
                                              toItem: self.wordTextField,
                                              attribute: .bottom,
                                              constant: Self.wordDescriptionTextViewTopOffset)
        
        NSLayoutConstraint.addEqualLeftConstraint(item: self.wordDescriptionTextView,
                                                  toItem: self.view,
                                                  constant: Self.wordDescriptionTextViewLeftOffset)
        
        NSLayoutConstraint.addEqualRightConstraint(item: self.wordDescriptionTextView,
                                                   toItem: self.view,
                                                   constant: -Self.wordDescriptionTextViewRightOffset)
        
        NSLayoutConstraint.addEqualBottomConstraint(item: self.wordDescriptionTextView,
                                                    toItem: self.view,
                                                    constant: Self.wordDescriptionTextViewBottomOffset)
        
        
    }
    
}

// MARK: - Drop Shadow
fileprivate extension AddWordViewController {
    
    func dropShadow() {
        dropShadowWordTextField()
        dropShadowWordDescriptionTextView()
    }
    
    func dropShadowWordTextField() {
        wordTextField.dropShadow(color: MDUIResources.Color.md_5200FF.color(0.5),
                                 offSet: .init(width: 2, height: 4),
                                 radius: 15)
    }
    
    func dropShadowWordDescriptionTextView() {
        wordDescriptionTextView.dropShadow(color: MDUIResources.Color.md_5200FF.color(0.5),
                                           offSet: .init(width: 2, height: 4),
                                           radius: 15)
    }
    
}

// MARK: - Round Off Edges
fileprivate extension AddWordViewController {
    
    func roundOffEdges() {
        roundOffEdgesWordTextField()
        roundOffEdgesWordDescriptionTextView()
    }
    
    func roundOffEdgesWordTextField() {
        wordTextField.layer.cornerRadius = 10
    }
    
    func roundOffEdgesWordDescriptionTextView() {
        wordDescriptionTextView.layer.cornerRadius = 10
    }
    
}

// MARK: - Actions
fileprivate extension AddWordViewController {
    
    
    
}
