//
//  main.swift
//  
//
//  Created by Takuto Nakamura on 2022/12/16.
//

import Foundation
import PackagePlugin

@main
struct PrepareDependencyList: BuildToolPlugin {
    struct SourcePackagesNotFoundError: Error & CustomStringConvertible {
        let description: String = "SourcePackages not found"
    }

    func existsSourcePackages(in url: URL) throws -> Bool {
        guard url.isFileURL,
              url.pathComponents.count > 1,
              let isDirectory = try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory else {
            throw SourcePackagesNotFoundError()
        }
        let existsSourcePackagesInDirectory = FileManager.default
            .fileExists(atPath: url.appending(path: "SourcePackages").path())
        return isDirectory && existsSourcePackagesInDirectory
    }

    func sourcePackages(_ pluginWorkDirectory: URL) throws -> URL {
        var tmpURL = pluginWorkDirectory.absoluteURL

        while try !existsSourcePackages(in: tmpURL) {
            tmpURL.deleteLastPathComponent()
        }
        tmpURL.append(path: "SourcePackages")
        return tmpURL
    }

    func makeBuildCommand(executableURL: URL, sourcePackagesURL: URL, outputURL: URL) -> Command {
        .buildCommand(
            displayName: "Prepare DependencyList",
            executable: executableURL,
            arguments: [
                "-o", outputURL.absoluteURL.path(),
                "-s", sourcePackagesURL.absoluteURL.path()
            ],
            outputFiles: [
                outputURL
            ]
        )
    }

    // This command works with the plugin specified in `Package.swift`
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        [
            makeBuildCommand(
                executableURL: try context.tool(named: "source-packages-parser").url,
                sourcePackagesURL: try sourcePackages(context.pluginWorkDirectoryURL),
                outputURL: context.pluginWorkDirectoryURL.appending(path: "DependencyList.swift")
            )
        ]
    }
}
