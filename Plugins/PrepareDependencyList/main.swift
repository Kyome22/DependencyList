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
    enum SPPError: LocalizedError {
        case sourcePackagesNotFound
        var errorDescription: String? {
            return "SourcePackages not found"
        }
    }

    func sourcePackages(_ pluginWorkDirectory: Path) throws -> Path {
        var tmpPath = pluginWorkDirectory
        guard pluginWorkDirectory.string.contains("SourcePackages") else {
            throw SPPError.sourcePackagesNotFound
        }
        while tmpPath.lastComponent != "SourcePackages" {
            tmpPath = tmpPath.removingLastComponent()
        }
        return tmpPath
    }

    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let executablePath = try context.tool(named: "source-packages-parser").path
        let sourcePackagesPath = try sourcePackages(context.pluginWorkDirectory)
        let outputPath = context.pluginWorkDirectory.appending(["Resources"])
        return [
            .buildCommand(
                displayName: "Prepare DependencyList",
                executable: executablePath,
                arguments: [
                    "-o", outputPath.string,
                    "-s", sourcePackagesPath.string
                ],
                outputFiles: [
                    outputPath.appending(["dependency-list.plist"])
                ]
            ),
        ]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension PrepareDependencyList: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let executablePath = try context.tool(named: "source-packages-parser").path
        let sourcePackagesPath = try sourcePackages(context.pluginWorkDirectory)
        let outputPath = context.pluginWorkDirectory.appending(["Resources"])
        return [
            .buildCommand(
                displayName: "Prepare DependencyList",
                executable: executablePath,
                arguments: [
                    "-o", outputPath.string,
                    "-s", sourcePackagesPath.string
                ],
                outputFiles: [
                    outputPath.appending(["dependency-list.plist"])
                ]
            ),
        ]
    }
}
#endif
