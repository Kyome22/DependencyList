//
//  Library.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

struct Library: Hashable, CustomStringConvertible {
    var name: String
    var repositoryURL: String
    var licenseType: LicenseType
    var licenseBody: String

    var description: String {
        "\(name), \(repositoryURL)"
    }
}
