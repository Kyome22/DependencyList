//
//  Library.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

struct Library: Hashable, CustomStringConvertible {
    let name: String
    let repositoryURL: String
    let licenseType: LicenseType
    let licenseBody: String

    var description: String {
        return "\(name), \(repositoryURL)"
    }
}
