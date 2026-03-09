//
//  String+Extension.swift
//
//
//  Created by Takuto Nakamura on 2022/12/16.
//

extension String {
    func indented() -> String {
        components(separatedBy: .newlines)
            .map { $0.isEmpty ? "" : "    \($0)" }
            .joined(separator: "\n")
    }

    func nested() -> String {
        isEmpty ? "" : "\n\(self)\n"
    }
}
