//
//  SPPError.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

enum SPPError: Error {
    case couldNotReadFile(String)
    case couldNotExportLicenseList
}
