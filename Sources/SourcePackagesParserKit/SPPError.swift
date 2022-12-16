//
//  SPPError.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

public enum SPPError: LocalizedError {
    case couldNotReadFile(String)
    case couldNotExportLicenseList

    public var errorDescription: String? {
        switch self {
        case .couldNotReadFile(let file):
            return "Could not read \(file)."
        case .couldNotExportLicenseList:
            return "Could not export dependency-list.plist."
        }
    }
}
