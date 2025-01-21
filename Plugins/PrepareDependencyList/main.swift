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

    func sourcePackages(_ pluginWorkDirectory: URL) throws -> URL {
        var tmpURL = pluginWorkDirectory
        guard pluginWorkDirectory.absoluteURL.path().contains("SourcePackages") else {
            throw SourcePackagesNotFoundError()
        }
        while tmpURL.lastPathComponent != "SourcePackages" {
            tmpURL = tmpURL.deletingLastPathComponent()
        }
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
        return [
            makeBuildCommand(
                executableURL: try context.tool(named: "source-packages-parser").url,
                sourcePackagesURL: try sourcePackages(context.pluginWorkDirectoryURL),
                outputURL: context.pluginWorkDirectoryURL.appending(path: "DependencyList.swift")
            )
        ]
    }
}
