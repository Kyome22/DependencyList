//
//  String+Extension.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }

    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
