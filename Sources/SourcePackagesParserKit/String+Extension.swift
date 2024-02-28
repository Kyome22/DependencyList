//
//  String+Extension.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

extension String {
    func replace(of regexPattern: String, with replacement: String) -> String {
        return self.replacingOccurrences(of: regexPattern,
                                         with: replacement,
                                         options: .regularExpression,
                                         range: self.range(of: self))
    }

    func nest() -> String {
        return self.components(separatedBy: .newlines)
            .map { "    \($0)" }
            .joined(separator: "\n")
    }
}
