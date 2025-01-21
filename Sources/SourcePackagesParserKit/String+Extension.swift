//
//  String+Extension.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

extension String {
    func replace(of regexPattern: String, with replacement: String) -> String {
        replacingOccurrences(of: regexPattern, with: replacement, options: .regularExpression, range: range(of: self))
    }

    func nest() -> String {
        components(separatedBy: .newlines).map { "    \($0)" }.joined(separator: "\n")
    }
}
