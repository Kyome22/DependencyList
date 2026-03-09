//
//  Library.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

public struct Library: Sendable, Identifiable {
    var sppLibrary: SPPLibrary

    public var id = UUID()
    public var name: String { sppLibrary.name }
    public var url: String { sppLibrary.url }
    public var licenseType: String { sppLibrary.licenseType }
    public var licenseBody: String { sppLibrary.licenseBody }

    init(sppLibrary: SPPLibrary) {
        self.sppLibrary = sppLibrary
    }
}

extension Library {
    public static let libraries: [Library] = {
        SPPLibrary.allCases.map(Library.init(sppLibrary:))
    }()
}
