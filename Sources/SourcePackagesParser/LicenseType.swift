//
//  LicenseType.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

enum LicenseType: String {
    case apache_2 = "Apache license 2.0"
    case mit = "MIT License"
    case bsd_3_clause_clear = "BSD 3-clause Clear license"
    case zlib = "zLib License"
    case boringSSL = "BoringSSL"
    case unknown = "Unknown License"

    var lowercased: String {
        rawValue.lowercased()
    }

    init(text: String) {
        let types: [LicenseType : String] = [
            .apache_2: "Apache License",
            .mit: "MIT License",
            .bsd_3_clause_clear: "Redistribution and use in source and binary forms",
            .zlib: "This software is provided 'as-is', without any express",
            .boringSSL: "BoringSSL is a fork of OpenSSL"
        ]
        self = types.compactMap { key, value -> (LicenseType, String.Index)? in
            guard let range = text.range(of: value) else { return nil }
            return (key, range.lowerBound)
        }
        .sorted { $0.1 < $1.1 }
        .first?.0 ?? .unknown
    }
}
