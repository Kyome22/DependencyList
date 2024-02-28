//
//  Library.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

public struct Library: Identifiable {
    public let name: String
    public let repositoryURL: String
    public let licenseType: String
    public let licenseBody: String
    public let sentences: [LicenseSentence]

    public var id: String { return name }

    public init(name: String, repositoryURL: String, licenseType: String, licenseBody: String) {
        self.name = name
        self.repositoryURL = repositoryURL
        self.licenseType = licenseType
        self.licenseBody = licenseBody
        self.sentences = licenseBody.splitLicenseBody()
    }

    public static let mock = Library(
        name: "Sample",
        repositoryURL: "https://github.com/sample/Sample.git",
        licenseType: "MIT License",
        licenseBody: (0 ..< 50).map({ _ in "License Body" }).joined(separator: " ")
    )
}

extension Library {
    public static var libraries: [Library] {
        return SPP.libraries.compactMap { info -> Library? in
            guard let name = info["name"],
                  let repositoryURL = info["repositoryURL"],
                  let licenseType = info["licenseType"],
                  let licenseBody = info["licenseBody"] else {
                return nil
            }
            return Library(
                name: name,
                repositoryURL: repositoryURL,
                licenseType: licenseType,
                licenseBody: licenseBody
            )
        }
    }
}
