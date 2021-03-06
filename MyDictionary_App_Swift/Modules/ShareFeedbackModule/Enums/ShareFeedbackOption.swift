//
//  ShareFeedbackOption.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 22.09.2021.
//

import Foundation

enum ShareFeedbackOption {
    case featureRequest
    case bugReport
}

extension ShareFeedbackOption: CustomStringConvertible {
    
    var description: String {
        
        switch self {
        case .featureRequest:
            return MDLocalizedText.featureRequest.localized
        case .bugReport:
            return MDLocalizedText.bugReport.localized
        }
        
    }
    
}
