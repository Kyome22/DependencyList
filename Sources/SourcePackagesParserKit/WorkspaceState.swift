//
//  WorkspaceState.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

struct WorkspaceState: Decodable {
    let object: ObjectRef
    let version: Int

    struct ObjectRef: Decodable {
        let dependencies: [DependencyRef]
    }

    struct DependencyRef: Decodable {
        let packageRef: PackageRef
    }

    struct PackageRef: Decodable {
        let identity: String
        let kind: String
        let location: String
        let name: String
    }
}
