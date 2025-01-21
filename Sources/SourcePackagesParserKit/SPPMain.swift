//
//  SPPMain.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

public final class SPPMain {
    let outputURL: URL
    let sourcePackagesURL: URL

    public init(_ outputPath: String, _ sourcePackagesPath: String) {
        outputURL = URL(filePath: outputPath)
        sourcePackagesURL = URL(filePath: sourcePackagesPath)
    }

    public func run() throws {
        let workspaceState = try getWorkspaceState()
        let libraries = getLibraries(workspaceState)
        try outputDependencyList(libraries)
    }

    private func getWorkspaceState() throws -> WorkspaceState {
        let workspaceStateURL = sourcePackagesURL.appending(path: "workspace-state.json")
        guard let data = try? Data(contentsOf: workspaceStateURL),
              let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data) else {
            throw SPPError.couldNotReadFile(workspaceStateURL.lastPathComponent)
        }
        return workspaceState
    }

    private func getLibraries(_ workspaceState: WorkspaceState) -> [Library] {
        let checkoutsURL = sourcePackagesURL.appending(path: "checkouts")
        let libraries: [Library] = workspaceState.object.dependencies
            .compactMap { dependency in
                let repositoryName = dependency.packageRef.location
                    .components(separatedBy: "/").last!
                    .replacingOccurrences(of: ".git", with: "")
                let directoryURL = checkoutsURL.appending(path: repositoryName)
                guard let licenseBody = extractLicense(directoryURL) else { return nil }
                return Library(
                    name: dependency.packageRef.name,
                    repositoryURL: dependency.packageRef.location,
                    licenseType: LicenseType(text: licenseBody),
                    licenseBody: licenseBody
                )
            }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }
        return libraries
    }

    private func extractLicense(_ directoryURL: URL) -> String? {
        let fm = FileManager.default
        let contents = (try? fm.contentsOfDirectory(atPath: directoryURL.path())) ?? []
        let licenseURL = contents
            .map { directoryURL.appending(path: $0) }
            .filter { contentURL in
                let fileName = contentURL.deletingPathExtension().lastPathComponent.lowercased()
                guard ["license", "licence"].contains(fileName) else {
                    return false
                }
                var isDiractory: ObjCBool = false
                fm.fileExists(atPath: contentURL.path(), isDirectory: &isDiractory)
                return isDiractory.boolValue == false
            }
            .first
        guard let licenseURL, let text = try? String(contentsOf: licenseURL) else {
            return nil
        }
        return text
    }

    private func outputDependencyList(_ libraries: [Library]) throws {
        var text = ""

        if libraries.isEmpty {
            Swift.print("Warning: No libraries.")
        } else {
            SwiftTree.print(libraries)
            text = libraries
                .map { library in
                    """
                    [
                        "name": "\(library.name)",
                        "repositoryURL": "\(library.repositoryURL)",
                        "licenseType": "\(library.licenseType.rawValue)",
                        "licenseBody": \(library.licenseBody.debugDescription)
                    ]
                    """
                }
                .joined(separator: ",\n")
                .nest()
            text = "\n\(text)\n"
        }
        text = "static let libraries: [[String: String]] = [\(text)]"
        text = "enum SPP {\n\(text.nest())\n}\n"

        if FileManager.default.fileExists(atPath: outputURL.path()) {
            try FileManager.default.removeItem(at: outputURL)
        }

        do {
            try text.data(using: .utf8)?.write(to: outputURL)
        } catch {
            throw SPPError.couldNotExportLicenseList
        }
    }
}
