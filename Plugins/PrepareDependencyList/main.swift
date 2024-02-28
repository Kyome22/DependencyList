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

    func sourcePackages(_ pluginWorkDirectory: Path) throws -> Path {
        var tmpPath = pluginWorkDirectory
        guard pluginWorkDirectory.string.contains("SourcePackages") else {
            throw SourcePackagesNotFoundError()
        }
        while tmpPath.lastComponent != "SourcePackages" {
            tmpPath = tmpPath.removingLastComponent()
        }
        return tmpPath
    }

    func makeBuildCommand(executablePath: Path, sourcePackagesPath: Path, outputPath: Path) -> Command {
        return .buildCommand(
            displayName: "Prepare DependencyList",
            executable: executablePath,
            arguments: [
                "-o", outputPath.string,
                "-s", sourcePackagesPath.string
            ],
            outputFiles: [
                outputPath.appending(["DependencyList.swift"])
            ]
        )
    }

    // This command works with the plugin specified in `Package.swift`
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return [
            makeBuildCommand(
                executablePath: try context.tool(named: "source-packages-parser").path,
                sourcePackagesPath: try sourcePackages(context.pluginWorkDirectory),
                outputPath: context.pluginWorkDirectory
            )
        ]
    }
}
