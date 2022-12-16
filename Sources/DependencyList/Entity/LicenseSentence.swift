//
//  LicenseSentence.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

public struct LicenseSentence: Identifiable {
    public let id = UUID()
    public let isHyperLink: Bool
    public let body: String
}

public extension StringProtocol {
    func splitLicenseBody() -> [LicenseSentence] {
        let pattern: String = "https?://[A-Za-z0-9\\.\\-\\[\\]!@#$%&=+/?:_]+"
        if let range = self.range(of: pattern, options: .regularExpression) {
            let res: [LicenseSentence] = [
                LicenseSentence(isHyperLink: false, body: String(self[..<range.lowerBound])),
                LicenseSentence(isHyperLink: true, body: String(self[range]))
            ] + self[range.upperBound...].splitLicenseBody()
            return res.compactMap { $0.body.isEmpty ? nil : $0 }
        }
        return [LicenseSentence(isHyperLink: false, body: String(self))]
    }
}
