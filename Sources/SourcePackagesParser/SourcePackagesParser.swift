//
//  SourcePackagesParser.swift
//
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation

final class SourcePackagesParser {
    let outputURL: URL
    let sourcePackagesURL: URL

    init(_ outputPath: String, _ sourcePackagesPath: String) {
        outputURL = URL(filePath: outputPath)
        sourcePackagesURL = URL(filePath: sourcePackagesPath)
    }

    func run() throws {
        let workspaceState = try loadWorkspaceState()
        let libraries = extractLibraries(workspaceState)
        try exportDependencyList(libraries)
    }

    private func loadWorkspaceState() throws -> WorkspaceState {
        let workspaceStateURL = sourcePackagesURL.appending(path: "workspace-state.json")
        guard let data = try? Data(contentsOf: workspaceStateURL),
              let workspaceState = try? JSONDecoder().decode(WorkspaceState.self, from: data) else {
            throw SPPError.couldNotReadFile(workspaceStateURL.lastPathComponent)
        }
        return workspaceState
    }

    private func extractLibraries(_ workspaceState: WorkspaceState) -> [Library] {
        let checkoutsURL = sourcePackagesURL.appending(path: "checkouts")
        let libraries: [Library] = workspaceState.object.dependencies
            .compactMap { dependency in
                let repositoryName = dependency.packageRef.location
                    .components(separatedBy: "/").last!
                    .replacingOccurrences(of: ".git", with: "")
                let directoryURL = checkoutsURL.appending(path: repositoryName)
                guard let licenseBody = extractLicenseBody(directoryURL) else {
                    return nil
                }
                return Library(
                    name: dependency.packageRef.name,
                    url: dependency.packageRef.location,
                    licenseType: LicenseType(text: licenseBody),
                    licenseBody: licenseBody
                )
            }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }
        return libraries
    }

    private func extractLicenseBody(_ directoryURL: URL) -> String? {
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

    private func makeCases(_ range: Range<Int>) -> String {
        let digits = range.numberOfDigits
        return range
            .map { String(format: "case library%0\(digits)d", $0 + 1) }
            .appending("case manual(String, String, String, String)")
            .joined(separator: "\n")
    }

    private func makeAllCases(_ range: Range<Int>) -> String {
        let digits = range.numberOfDigits
        let allCases = range
            .map { String(format: ".library%0\(digits)d,", $0 + 1)  }
            .joined(separator: "\n")
        return "static let allCases: [Self] = [\(allCases.indented().nested())]"
    }

    private func makeComputedProperty(_ libraries: [Library], keyPath: KeyPath<Library, String>) -> String {
        let digits = libraries.numberOfDigits
        let propertyName = String(describing: keyPath)
            .replacingOccurrences(of: #"\Library."#, with: "")
            .replacingOccurrences(of: ".rawValue", with: "")
        let manualValues = ["name", "url", "licenseType", "licenseBody"]
            .map { $0 == propertyName ? "value" : "_" }
            .joined(separator: ", ")
        let cases = libraries
            .map { $0[keyPath: keyPath].debugDescription }
            .enumerated()
            .map { String(format: "case .library%0\(digits)d: %@", $0.offset + 1, $0.element) }
            .appending("case let .manual(\(manualValues)): value")
            .joined(separator: "\n")
        let switchSelf = "switch self {\(cases.nested())}"
        return "var \(propertyName): String {\(switchSelf.indented().nested())}"
    }

    private func exportDependencyList(_ libraries: [Library]) throws {
        if libraries.isEmpty {
            Swift.print("Warning: No libraries.")
        } else {
            let length = libraries.map(\.name.count).max() ?? .zero
            libraries.forEach { library in
                print(library.name.padding(toLength: length, withPad: " ", startingAt: .zero))
            }
        }

        var text = [
            makeCases(libraries.indices),
            makeAllCases(libraries.indices),
            makeComputedProperty(libraries, keyPath: \.name),
            makeComputedProperty(libraries, keyPath: \.url),
            makeComputedProperty(libraries, keyPath: \.licenseType.rawValue),
            makeComputedProperty(libraries, keyPath: \.licenseBody),
        ].joined(separator: "\n\n")

        text = "enum SPPLibrary: Hashable, CaseIterable {\(text.indented().nested())}\n"

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
