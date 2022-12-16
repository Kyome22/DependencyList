//
//  SPPMain.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

public final class SPPMain {
    public init() {}

    public func run(_ outputPath: String, _ sourcePackagesPath: String) throws {
        let workspaceState = try getWorkspaceState(sourcePackagesPath)
        let libraries = getLibraries(sourcePackagesPath, workspaceState)
        SwiftTree.print(libraries)
        try outputDependencyList(outputPath, libraries)
    }

    func getWorkspaceState(_ path: String) throws -> WorkspaceState {
        let workspaceStateURL = URL(fileURLWithPath: path)
            .appendingPathComponent("workspace-state.json")
        guard let data = try? Data(contentsOf: workspaceStateURL),
              let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data)
        else {
            throw SPPError.couldNotReadFile(workspaceStateURL.lastPathComponent)
        }
        return workspaceState
    }

    func getLibraries(_ path: String,_ workspaceState: WorkspaceState) -> [Library] {
        let checkoutsPath = "\(path)/checkouts"
        let libraries: [Library] = workspaceState.object.dependencies
            .compactMap { dependency in
                let repositoryName = dependency.packageRef.location
                    .components(separatedBy: "/").last!
                    .replacingOccurrences(of: ".git", with: "")
                let directoryURL = URL(fileURLWithPath: checkoutsPath)
                    .appendingPathComponent(repositoryName)
                guard let license = extractLicense(directoryURL) else { return nil }
                return Library(name: dependency.packageRef.name,
                               repositoryURL: dependency.packageRef.location,
                               licenseType: license.0,
                               licenseBody: license.1)
            }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }
        return libraries
    }

    func extractLicense(_ directoryURL: URL) -> (LicenseType, String)? {
        let fm = FileManager.default
        let contents = (try? fm.contentsOfDirectory(atPath: directoryURL.path)) ?? []
        let _licenseURL = contents
            .map { content in
                return directoryURL.appendingPathComponent(content)
            }
            .filter { contentURL in
                if contentURL.deletingPathExtension().lastPathComponent.lowercased() == "license" {
                    var isDiractory: ObjCBool = false
                    fm.fileExists(atPath: contentURL.path, isDirectory: &isDiractory)
                    return isDiractory.boolValue == false
                }
                return false
            }
            .first
        if let licenseURL = _licenseURL,
           let text = try? String(contentsOf: licenseURL) {
            return (LicenseType(licenseText: text), text)
        }
        return nil
    }

    func outputDependencyList(_ outputPath: String, _ libraries: [Library]) throws {
        let saveURL = URL(fileURLWithPath: outputPath)
            .appendingPathComponent("dependency-list.plist")
        let array: [[String: Any]] = libraries.map { library in
            return [
                "name": library.name,
                "repositoryURL": library.repositoryURL,
                "licenseType": library.licenseType.rawValue,
                "licenseBody": library.licenseBody
            ]
        }
        if FileManager.default.fileExists(atPath: saveURL.path) {
            try FileManager.default.removeItem(at: saveURL)
        }
        let dict: [String: Any] = ["libraries": array]
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: dict,
                                                          format: .xml,
                                                          options: .zero)
            try data.write(to: saveURL, options: .atomic)
        } catch {
            throw SPPError.couldNotExportLicenseList
        }
    }
}
